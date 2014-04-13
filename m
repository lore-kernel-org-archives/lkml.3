Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaDMSDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 14:03:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:14809 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbaDMSDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,852,1389772800"; 
   d="scan'208";a="519803881"
Date: Sun, 13 Apr 2014 14:03:29 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140413180329.GR5727@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409102758.GM32103@quack.suse.cz>
 <20140409205111.GG5727@linux.intel.com>
 <20140409214331.GQ32103@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409214331.GQ32103@quack.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:43:31PM +0200, Jan Kara wrote:
> On Wed 09-04-14 16:51:11, Matthew Wilcox wrote:
> > On Wed, Apr 09, 2014 at 12:27:58PM +0200, Jan Kara wrote:
> > > > +	if (unlikely(vmf->pgoff >= size)) {
> > > > +		mutex_unlock(&mapping->i_mmap_mutex);
> > > > +		goto sigbus;
> > >   You need to release the block you've got from the filesystem in case of
> > > error here an below.
> > 
> > What's the API to do that?  Call inode->i_op->setattr()?
>   That's a great question. Yes, ->setattr() is the only API you have for
> that but you cannot use that because of locking constraints (it needs
> i_mutex and that's not possible to get in the fault path). Let me read
> again what the handler does...
> 
> So there are three places that can fail after we allocate the block:
> 1) We race with truncate reducing i_size
> 2) dax_get_pfn() fails
> 3) vm_insert_mixed() fails
> 
> I would guess that 2) can fail only if the HW has problems and leaking
> block in that case could be acceptable (please correct me if I'm wrong).
> 3) shouldn't fail because of ENOMEM because fault has already allocated all
> the page tables and EBUSY should be handled as well. So the only failure we
> have to care about is 1). And we could move ->get_block() call under
> i_mmap_mutex after the i_size check.  Lock ordering should be fine because
> i_mmap_mutex ranks above page lock under which we do block mapping in
> standard ->page_mkwrite callbacks. The only (big) drawback is that
> i_mmap_mutex will now be held for much longer time and thus the contention
> would be much higher. But hopefully once we resolve our problems with
> mmap_sem and introduce mapping range lock we could scale reasonably.

I think you're right about the only failure case to worry about being
(1).  For 2 or 3, we haven't *leaked* the block, we've merely allocated
it, found out we couldn't use it, and then not freed it.  It'll be freed
when the file is deleted or truncated.

Taking the i_mmap_mutex earlier looks reasonable.  I'll do that.  As far
as reducing contention on i_mmap_mutex goes, I'm currently planning on
using an exceptional entry in the radix tree, designating one bit of that
as the lock bit and using the remaining 29 / 61 bits to cache the PFN.
That lock would then have the same rank as the page lock.

It might be interesting to build that kind of 'locking' into the radix
tree ... I'm half-thinking about taking a lock higher in the radix tree
to cover large pages.  I'll probably just use the lock bit in the entry
that would cover the head page, though.
