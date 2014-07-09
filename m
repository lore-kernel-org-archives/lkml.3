Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaGICCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:02:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:22344 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbaGICC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:02:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,630,1400050800"; 
   d="scan'208";a="570292351"
Message-ID: <53BCA278.5050205@linux.intel.com>
Date: Wed, 09 Jul 2014 10:01:28 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>,
        "xinhui.pan" <xinhuix.pan@intel.com>
CC: linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com,
        dm-devel@redhat.com, "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
 in copy_params
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/9 6:39, Mikulas Patocka wrote:

> Hi

Mikulas,

Thanks for your kind comments.

> I don't really know what is the purpose of this patch. In existing device
> mapper code, if kmalloc fails, the allocation is retried with __vmalloc.
> So there is no need to avoid kmalloc aritifically.
>
> kmalloc doesn't cause memory fragmentation. If the memory is too
> fragmented, kmalloc fails. If it isn't, it succeeds. But it doesn't cause
> memory being fragmented.

I agree with you. The patch's original description is not appropriate.
Basically, memory fragmentation is not caused by this kmalloc.

The right description is: When memory is fragmented and most memory is used up,
kmalloc a big memory might cause lots of OutOFMemory and system might kill
lots of processes. Then, system might hang.

We are enabling Android on mobiles and tablets. We hit OOM often at
Monkey and other stress testing. Sometimes, kernel prints big memory allocation
warning.

Theoretically, it's a good idea to call kmalloc firstly. If it fails, use vmalloc.
However, kernel assumes drivers do the right thing. When drivers call kmalloc to
allocate a big memory, memory management would do the best to fulfill it. When memory
is fragmented and most memory is used up, such allocation would cause big memory
recollection. Some processes might be killed. The worse scenario is after a process
is killed, it is restarted and allocates memory again. That causes system hang,
or mobile users feel a big stall. We did fix a similar issue in one of our drivers.

Usually, kernel and drivers can allocate big continuous memory at booting or
initialization stage. After that, they need allocate small order memory. The best
is to just allocate order-0 memory.


>
> If you have some other driver that fails because of large kmalloc failure,
> you should fix it to use scatter-gather DMA or (if the hardware can't do
> it) preallocate the memory when the driver is loaded.

I agree with you. Here the patch fixes the issue, where dm might allocate
big continuous memory after booting. Monkey testing triggers it by operating
menu Setting=>Security=>InstallfromSDcard.

We are catching all places in kernel where big memory allocation happens.
This patch is just to fix one case.

Thanks,
Yanmin

>
> Mikulas
>
>
>
> On Fri, 4 Jul 2014, xinhui.pan wrote:
>
>> KMALLOC_MAX_SIZE is too big, it easily cause memory fragmented and low memory when param_kernel->data_size
>> is also big. That's not nice. So use vmalloc instead of kmalloc when size is larger than (PAGE_SIZE << 2).
>> There are other drivers using kmalloc to gain a big size memory. And that cause our devices to hit hang and
>> many worse issues. We don't benefit much when using kmalloc in such scenario.
>>
>> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
>> Signed-off-by: yanmin.zhang <yanmin_zhang@linux.intel.com>
>> ---
>>   drivers/md/dm-ioctl.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
>> index 5152142..31c3af9 100644
>> --- a/drivers/md/dm-ioctl.c
>> +++ b/drivers/md/dm-ioctl.c
>> @@ -1709,7 +1709,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
>>           * Use kmalloc() rather than vmalloc() when we can.
>>           */
>>          dmi = NULL;
>> -       if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
>> +       if (param_kernel->data_size <= (PAGE_SIZE << 2)) {
>>                  dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
>>                  if (dmi)
>>                          *param_flags |= DM_PARAMS_KMALLOC;
>> -- 
>> 1.7.9.5
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>

