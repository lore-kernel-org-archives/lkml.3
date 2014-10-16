Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaJQHC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:02:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:52344 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbaJQHC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,737,1406617200"; 
   d="scan'208";a="606869044"
Date: Thu, 16 Oct 2014 17:29:23 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Calvin Owens <jcalvinowens@gmail.com>
Subject: Re: [PATCH v11 09/21] dax,ext2: Replace the XIP page fault handler
 with the DAX page fault handler
Message-ID: <20141016212923.GG11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-10-git-send-email-matthew.r.wilcox@intel.com>
 <20141016102047.GG19075@thinkos.etherlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016102047.GG19075@thinkos.etherlink>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 12:20:47PM +0200, Mathieu Desnoyers wrote:
> > +/*
> > + * The user has performed a load from a hole in the file.  Allocating
> > + * a new page in the file would cause excessive storage usage for
> > + * workloads with sparse files.  We allocate a page cache page instead.
> > + * We'll kick it out of the page cache if it's ever written to,
> > + * otherwise it will simply fall out of the page cache under memory
> > + * pressure without ever having been dirtied.
> 
> Nice trick :)

It's basically what the page cache does.  Unfortunately, I had to step
out of the room while Calvin detailed his trick for doing it differently,
but if his patch goes in, we should follow suit.

> > +		if (!page) {
> > +			mutex_lock(&mapping->i_mmap_mutex);
> > +			/* Check we didn't race with truncate */
> > +			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
> > +								PAGE_SHIFT;
> > +			if (vmf->pgoff >= size) {
> > +				mutex_unlock(&mapping->i_mmap_mutex);
> > +				error = -EIO;
> > +				goto out;
> > +			}
> > +		}
> 
> If page is non-NULL, is it possible that we return VM_FAULT_LOCKED
> without actually holding i_mmap_mutex ? Is it on purpose ?
> 
> > +		return VM_FAULT_LOCKED;
> > +	}

That's right; this is the original meaning of VM_FAULT_LOCKED, that the
page lock is held.  We took it before the call to get_block(), ensuring
that we don't hit the truncate race.  Er ... hang on.  At some point in
the revising of patches, I dropped the stanza where we re-check i_size
after grabbing the page lock.  Sod ... a v12 of this patchset will have
to be forthcoming!
