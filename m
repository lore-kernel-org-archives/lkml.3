Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3IER5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:57:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:8737 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab3IER5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:57:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,848,1371106800"; 
   d="scan'208";a="374029026"
Date: Thu, 5 Sep 2013 13:57:19 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: rob.gittins@linux.intel.com, linux-pmfs@lists.infradead.org,
        linux-fsdevel@veger.org, linux-kernel@vger.kernel.org
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
Message-ID: <20130905175719.GC20931@linux.intel.com>
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
 <x49y57ba2ne.fsf@segfault.boston.devel.redhat.com>
 <20130905153447.GB20931@linux.intel.com>
 <x49zjrr8a0z.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zjrr8a0z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:15:40PM -0400, Jeff Moyer wrote:
> Matthew Wilcox <willy@linux.intel.com> writes:
> 
> > On Thu, Sep 05, 2013 at 08:12:05AM -0400, Jeff Moyer wrote:
> >> If the memory is available to be mapped into the address space of the
> >> kernel or a user process, then I don't see why we should have a block
> >> device at all.  I think it would make more sense to have a different
> >> driver class for these persistent memory devices.
> >
> > We already have at least two block devices in the tree that provide
> > this kind of functionality (arch/powerpc/sysdev/axonram.c and
> > drivers/s390/block/dcssblk.c).  Looking at how they're written, it
> > seems like implementing either of them as a block device on top of a
> > character device that extended their functionality in the direction we
> > want would be a pretty major bloating factor for no real benefit (not
> > even a particularly cleaner architecture).
> 
> Fun examples to read, thanks for the pointers.  I'll note that neither
> required extensions to the block device operations.  ;-)  I do agree with
> you that neither would benefit from changing.

Ah, but they did require extensions to the block device operations!
See commit 420edbcc09008342c7b2665453f6b370739aadb0.  The next obvious
question is, "Why isn't this API suitable for us".  And the answer is
that this API suits an existing filesystem design like ext2 (with the
xip mount option) that wants to stick very closely to the idiom of
reading one block at a time.  It's not really suited to wanting to
"read" multiple vectors at once.  Sure, we could ask for something
like preadv/pwritev in the block device operations, but we thought that
allowing the filesystem to ask for the geometry and then map the pieces
it needed itself was more elegant.

> There are a couple of things in this proposal that cause me grief,
> centered around the commitpmem call:
> 
> >>    void (*commitpmem)(struct block_device *bdev, void *addr);
> 
> For block devices, when you want to flush something out, you submit a
> bio with REQ_FLUSH set.  Or, you could have submitted one or more I/Os
> with REQ_FUA.  Here, you want to add another method to accomplish the
> same thing, but outside of the data path.  So, who would the caller of
> this commitpmem function be?  Let's assume that we have a file system
> layered on top of this block device.  Will the file system need to call
> commitpmem in addition to sending down the appropriate flags with the
> I/Os?

Existing filesystems work as-is, without using commitpmem.  commitpmem
is only for a filesystem that isn't using bios.  We could use a bio to
commit writes ... but we'd like to be able to commit writes that are
as small as a cacheline, and I don't think Linux supports block sizes
smaller than 512 bytes.

> This brings me to the other thing.  If the caller of commitpmem is a
> persistent memory-aware file system, then it seems awkward to call into
> a block driver at all.  You are basically turning the block device into
> a sort of hybrid thing, where you can access stuff behind it in myriad
> ways.  That's the part that doesn't make sense to me.

If we get the API right, the filesystem shouldn't care whether these
things are done with bios or with direct calls to the block driver.
Look at how we did sb_issue_discard().  That could be switched to a
direct call, but we choose to use bios because we want the discard bios
queued along with regular reads and writes.  

> So, that's why I suggested that maybe pmem is different from a block
> device, but a block device could certainly be layered on top of it.

Architecturally, it absolutely could be done, but I think in terms of
writing the driver it is more complex, and in terms of the filesystem,
it makes no difference (assuming we get the APIs right).  I think we
should proceed as-is, and we can look at migrating to a block-layer-free
version later, if that ever makes sense.
