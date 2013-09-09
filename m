Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3IIU3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:29:54 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54472 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3IIU3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:29:52 -0400
Message-ID: <522E2FBB.4070406@linaro.org>
Date: Mon, 09 Sep 2013 13:29:47 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gerlando Falauto <gerlando.falauto@keymile.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: kernel deadlock
References: <521F6D06.1040107@keymile.com> <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net> <521FDD12.7050000@linaro.org> <52212511.9050206@keymile.com> <5221264F.4070402@linaro.org> <5225F8EF.3040701@keymile.com> <52261BBB.60904@linaro.org> <5226EB35.6080604@keymile.com>
In-Reply-To: <5226EB35.6080604@keymile.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:11 AM, Gerlando Falauto wrote:
> Hi John,
>
> On 09/03/2013 07:26 PM, John Stultz wrote:
>> On 09/03/2013 07:57 AM, Gerlando Falauto wrote:
>>> Hi,
>>>
>>> I tried again from scratch, so let me recap the whole situation, so we
>>> can all view it from the same standpoint. This should make the problem
>>> easier to see and reproduce.
>>>
>>> I can confirm that running a stock 3.10 kernel with HRTICK enabled:
>> [snip]
>>> makes the following program (and the whole board, as a matter of fact)
>>> hang with no further notice:
>>>
>> [snip]
>>> If I then revert everything up to (and including) the offending commit
>>> (mind the '~'):
>>>
>>> $ git log --oneline ...06c017f~ -- kernel/time/timekeeping.c
>>> kernel/time/ntp.c | cut -f1 -d' ' | xargs git revert
>>>
>>> The problem disappears.
>>>
>>> If I then cherry-pick again the offending commit:
>>>
>>> $ git cherry-pick 06c017f; git log -1
>>>
>>> commit 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40
>>> Author: John Stultz <john.stultz@linaro.org>
>>> Date:   Fri Mar 22 11:37:28 2013 -0700
>>>
>>>       timekeeping: Hold timekeepering locks in do_adjtimex and hardpps
>>>
>> [snip]
>>> And as soon as I also cherry-pick (notice there is another commit in
>>> between, which seems not to be relevant on this matter):
>>>
>>> $ git cherry-pick a076b2146fabb0894cae5e0189a8ba3f1502d737; git show
>>>
>>> commit a076b2146fabb0894cae5e0189a8ba3f1502d737
>>> Author: John Stultz <john.stultz@linaro.org>
>>> Date:   Fri Mar 22 11:52:03 2013 -0700
>>>
>>>      ntp: Remove ntp_lock, using the timekeeping locks to protect ntp
>>> state
>>>
>> [snip]
>>>
>>> I end up in the situation where the system hangs completely and NO
>>> deadlock report whatsoever is output.
>>>
>>> So it looks like 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40 introduces
>>> the deadlock, while a076b2146fabb0894cae5e0189a8ba3f1502d737 cares to
>>> hide the report.
>>>
>>> Notice how I tested the above on an ARM board; on PowerPC I get
>>> similar results, although I am not able to see the deadlock report
>>> under any circumstances (enabling CONFIG_PROVE_LOCKING, which is the
>>> flag that triggers the deadlock report, causes the kernel to hang at
>>> startup even on a vanilla 3.10 kernel).
>>>
>>> John, could you please confirm whether you're at least able to
>>> reproduce it somehow?
>>
>> Thanks again for the detailed notes. I've so far been unable to
>> reproduce this, but I'm still looking at it.

So I think I've managed to finally reproduce this and hunt it down.

With Peter's "sched: Fix HRTICK" patch and HRTICK enabled, I found I
could trigger a hard hang at boot on my x86_64 kvm system. sysrq didn't
function, so I checked out info cpus and that pointed to both cpus being
in ktime_get() and ktime_get_update_offsets(), which suggested a
seqcount deadlock (basically calling something that reads the seqlock
while we hold the write on it).

Unfortunately the seqlock/seqcount infrastructure doesn't support
lockdep, so I added some debug code to take and release the
timekeeper_lock in every function that does a read on the timekeeper_seq.

This popped up with:
[   15.846386] ======================================================
[   15.847174] [ INFO: possible circular locking dependency detected ]
[   15.847959] 3.10.0+ #30 Not tainted
[   15.848402] -------------------------------------------------------
[   15.849182] ntpd/4062 is trying to acquire lock:
[   15.849765]  (&(&pool->lock)->rlock){..-...}, at:
[<ffffffff810aa9b5>] __queue_work+0x145/0x480
[   15.850051]
[   15.850051] but task is already holding lock:
[   15.850051]  (timekeeper_lock){-.-.-.}, at: [<ffffffff810df6df>]
do_adjtimex+0x7f/0x100
[   15.850051]
[   15.850051] which lock already depends on the new lock.
[   15.850051]
[   15.850051]
[   15.850051] the existing dependency chain (in reverse order) is:
[   15.850051]
-> #2 (timekeeper_lock){-.-.-.}:
[   15.850051]        [<ffffffff810eee7e>] lock_acquire+0x9e/0x1e0
[   15.850051]        [<ffffffff81900983>] _raw_spin_lock_irqsave+0x53/0x90
[   15.850051]        [<ffffffff810dde62>] ktime_get+0x32/0x110
[   15.850051]        [<ffffffff810c0cd0>] hrtick_start+0x20/0x90
[   15.850051]        [<ffffffff810c8fb3>] hrtick_start_fair+0x83/0xd0
[   15.850051]        [<ffffffff810c94ce>] hrtick_update+0x5e/0x60
[   15.850051]        [<ffffffff810cc5a1>] enqueue_task_fair+0x961/0xfd0
[   15.850051]        [<ffffffff810c0c11>] enqueue_task+0x61/0x70
[   15.850051]        [<ffffffff810c101e>] activate_task+0x1e/0x20
[   15.850051]        [<ffffffff818fedf9>] __schedule+0x799/0xa10
[   15.850051]        [<ffffffff818ff094>] schedule+0x24/0x70
[   15.850051]        [<ffffffff818fc84c>] schedule_timeout+0x16c/0x2c0
[   15.850051]        [<ffffffff818fe60d>] io_schedule_timeout+0x9d/0xf0
[   15.850051]        [<ffffffff818ff74f>] wait_for_completion_io+0xaf/0x120
[   15.850051]        [<ffffffff813468ec>] blk_execute_rq+0x8c/0xe0
[   15.850051]        [<ffffffff8157b23f>] scsi_execute+0xdf/0x170
[   15.850051]        [<ffffffff8157b365>] scsi_execute_req_flags+0x95/0x110
[   15.850051]        [<ffffffff8158c3b4>] sr_check_events+0xa4/0x2e0
[   15.850051]        [<ffffffff815e0393>] cdrom_check_events+0x13/0x30
[   15.850051]        [<ffffffff8158bde4>] sr_block_check_events+0x34/0x50
[   15.850051]        [<ffffffff81349dd7>] disk_check_events+0x57/0x180
[   15.850051]        [<ffffffff81349f17>] disk_events_workfn+0x17/0x20
[   15.850051]        [<ffffffff810ab777>] process_one_work+0x1e7/0x660
[   15.850051]        [<ffffffff810ac069>] worker_thread+0x119/0x370
[   15.850051]        [<ffffffff810b4376>] kthread+0xd6/0xe0
[   15.850051]        [<ffffffff81901fac>] ret_from_fork+0x7c/0xb0
[   15.850051]
-> #1 (&p->pi_lock){-.-.-.}:
[   15.850051]        [<ffffffff810eee7e>] lock_acquire+0x9e/0x1e0
[   15.850051]        [<ffffffff81900983>] _raw_spin_lock_irqsave+0x53/0x90
[   15.850051]        [<ffffffff810c436c>] try_to_wake_up+0x2c/0x300
[   15.850051]        [<ffffffff810c467e>] wake_up_process+0x1e/0x40
[   15.850051]        [<ffffffff810a89e2>] start_worker+0x22/0x30
[   15.850051]        [<ffffffff810a9d98>] create_and_start_worker+0x48/0x90
[   15.850051]        [<ffffffff820d89a8>] init_workqueues+0x1b8/0x380
[   15.850051]        [<ffffffff820c0e94>] do_one_initcall+0x7b/0x114
[   15.850051]        [<ffffffff820c0fc6>] kernel_init_freeable+0x99/0x1c3
[   15.850051]        [<ffffffff818e2b59>] kernel_init+0x9/0xf0
[   15.850051]        [<ffffffff81901fac>] ret_from_fork+0x7c/0xb0
[   15.850051]
-> #0 (&(&pool->lock)->rlock){..-...}:
[   15.850051]        [<ffffffff810ed20e>] __lock_acquire+0x1dce/0x1ee0
[   15.850051]        [<ffffffff810eee7e>] lock_acquire+0x9e/0x1e0
[   15.850051]        [<ffffffff819008f1>] _raw_spin_lock+0x41/0x80
[   15.850051]        [<ffffffff810aa9b5>] __queue_work+0x145/0x480
[   15.850051]        [<ffffffff810aadba>] __queue_delayed_work+0xaa/0x1a0
[   15.850051]        [<ffffffff810ac4de>] queue_delayed_work_on+0x8e/0xa0
[   15.850051]        [<ffffffff810dfe68>] __do_adjtimex+0x158/0x560
[   15.850051]        [<ffffffff810df703>] do_adjtimex+0xa3/0x100
[   15.850051]        [<ffffffff81090f7b>] SYSC_adjtimex+0x3b/0x80
[   15.850051]        [<ffffffff810912b9>] SyS_adjtimex+0x9/0x10
[   15.850051]        [<ffffffff81902264>] tracesys+0xdd/0xe2
[   15.850051]
[   15.850051] other info that might help us debug this:
[   15.850051]
[   15.850051] Chain exists of:
  &(&pool->lock)->rlock --> &p->pi_lock --> timekeeper_lock
[   15.850051]  Possible unsafe locking scenario:
[   15.850051]
[   15.850051]        CPU0                    CPU1
[   15.850051]        ----                    ----
[   15.850051]   lock(timekeeper_lock);
[   15.850051]                                lock(&p->pi_lock);
[   15.850051]                                lock(timekeeper_lock);
[   15.850051]   lock(&(&pool->lock)->rlock);
[   15.850051]
[   15.850051]  *** DEADLOCK ***
[   15.850051]
[   15.850051] 1 lock held by ntpd/4062:
[   15.850051]  #0:  (timekeeper_lock){-.-.-.}, at: [<ffffffff810df6df>]
do_adjtimex+0x7f/0x100
[   15.850051]
[   15.850051] stack backtrace:
[   15.850051] CPU: 0 PID: 4062 Comm: ntpd Not tainted 3.10.0+ #30
[   15.850051] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   15.850051]  ffffffff82354260 ffff880000239b78 ffffffff818f6cfe
ffff880000239bb8
[   15.850051]  ffffffff818f2f51 ffff880000239c40 ffff88000002ea78
ffff88000002ea40
[   15.850051]  ffff88000002e310 0000000000000000 0000000000000001
ffff880000239ca8
[   15.850051] Call Trace:
[   15.850051]  [<ffffffff818f6cfe>] dump_stack+0x19/0x1b
[   15.850051]  [<ffffffff818f2f51>] print_circular_bug+0x1f9/0x208
[   15.850051]  [<ffffffff810ed20e>] __lock_acquire+0x1dce/0x1ee0
[   15.850051]  [<ffffffff810e9c2d>] ? trace_hardirqs_off+0xd/0x10
[   15.850051]  [<ffffffff810c6fad>] ? sched_clock_local+0x1d/0x90
[   15.850051]  [<ffffffff810eee7e>] lock_acquire+0x9e/0x1e0
[   15.850051]  [<ffffffff810aa9b5>] ? __queue_work+0x145/0x480
[   15.850051]  [<ffffffff819008f1>] _raw_spin_lock+0x41/0x80
[   15.850051]  [<ffffffff810aa9b5>] ? __queue_work+0x145/0x480
[   15.850051]  [<ffffffff810aa9b5>] __queue_work+0x145/0x480
[   15.850051]  [<ffffffff810aadba>] __queue_delayed_work+0xaa/0x1a0
[   15.850051]  [<ffffffff810ac4de>] queue_delayed_work_on+0x8e/0xa0
[   15.850051]  [<ffffffff810dfe68>] __do_adjtimex+0x158/0x560
[   15.850051]  [<ffffffff810df703>] do_adjtimex+0xa3/0x100
[   15.850051]  [<ffffffff81090f7b>] SYSC_adjtimex+0x3b/0x80
[   15.850051]  [<ffffffff810912b9>] SyS_adjtimex+0x9/0x10
[   15.850051]  [<ffffffff81902264>] tracesys+0xdd/0xe2



So yea, thanks to the lockdep code we can see there's a three-lock deadlock.

And as you discovered, it connected to adjtimex and the timekeeping
locking changes. Specifically that we're now calling
schedule_delayed_work() under a timekeeper_seq write, and that somehow
ends up calling back to a timekeeping accessor function.

Now, I'm still in the dark as to why HRTICK exposes this, but seems like
the following patch should resolve the issue (and quiets the lockdep
warnings in my testing). Let me know how it works for you!

Ingo: This makes me think we really should have some lockdep smarts
added to seqlock/seqcount structures. Is there something already
discovered thats preventing this, or has this just not yet been tried?

thanks
-john

>From 09885df9734aa678ccb61dbef356fea4faeff16c Mon Sep 17 00:00:00 2001
From: John Stultz <john.stultz@linaro.org>
Date: Mon, 9 Sep 2013 13:07:18 -0700
Subject: [PATCH] timekeepeing: Fix HRTICK related deadlock from ntp lock
 changes

It was reported that when HRTICK is enabled, its possible to
trigger system deadlocks. These were hard to reproduce, as
HRTICK has been broken in the past, but seemed to be connected
to the timekeeping_seq lock.

Since seqlock/seqcount's aren't supported w/ lockdep, I added
some extra spinlock based locking and triggered the following
lockdep output:

[   15.849182] ntpd/4062 is trying to acquire lock:
[   15.849765]  (&(&pool->lock)->rlock){..-...}, at: [<ffffffff810aa9b5>] __queue_work+0x145/0x480
[   15.850051]
[   15.850051] but task is already holding lock:
[   15.850051]  (timekeeper_lock){-.-.-.}, at: [<ffffffff810df6df>] do_adjtimex+0x7f/0x100

<snip>

[   15.850051] Chain exists of:
  &(&pool->lock)->rlock --> &p->pi_lock --> timekeeper_lock
[   15.850051]  Possible unsafe locking scenario:
[   15.850051]
[   15.850051]        CPU0                    CPU1
[   15.850051]        ----                    ----
[   15.850051]   lock(timekeeper_lock);
[   15.850051]                                lock(&p->pi_lock);
[   15.850051]                                lock(timekeeper_lock);
[   15.850051]   lock(&(&pool->lock)->rlock);
[   15.850051]
[   15.850051]  *** DEADLOCK ***

This patch avoids this deadlock, by moving the call to
schedule_delayed_work() outside of the timekeeper lock
critical section.

Reported-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timex.h     | 1 +
 kernel/time/ntp.c         | 6 ++----
 kernel/time/timekeeping.c | 2 ++
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index b3726e6..dd3edd7 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -141,6 +141,7 @@ extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
 int read_current_timer(unsigned long *timer_val);
+void ntp_notify_cmos_timer(void);
 
 /* The clock frequency of the i8253/i8254 PIT */
 #define PIT_TICK_RATE 1193182ul
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 8f5b3b9..bb22151 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -516,13 +516,13 @@ static void sync_cmos_clock(struct work_struct *work)
 	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
 }
 
-static void notify_cmos_timer(void)
+void ntp_notify_cmos_timer(void)
 {
 	schedule_delayed_work(&sync_cmos_work, 0);
 }
 
 #else
-static inline void notify_cmos_timer(void) { }
+void ntp_notify_cmos_timer(void) { }
 #endif
 
 
@@ -687,8 +687,6 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
 
-	notify_cmos_timer();
-
 	return result;
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index baeeb5c..fcc261c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1682,6 +1682,8 @@ int do_adjtimex(struct timex *txc)
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
+	ntp_notify_cmos_timer();
+
 	return ret;
 }
 
-- 
1.8.1.2

