Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3CNWVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:21:42 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43331 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab3CNWVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:21:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130314133931.3609b75deff58a2df02ca96b@linux-foundation.org>
References: <1363271189-6631-1-git-send-email-fweisbec@gmail.com>
	<1363271189-6631-3-git-send-email-fweisbec@gmail.com>
	<20130314133931.3609b75deff58a2df02ca96b@linux-foundation.org>
Date: Thu, 14 Mar 2013 23:21:39 +0100
Message-ID: <CAFTL4hya7CdLMDRfASBycsB6w92AaffePK5xewi6P=0dm3wiSA@mail.gmail.com>
Subject: Re: [PATCH 2/2] printk: Provide a wake_up_klogd() off-case
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/14 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 14 Mar 2013 15:26:29 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> wake_up_klogd() is useless when CONFIG_PRINTK=n because
>> neither printk() nor printk_sched() are in use and there
>> are actually no waiter on log_wait waitqueue. It should
>> be a stub in this case for users like bust_spinlocks().
>>
>> Otherwise this results in this warning when CONFIG_PRINTK=n
>> and CONFIG_IRQ_WORK=n:
>>
>>       kernel/built-in.o In function `wake_up_klogd':
>>       (.text.wake_up_klogd+0xb4): undefined reference to `irq_work_queue'
>>
>> To fix this, provide an off-case for wake_up_klogd() when
>> CONFIG_PRINTK=n.
>>
>> There is much more from console_unlock() and other console
>> related code in printk.c that should be moved under
>> CONFIG_PRINTK. But for now, focus on a minimal fix as we passed
>> the merged window already.
>>
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -390,7 +390,6 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
>>  unsigned long int_sqrt(unsigned long);
>>
>>  extern void bust_spinlocks(int yes);
>> -extern void wake_up_klogd(void);
>>  extern int oops_in_progress;         /* If set, an oops, panic(), BUG() or die() is in progress */
>>  extern int panic_timeout;
>>  extern int panic_on_oops;
>> diff --git a/include/linux/printk.h b/include/linux/printk.h
>> index 1249a54..822171f 100644
>> --- a/include/linux/printk.h
>> +++ b/include/linux/printk.h
>> @@ -134,6 +134,8 @@ extern int printk_delay_msec;
>>  extern int dmesg_restrict;
>>  extern int kptr_restrict;
>>
>> +extern void wake_up_klogd(void);
>> +
>
> Given this, it would be prudent to include printk.h in
> bust_spinlocks.c.  printk.h currently gets included by kernel.h, but
> that doesn't actually seem necessary - nothing in kernel.h calls
> printk().
>
> (I pity anyone who tries to remove that include from kernel.h ;))

Right, I doubt this will ever happen ;-)

Still, thanks for the fix!
