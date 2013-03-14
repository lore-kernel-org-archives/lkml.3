Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3CNWq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:46:28 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59540 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3CNWq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:46:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAFTL4hwp0E8v9_rP-qkU30njW8nGPc0dRSFxFuzE0YnnNnn4DA@mail.gmail.com>
References: <1363271189-6631-1-git-send-email-fweisbec@gmail.com>
 <1363271189-6631-3-git-send-email-fweisbec@gmail.com> <20130314133931.3609b75deff58a2df02ca96b@linux-foundation.org>
 <CAP=VYLqJuQqFpTkb0BvbNfwyzLLaX9_AfOioP_jOBp0Tvu15HA@mail.gmail.com> <CAFTL4hwp0E8v9_rP-qkU30njW8nGPc0dRSFxFuzE0YnnNnn4DA@mail.gmail.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 14 Mar 2013 18:45:56 -0400
X-Google-Sender-Auth: qoZW2po1ijt9BAfVix7UT5Vfzpk
Message-ID: <CAP=VYLow+mvw7Q0buFo7UAsrFUsPgUu7L6Gv-EO7hchuWg+whg@mail.gmail.com>
Subject: Re: [PATCH 2/2] printk: Provide a wake_up_klogd() off-case
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 6:34 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/3/14 Paul Gortmaker <paul.gortmaker@windriver.com>:
>> On Thu, Mar 14, 2013 at 4:39 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>> On Thu, 14 Mar 2013 15:26:29 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>
>>>> wake_up_klogd() is useless when CONFIG_PRINTK=n because
>>>> neither printk() nor printk_sched() are in use and there
>>>> are actually no waiter on log_wait waitqueue. It should
>>>> be a stub in this case for users like bust_spinlocks().
>>>>
>>>> Otherwise this results in this warning when CONFIG_PRINTK=n
>>>> and CONFIG_IRQ_WORK=n:
>>>>
>>>>       kernel/built-in.o In function `wake_up_klogd':
>>>>       (.text.wake_up_klogd+0xb4): undefined reference to `irq_work_queue'
>>>>
>>>> To fix this, provide an off-case for wake_up_klogd() when
>>>> CONFIG_PRINTK=n.
>>>>
>>>> There is much more from console_unlock() and other console
>>>> related code in printk.c that should be moved under
>>>> CONFIG_PRINTK. But for now, focus on a minimal fix as we passed
>>>> the merged window already.
>>>>
>>>> --- a/include/linux/kernel.h
>>>> +++ b/include/linux/kernel.h
>>>> @@ -390,7 +390,6 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
>>>>  unsigned long int_sqrt(unsigned long);
>>>>
>>>>  extern void bust_spinlocks(int yes);
>>>> -extern void wake_up_klogd(void);
>>>>  extern int oops_in_progress;         /* If set, an oops, panic(), BUG() or die() is in progress */
>>>>  extern int panic_timeout;
>>>>  extern int panic_on_oops;
>>>> diff --git a/include/linux/printk.h b/include/linux/printk.h
>>>> index 1249a54..822171f 100644
>>>> --- a/include/linux/printk.h
>>>> +++ b/include/linux/printk.h
>>>> @@ -134,6 +134,8 @@ extern int printk_delay_msec;
>>>>  extern int dmesg_restrict;
>>>>  extern int kptr_restrict;
>>>>
>>>> +extern void wake_up_klogd(void);
>>>> +
>>>
>>> Given this, it would be prudent to include printk.h in
>>> bust_spinlocks.c.  printk.h currently gets included by kernel.h, but
>>> that doesn't actually seem necessary - nothing in kernel.h calls
>>> printk().
>>>
>>> (I pity anyone who tries to remove that include from kernel.h ;))
>>
>> Why did you have to say that?  Now I'm inclined to poke at it and
>> just see how bad it really is when I pull on that loose thread...
>
> $ git grep "#include <linux/printk.h>" | cut -d: -f1 | uniq | wc -l
> 29
>
> $ git grep printk | cut -d: -f1 | uniq | wc -l
> 6689
>
> There is roughly 6689 - 29 = 6660 files to modify :)

That is the worst case scenario.  If we start by fixing existing headers
that actually reference printk (like linux/fs.h) first, then we shouldn't have
to mine down into all those stand-alone C files.   At least I think that
may possibly be the case....    ;)   Remains to be seen at this point.

Paul.
--

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
