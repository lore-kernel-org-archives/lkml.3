Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3IETtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:49:43 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5966 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3IETtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:49:42 -0400
From: "Zuckerman, Boris" <borisz@hp.com>
To: Jeff Moyer <jmoyer@redhat.com>, Matthew Wilcox <willy@linux.intel.com>
CC: "linux-pmfs@lists.infradead.org" <linux-pmfs@lists.infradead.org>,
        "rob.gittins@linux.intel.com" <rob.gittins@linux.intel.com>,
        "linux-fsdevel@veger.org" <linux-fsdevel@veger.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: RFC Block Layer Extensions to Support NV-DIMMs
Thread-Topic: RFC Block Layer Extensions to Support NV-DIMMs
Thread-Index: AQHOqjSFLk/J+jjSpUS+tHXTE2EoJZm3Rn6AgAAcY1aAACasYA==
Date: Thu, 5 Sep 2013 19:46:20 +0000
Message-ID: <4C30833E5CDF444D84D942543DF65BDA5804A47B@G4W3303.americas.hpqcorp.net>
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
 <x49y57ba2ne.fsf@segfault.boston.devel.redhat.com>
 <20130905153447.GB20931@linux.intel.com>
 <x49zjrr8a0z.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49zjrr8a0z.fsf@segfault.boston.devel.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.28]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's a great topic! I am glad to see this conversation happening...

Let me try to open another can of worms...

Persistent memory updates are more like DB transactions and less like flushing IO ranges.

If someone offers commitpmem() functionality, someone has to assure that all updates before that call can be discarded on failure or on request. Also, the scope of updates may not be easily describable by a single range.

Forcing users to solve that (especially failure atomicity) on their own by journaling, logging or other mechanism is optimistic and that cannot be done efficiently. 

So, where should we expect to have this functionality implemented? FS drivers, block drivers, controllers?

Regards, Boris

> -----Original Message-----
> From: Linux-pmfs [mailto:linux-pmfs-bounces@lists.infradead.org] On Behalf Of Jeff
> Moyer
> Sent: Thursday, September 05, 2013 1:16 PM
> To: Matthew Wilcox
> Cc: linux-pmfs@lists.infradead.org; rob.gittins@linux.intel.com; linux-
> fsdevel@veger.org; linux-kernel@vger.kernel.org
> Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
> 
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
> Fun examples to read, thanks for the pointers.  I'll note that neither required
> extensions to the block device operations.  ;-)  I do agree with you that neither would
> benefit from changing.
> 
> There are a couple of things in this proposal that cause me grief, centered around the
> commitpmem call:
> 
> >>    void (*commitpmem)(struct block_device *bdev, void *addr);
> 
> For block devices, when you want to flush something out, you submit a bio with
> REQ_FLUSH set.  Or, you could have submitted one or more I/Os with REQ_FUA.
> Here, you want to add another method to accomplish the same thing, but outside of
> the data path.  So, who would the caller of this commitpmem function be?  Let's
> assume that we have a file system layered on top of this block device.  Will the file
> system need to call commitpmem in addition to sending down the appropriate flags
> with the I/Os?
> 
> This brings me to the other thing.  If the caller of commitpmem is a persistent
> memory-aware file system, then it seems awkward to call into a block driver at all.
> You are basically turning the block device into a sort of hybrid thing, where you can
> access stuff behind it in myriad ways.  That's the part that doesn't make sense to
> me.
> 
> So, that's why I suggested that maybe pmem is different from a block device, but a
> block device could certainly be layered on top of it.
> 
> Hopefully that clears up my concerns with the approach.
> 
> Cheers,
> Jeff
> 
> _______________________________________________
> Linux-pmfs mailing list
> Linux-pmfs@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-pmfs
