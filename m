Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbaBROcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:32:51 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40356 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755521AbaBROcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:32:50 -0500
Date: Tue, 18 Feb 2014 14:32:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [BUG] Circular locking dependency - DRM/CMA/MM/hotplug/...
Message-ID: <20140218143234.GC21483@n2100.arm.linux.org.uk>
References: <20140211183543.GK26684@n2100.arm.linux.org.uk> <52FB9602.1000805@samsung.com> <20140212163317.GQ26684@n2100.arm.linux.org.uk> <53036D51.2070502@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53036D51.2070502@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please learn how to trim emails down to contain only the bits relevant to
your reply, thanks.

On Tue, Feb 18, 2014 at 03:25:21PM +0100, Marek Szyprowski wrote:
> Hello,
>
> On 2014-02-12 17:33, Russell King - ARM Linux wrote:
>> So, the full locking dependency tree is this:
>>
>> CPU0		CPU1		CPU2		CPU3		CPU4
>> dev->struct_mutex (from #0)
>> 		mm->mmap_sem
>> 		dev->struct_mutex (from #5)
>> 				console_lock (from #4)
>> 				mm->mmap_sem
>> 						cpu_hotplug.lock (from #3)
>> 						console_lock
>> 								cma_mutex (from #2, but also from #1)
>> 								cpu_hotplug.lock
>> cma_mutex
>>
>> Which is pretty sick - and I don't think that blaming this solely on V4L2
>> nor DRM is particularly fair.  I believe the onus is on every author of
>> one of those locks involved in that chain needs to re-analyse whether
>> their locking is sane.
>>
>> For instance, what is cma_mutex protecting?  Is it protecting the CMA
>> bitmap?
>
> This lock is protecting CMA bitmap and also serializes all CMA allocations.
> It is required by memory management core to serialize all calls to
> alloc_contig_range() (otherwise page block's migrate types might get
> overwritten). I don't see any other obvious solution for serializing
> alloc_contig_range() calls.

That's unfortunate, because what you're effectively asking is for every
subsystem in the kernel to avoid a complex set of lock dependencies.  It
appears that two subsystems have now hit this, and I wouldn't be
surprised if they weren't the last.

> This will not work correctly if there will be 2 concurrent calls to  
> alloc_contig_range(), which will touch the same memory page blocks.

Can you see any other way to lessen the impact of cma_mutex on the
whole kernel?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
