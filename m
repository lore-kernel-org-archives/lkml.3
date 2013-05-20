Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3ETKMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:12:43 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:63188 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3ETKMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <5199F1E9.2080002@linux.vnet.ibm.com>
References: <1368780244.2813.14.camel@ThinkPad-T5421>
	<5199F1E9.2080002@linux.vnet.ibm.com>
Date: Mon, 20 May 2013 12:12:40 +0200
Message-ID: <CAFTL4hxmFQNKzzNqjiwBBcekamCYPFusdbi=ft8E4a2wrbUzZA@mail.gmail.com>
Subject: Re: [RFC PATCH nohz] return NOTIFY_BAD in cpu down call back to stop
 offlining the cpu
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/20 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
> On 05/17/2013 02:14 PM, Li Zhong wrote:
>> In tick_nohz_cpu_down_callback() if the cpu is the one handling
>> timekeeping , it seems that we should return something that could stop
>> notify CPU_DOWN_PREPARE, and then start notify CPU_DOWN_FAILED on the
>> already called notifier call backs.
>>
>> -EINVAL will be converted to 0 by notifier_to_errno(),
>
> This above line is not relevant here, because notifier_call_chain()
> doesn't use notifier_to/from_errno(). It simply uses a straight-forward
> check like this:
>
> if ((ret & NOTIFY_STOP_MASK) == NOTIFY_STOP_MASK)
>         break;
>
>> then the cpu
>> would be taken down with part of the DOWN_PREPARE notifier callbacks
>> called, and something bad could happen after that.
>>
>> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
>> ---
>
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

I applied the patch and will send to Ingo, thanks guys!

>
>>  kernel/time/tick-sched.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> index bc67d42..17b8155 100644
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -306,7 +306,7 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
>>                * we can't safely shutdown that CPU.
>>                */
>>               if (have_nohz_full_mask && tick_do_timer_cpu == cpu)
>> -                     return -EINVAL;
>> +                     return NOTIFY_BAD;
>>               break;
>>       }
>>       return NOTIFY_OK;
>>
>
> Regards,
> Srivatsa S. Bhat
>
