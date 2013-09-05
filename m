Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3IERQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:16:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab3IERQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:16:15 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: rob.gittins@linux.intel.com, linux-pmfs@lists.infradead.org,
        linux-fsdevel@veger.org, linux-kernel@vger.kernel.org
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
	<x49y57ba2ne.fsf@segfault.boston.devel.redhat.com>
	<20130905153447.GB20931@linux.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 05 Sep 2013 13:15:40 -0400
In-Reply-To: <20130905153447.GB20931@linux.intel.com> (Matthew Wilcox's
	message of "Thu, 5 Sep 2013 11:34:47 -0400")
Message-ID: <x49zjrr8a0z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <willy@linux.intel.com> writes:

> On Thu, Sep 05, 2013 at 08:12:05AM -0400, Jeff Moyer wrote:
>> If the memory is available to be mapped into the address space of the
>> kernel or a user process, then I don't see why we should have a block
>> device at all.  I think it would make more sense to have a different
>> driver class for these persistent memory devices.
>
> We already have at least two block devices in the tree that provide
> this kind of functionality (arch/powerpc/sysdev/axonram.c and
> drivers/s390/block/dcssblk.c).  Looking at how they're written, it
> seems like implementing either of them as a block device on top of a
> character device that extended their functionality in the direction we
> want would be a pretty major bloating factor for no real benefit (not
> even a particularly cleaner architecture).

Fun examples to read, thanks for the pointers.  I'll note that neither
required extensions to the block device operations.  ;-)  I do agree with
you that neither would benefit from changing.

There are a couple of things in this proposal that cause me grief,
centered around the commitpmem call:

>>    void (*commitpmem)(struct block_device *bdev, void *addr);

For block devices, when you want to flush something out, you submit a
bio with REQ_FLUSH set.  Or, you could have submitted one or more I/Os
with REQ_FUA.  Here, you want to add another method to accomplish the
same thing, but outside of the data path.  So, who would the caller of
this commitpmem function be?  Let's assume that we have a file system
layered on top of this block device.  Will the file system need to call
commitpmem in addition to sending down the appropriate flags with the
I/Os?

This brings me to the other thing.  If the caller of commitpmem is a
persistent memory-aware file system, then it seems awkward to call into
a block driver at all.  You are basically turning the block device into
a sort of hybrid thing, where you can access stuff behind it in myriad
ways.  That's the part that doesn't make sense to me.

So, that's why I suggested that maybe pmem is different from a block
device, but a block device could certainly be layered on top of it.

Hopefully that clears up my concerns with the approach.

Cheers,
Jeff
