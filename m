Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaJPTkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:40:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:44468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaJPTkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:40:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="401436380"
Date: Thu, 16 Oct 2014 15:39:21 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 02/21] block: Change direct_access calling convention
Message-ID: <20141016193921.GC11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-3-git-send-email-matthew.r.wilcox@intel.com>
 <20141016084550.GA19075@thinkos.etherlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016084550.GA19075@thinkos.etherlink>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:45:50AM +0200, Mathieu Desnoyers wrote:
> > -static int
> > +static long
> >  axon_ram_direct_access(struct block_device *device, sector_t sector,
> > -		       void **kaddr, unsigned long *pfn)
> > +		       void **kaddr, unsigned long *pfn, long size)
> 
> Why "long" as type for size ? What is the intent to have it signed, and
> why using a 32-bit type on 32-bit architectures rather than 64-bit ?
> Can we run into issues if we try to map a >2GB file on 32-bit
> architectures ?

The interface requires that the entirety of the pmem be mapped at
all times (see the void **kaddr).  So the total amount of pmem in the
system can't be larger than 4GB on a 32-bit system.  On x86-32, that's
actually limited to 1GB (because we give userspace 3GB), so the problem
doesn't come up.  Maybe this would be more of a potetial problem on
other architectures.

As noted elsewhere in the thread, it would be possible, and maybe
desirable, to remove the need to have all of pmem mapped into the kernel
address space at all times, but I'm not looking to solve that problem
with this patch-set.

The intent of having it signed is that users pass in the size they want
to have and are returned the size they actually got.  Since the function
must be able to return an error, keeping size signed is natural.

> > +long bdev_direct_access(struct block_device *bdev, sector_t sector,
> > +			void **addr, unsigned long *pfn, long size)
> > +{
> > +	long avail;
> > +	const struct block_device_operations *ops = bdev->bd_disk->fops;
> > +
> > +	if (size < 0)
> > +		return size;
> 
> I'm wondering how we should handle size == 0 here. Should it be accepted
> or refused ?

It is a bit of a bizarre case.  I'm inclined to the current behaviour
of saying "this is the address where you can access zero bytes" :-)

But maybe it indicates a bug in the caller, and being noisy about it
would result in the caller getting fixed.
