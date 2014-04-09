Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056AbaDIVnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:43:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933908AbaDIVne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:43:34 -0400
Date: Wed, 9 Apr 2014 23:43:31 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140409214331.GQ32103@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409102758.GM32103@quack.suse.cz>
 <20140409205111.GG5727@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409205111.GG5727@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-04-14 16:51:11, Matthew Wilcox wrote:
> On Wed, Apr 09, 2014 at 12:27:58PM +0200, Jan Kara wrote:
> > > +	if (unlikely(vmf->pgoff >= size)) {
> > > +		mutex_unlock(&mapping->i_mmap_mutex);
> > > +		goto sigbus;
> >   You need to release the block you've got from the filesystem in case of
> > error here an below.
> 
> What's the API to do that?  Call inode->i_op->setattr()?
  That's a great question. Yes, ->setattr() is the only API you have for
that but you cannot use that because of locking constraints (it needs
i_mutex and that's not possible to get in the fault path). Let me read
again what the handler does...

So there are three places that can fail after we allocate the block:
1) We race with truncate reducing i_size
2) dax_get_pfn() fails
3) vm_insert_mixed() fails

I would guess that 2) can fail only if the HW has problems and leaking
block in that case could be acceptable (please correct me if I'm wrong).
3) shouldn't fail because of ENOMEM because fault has already allocated all
the page tables and EBUSY should be handled as well. So the only failure we
have to care about is 1). And we could move ->get_block() call under
i_mmap_mutex after the i_size check.  Lock ordering should be fine because
i_mmap_mutex ranks above page lock under which we do block mapping in
standard ->page_mkwrite callbacks. The only (big) drawback is that
i_mmap_mutex will now be held for much longer time and thus the contention
would be much higher. But hopefully once we resolve our problems with
mmap_sem and introduce mapping range lock we could scale reasonably.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
