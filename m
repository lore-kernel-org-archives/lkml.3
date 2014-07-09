Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaGIOxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:53:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaGIOxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:53:22 -0400
Date: Wed, 9 Jul 2014 10:53:17 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation in
 copy_params
In-Reply-To: <53BCA278.5050205@linux.intel.com>
Message-ID: <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com>
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jul 2014, Zhang, Yanmin wrote:

> On 2014/7/9 6:39, Mikulas Patocka wrote:
> 
> > Hi
> 
> Mikulas,
> 
> Thanks for your kind comments.
> 
> > I don't really know what is the purpose of this patch. In existing device
> > mapper code, if kmalloc fails, the allocation is retried with __vmalloc.
> > So there is no need to avoid kmalloc aritifically.
> > 
> > kmalloc doesn't cause memory fragmentation. If the memory is too
> > fragmented, kmalloc fails. If it isn't, it succeeds. But it doesn't cause
> > memory being fragmented.
> 
> I agree with you. The patch's original description is not appropriate.
> Basically, memory fragmentation is not caused by this kmalloc.
> 
> The right description is: When memory is fragmented and most memory is used
> up,
> kmalloc a big memory might cause lots of OutOFMemory and system might kill
> lots of processes. Then, system might hang.

The question is - does this particular kmalloc in device mapper cause out 
of memory or killing of other tasks? It has flags __GFP_NORETRY, 
__GFP_NOMEMALLOC, __GFP_NOWARN so it shouldn't cause any trouble. It 
should just fail silently if memory is fragmented.

Do you have some stacktrace that identifies this kmalloc as a problem?

Do this test - prepare two kernels that are identical, except that one 
kernel has that one-line change in dm-ioctl. Boot each kernel 10 times, do 
exactly the same operation after boot. Does the kernel with the patch 
always behave correctly and does the kernel without the patch always fail? 
Report the result - how many failures did you get with or without that 
one-line patch. Without such a test - I just don't believe that your patch 
makes any difference.

Another question - your patch only makes change if some device mapper 
ioctl has more than 16kB arugments. Which ioctl with more than 16kB 
arguments do you use? Do you load such a big table to device mapper? How 
often do you call that ioctl with such big arguments?

Mikulas


> We are enabling Android on mobiles and tablets. We hit OOM often at 
> Monkey and other stress testing. Sometimes, kernel prints big memory 
> allocation warning.
> 
> Theoretically, it's a good idea to call kmalloc firstly. If it fails, 
> use vmalloc. However, kernel assumes drivers do the right thing. When 
> drivers call kmalloc to allocate a big memory, memory management would 
> do the best to fulfill it. When memory is fragmented and most memory is 
> used up, such allocation would cause big memory recollection. Some 
> processes might be killed. The worse scenario is after a process is 
> killed, it is restarted and allocates memory again. That causes system 
> hang, or mobile users feel a big stall. We did fix a similar issue in 
> one of our drivers.
> 
> Usually, kernel and drivers can allocate big continuous memory at 
> booting or initialization stage. After that, they need allocate small 
> order memory. The best is to just allocate order-0 memory.
> 
> 
> > 
> > If you have some other driver that fails because of large kmalloc failure,
> > you should fix it to use scatter-gather DMA or (if the hardware can't do
> > it) preallocate the memory when the driver is loaded.
> 
> I agree with you. Here the patch fixes the issue, where dm might allocate
> big continuous memory after booting. Monkey testing triggers it by operating
> menu Setting=>Security=>InstallfromSDcard.
> 
> We are catching all places in kernel where big memory allocation happens.
> This patch is just to fix one case.
> 
> Thanks,
> Yanmin

