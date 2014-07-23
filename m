Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaGWMjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaGWMjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:39:47 -0400
Date: Wed, 23 Jul 2014 08:39:44 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation in
 copy_params
In-Reply-To: <53CDB81B.90509@linux.intel.com>
Message-ID: <alpine.LRH.2.02.1407230817080.29551@file01.intranet.prod.int.rdu2.redhat.com>
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com>
 <53CDB81B.90509@linux.intel.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Jul 2014, Zhang, Yanmin wrote:

> Sorry for replying you too late. I am very busy in some other critical issues.
> 
> > The question is - does this particular kmalloc in device mapper cause out
> > of memory or killing of other tasks? It has flags __GFP_NORETRY,
> 
> When memory is fragmented, drivers need allocate small pages instead of 
> big memory. Even with __GFP_NORETRY, driver might get a big memory by 
> luck. That means other drivers would get fewer chances to fulfill their 
> memory requests, such like allocating 2 pages for task_struct. Later on, 
> OOM might happen.

You claim that that big kmalloc causes memory fragmentation. But memory 
can get fragmented even if no big kmalloc is used. For example, this 
program will cause memory fragmentation despite the fact that it never 
does any multi-page allocation:
int main(void)
{
        int i;
        char *array[65536];
        for (i = 0; i < 65536; i++) {
                array[i] = mmap(NULL, 4096, PROT_READ | PROT_WRITE, 
MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
                if (array[i] == MAP_FAILED) perror("mmap"), exit(1);
                array[i][0] = 3;
        }
        for (i = 0; i < 65536; i += 2) {
                if (munmap(array[i], 4096)) perror("munmap"), exit(1);
        }
        pause();
        return 0;
}

If you have problems with memory fragmentation - find the piece of code 
that is failing because of fragmented memory and fix it.

To fix it:
* if it is DMA memory for device
  * use continuous memory allocator, or
  * preallocate the chunk of memory when the driver is loaded and never 
    free it
* if it is general memory allocation with kmalloc
  * change the algorithm, so that it doesn't require big allocation
  * use the same trick as device mapper - try kmalloc and if it fails, try 
    vmalloc.

> > __GFP_NOMEMALLOC, __GFP_NOWARN so it shouldn't cause any trouble. It
> > should just fail silently if memory is fragmented.
> 
> It's hard to say this call causes out of memory. There are many such places
> in kernel to allocate big continuous memory. One is in seq_read, where we
> created a patch to use vmalloc instead of kmalloc to fix it, but got far
> worse comments as it's very old code. Another is in our own gfx driver.
> We want to fix all. We can't blame the OOM to just one place.

vmalloc is much slower than kmalloc, so you can't just go over the Linux 
source and change every large kmalloc to vmalloc.

You can change seq_read to use the same trick as device mapper (use 
kmalloc and if it fails, fall back to vmalloc).

> Monkey testing is popular for Android development. We run the testing 
> frequently. It might start lots of applications. Eventually, it is a 
> comprehensive testing.

I ask again - do you have some statistically significant test results that 
show that your patch makes any difference to stability? I suppose, no...

> > Do you have some stacktrace that identifies this kmalloc as a problem?
> 
> Sometimes, when OOM happens, kernel log shows some backtrace of big 
> continuous memory allocation failure. Sometimes, when board can't 
> respond and watchdog might reset the board after saving thread callchain 
> into disk.

Find places, where the OOM happens (those, that you see on your 
stacktrace) and fix them.

> > Do this test - prepare two kernels that are identical, except that one
> > kernel has that one-line change in dm-ioctl. Boot each kernel 10 times, do
> > exactly the same operation after boot. Does the kernel with the patch
> > always behave correctly and does the kernel without the patch always fail?
> 
> No. Instead of just one, many places have impact on the OOM issue.

I repeat again - find the piece of code that is failing because of 
fragmented memory and fix it.

Device mapper isn't failing (because it falls back to vmalloc), so leave 
it alone.

> > Report the result - how many failures did you get with or without that
> > one-line patch. Without such a test - I just don't believe that your patch
> > makes any difference.
> > 
> > Another question - your patch only makes change if some device mapper
> > ioctl has more than 16kB arugments. Which ioctl with more than 16kB
> > arguments do you use? Do you load such a big table to device mapper? How
> > often do you call that ioctl with such big arguments?
> 
> Xinhui's email mentions the ioctl details. In android, there is a command
> "dumpstate", it run many other commands to collect information. In our
> scenario, it run command "vdc dump", and vdc uses socket to pass some
> parameters to "vold", then vold generates ioctl.
> 
> Thanks for your patience.

Mikulas
