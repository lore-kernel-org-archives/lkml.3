Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaDWLmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:42:11 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:57722 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaDWLmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <5355C07B.4040502@kernel.dk>
References: <53542E54.2060202@intel.com>
	<5355C07B.4040502@kernel.dk>
Date: Wed, 23 Apr 2014 19:42:08 +0800
Message-ID: <CAA7+ByVBrv-xzHxzBnPoFWhnzL3tq1t1mb0t+VSCoGh5FndsoQ@mail.gmail.com>
Subject: Re: [blk] WARNING: CPU: 0 PID: 300 at kernel/softirq.c:156 _local_bh_enable_ip()
From: Hong zhi guo <honkiko@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jet Chen <jet.chen@intel.com>, Hong Zhiguo <zhiguohong@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think one fix is to use "_local_bh_enable()" instead of "local_bh_enable()"
in u64_stats_fetch_retry_bh(). There's no enabling of irq in
_local_bh_enable().

But I wonder why we do "WARN_ON_ONCE(!irqs_disabled()
)" in
_local_bh_enable()?  What's the bad thing if someone call
_local_bh_enable() with  irqs_diabled()?

Is below change acceptable?

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 490fcbb..f446763 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -142,9 +142,11 @@ EXPORT_SYMBOL(_local_bh_enable);

 void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
 {
+       unsigned long flags;
+
        WARN_ON_ONCE(in_irq() || irqs_disabled());
 #ifdef CONFIG_TRACE_IRQFLAGS
-       local_irq_disable();
+       raw_local_irq_save(flags);
 #endif
        /*
         * Are softirqs going to be turned on now:
@@ -167,7 +169,7 @@ void __local_bh_enable_ip(unsigned long ip,
unsigned int cnt)

        preempt_count_dec();
 #ifdef CONFIG_TRACE_IRQFLAGS
-       local_irq_enable();
+       raw_local_irq_restore(flags);
 #endif
        preempt_check_resched();
 }

Zhiguo

On Tue, Apr 22, 2014 at 9:06 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-04-20 14:30, Jet Chen wrote:
>>
>> Hi Zhiguo,
>>
>> I got the below dmesg and the first bad commit is
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> commit 2c575026fae6e63771bd2a4c1d407214a8096a89
>> Author:     Hong Zhiguo <zhiguohong@tencent.com>
>> AuthorDate: Wed Nov 20 10:35:05 2013 -0700
>> Commit:     Jens Axboe <axboe@kernel.dk>
>> CommitDate: Wed Nov 20 15:33:04 2013 -0700
>>
>>      Update of blkg_stat and blkg_rwstat may happen in bh context.
>>      While u64_stats_fetch_retry is only preempt_disable on 32bit
>>      UP system. This is not enough to avoid preemption by bh and
>>      may read strange 64 bit value.
>>          Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
>>      Acked-by: Tejun Heo <tj@kernel.org>
>>      Cc: stable@kernel.org
>>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>>
>>
>>
>> +-----------------------------------------------------------+------------+------------+
>> |                                                           | 82023bb7f7 |
>> 2c575026fa |
>>
>> +-----------------------------------------------------------+------------+------------+
>> | boot_successes                                            | 47         |
>> 0          |
>> | boot_failures                                             | 13         |
>> 20         |
>> | BUG:kernel_boot_hang                                      | 13         |
>> 5          |
>> | inconsistent_IN-SOFTIRQ-W-SOFTIRQ-ON-W_usage              | 0          |
>> 15         |
>> | backtrace:smpboot_thread_fn                               | 0          |
>> 15         |
>> | backtrace:vfs_read                                        | 0          |
>> 9          |
>> | backtrace:SyS_read                                        | 0          |
>> 9          |
>> | WARNING:CPU:PID:at_kernel/softirq.c:_local_bh_enable_ip() | 0          |
>> 7          |
>> | BUG:spinlock_lockup_suspected_on_CPU                      | 0          |
>> 1          |
>> | backtrace:do_mount                                        | 0          |
>> 6          |
>> | backtrace:SyS_mount                                       | 0          |
>> 6          |
>> | backtrace:async_run_entry_fn                              | 0          |
>> 0          |
>>
>> +-----------------------------------------------------------+------------+------------+
>>
>> [   12.318816] WARNING: CPU: 0 PID: 300 at kernel/softirq.c:156
>> _local_bh_enable_ip+0x34/0x97()
>
>
> Does this still happen with 3.15-rc2?
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
best regards
Hong Zhiguo
