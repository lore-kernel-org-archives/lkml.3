Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaGVBC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:02:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:28205 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaGVBC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:02:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,706,1400050800"; 
   d="scan'208";a="565206432"
Message-ID: <53CDB81B.90509@linux.intel.com>
Date: Tue, 22 Jul 2014 09:02:19 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
 in copy_params
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/9 22:53, Mikulas Patocka wrote:
>
> On Wed, 9 Jul 2014, Zhang, Yanmin wrote:
>
>> On 2014/7/9 6:39, Mikulas Patocka wrote:
>>
>>> Hi
>> Mikulas,
>>
>> Thanks for your kind comments.
>>
>>> I don't really know what is the purpose of this patch. In existing device
>>> mapper code, if kmalloc fails, the allocation is retried with __vmalloc.
>>> So there is no need to avoid kmalloc aritifically.
>>>
>>> kmalloc doesn't cause memory fragmentation. If the memory is too
>>> fragmented, kmalloc fails. If it isn't, it succeeds. But it doesn't cause
>>> memory being fragmented.
>> I agree with you. The patch's original description is not appropriate.
>> Basically, memory fragmentation is not caused by this kmalloc.
>>
>> The right description is: When memory is fragmented and most memory is used
>> up,
>> kmalloc a big memory might cause lots of OutOFMemory and system might kill
>> lots of processes. Then, system might hang.

Sorry for replying you too late. I am very busy in some other critical issues.

> The question is - does this particular kmalloc in device mapper cause out
> of memory or killing of other tasks? It has flags __GFP_NORETRY,

When memory is fragmented, drivers need allocate small pages instead of big
memory. Even with __GFP_NORETRY, driver might get a big memory by luck. That means
other drivers would get fewer chances to fulfill their memory requests, such like
allocating 2 pages for task_struct. Later on, OOM might happen.

> __GFP_NOMEMALLOC, __GFP_NOWARN so it shouldn't cause any trouble. It
> should just fail silently if memory is fragmented.

It's hard to say this call causes out of memory. There are many such places
in kernel to allocate big continuous memory. One is in seq_read, where we
created a patch to use vmalloc instead of kmalloc to fix it, but got far
worse comments as it's very old code. Another is in our own gfx driver.
We want to fix all. We can't blame the OOM to just one place.

Monkey testing is popular for Android development. We run the testing frequently.
It might start lots of applications. Eventually, it is a comprehensive testing.

>
> Do you have some stacktrace that identifies this kmalloc as a problem?

Sometimes, when OOM happens, kernel log shows some backtrace of big continuous
memory allocation failure. Sometimes, when board can't respond and watchdog might
reset the board after saving thread callchain into disk.

>
> Do this test - prepare two kernels that are identical, except that one
> kernel has that one-line change in dm-ioctl. Boot each kernel 10 times, do
> exactly the same operation after boot. Does the kernel with the patch
> always behave correctly and does the kernel without the patch always fail?

No. Instead of just one, many places have impact on the OOM issue.

> Report the result - how many failures did you get with or without that
> one-line patch. Without such a test - I just don't believe that your patch
> makes any difference.
>
> Another question - your patch only makes change if some device mapper
> ioctl has more than 16kB arugments. Which ioctl with more than 16kB
> arguments do you use? Do you load such a big table to device mapper? How
> often do you call that ioctl with such big arguments?

Xinhui's email mentions the ioctl details. In android, there is a command
"dumpstate", it run many other commands to collect information. In our
scenario, it run command "vdc dump", and vdc uses socket to pass some
parameters to "vold", then vold generates ioctl.

Thanks for your patience.

