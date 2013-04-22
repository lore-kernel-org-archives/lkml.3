Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3DVOu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:50:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51406 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812Ab3DVO33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:29 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael Bohan" <mbohan@codeaurora.org>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.162571769@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [17/75] hrtimer: Don't reinitialize a cpu_base lock on CPU_UP
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bohan <mbohan@codeaurora.org>

commit 84cc8fd2fe65866e49d70b38b3fdf7219dd92fe0 upstream.

The current code makes the assumption that a cpu_base lock won't be
held if the CPU corresponding to that cpu_base is offline, which isn't
always true.

If a hrtimer is not queued, then it will not be migrated by
migrate_hrtimers() when a CPU is offlined. Therefore, the hrtimer's
cpu_base may still point to a CPU which has subsequently gone offline
if the timer wasn't enqueued at the time the CPU went down.

Normally this wouldn't be a problem, but a cpu_base's lock is blindly
reinitialized each time a CPU is brought up. If a CPU is brought
online during the period that another thread is performing a hrtimer
operation on a stale hrtimer, then the lock will be reinitialized
under its feet, and a SPIN_BUG() like the following will be observed:

<0>[   28.082085] BUG: spinlock already unlocked on CPU#0, swapper/0/0
<0>[   28.087078]  lock: 0xc4780b40, value 0x0 .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
<4>[   42.451150] [<c0014398>] (unwind_backtrace+0x0/0x120) from [<c0269220>] (do_raw_spin_unlock+0x44/0xdc)
<4>[   42.460430] [<c0269220>] (do_raw_spin_unlock+0x44/0xdc) from [<c071b5bc>] (_raw_spin_unlock+0x8/0x30)
<4>[   42.469632] [<c071b5bc>] (_raw_spin_unlock+0x8/0x30) from [<c00a9ce0>] (__hrtimer_start_range_ns+0x1e4/0x4f8)
<4>[   42.479521] [<c00a9ce0>] (__hrtimer_start_range_ns+0x1e4/0x4f8) from [<c00aa014>] (hrtimer_start+0x20/0x28)
<4>[   42.489247] [<c00aa014>] (hrtimer_start+0x20/0x28) from [<c00e6190>] (rcu_idle_enter_common+0x1ac/0x320)
<4>[   42.498709] [<c00e6190>] (rcu_idle_enter_common+0x1ac/0x320) from [<c00e6440>] (rcu_idle_enter+0xa0/0xb8)
<4>[   42.508259] [<c00e6440>] (rcu_idle_enter+0xa0/0xb8) from [<c000f268>] (cpu_idle+0x24/0xf0)
<4>[   42.516503] [<c000f268>] (cpu_idle+0x24/0xf0) from [<c06ed3c0>] (rest_init+0x88/0xa0)
<4>[   42.524319] [<c06ed3c0>] (rest_init+0x88/0xa0) from [<c0c00978>] (start_kernel+0x3d0/0x434)

As an example, this particular crash occurred when hrtimer_start() was
executed on CPU #0. The code locked the hrtimer's current cpu_base
corresponding to CPU #1. CPU #0 then tried to switch the hrtimer's
cpu_base to an optimal CPU which was online. In this case, it selected
the cpu_base corresponding to CPU #3.

Before it could proceed, CPU #1 came online and reinitialized the
spinlock corresponding to its cpu_base. Thus now CPU #0 held a lock
which was reinitialized. When CPU #0 finally ended up unlocking the
old cpu_base corresponding to CPU #1 so that it could switch to CPU
#3, we hit this SPIN_BUG() above while in switch_hrtimer_base().

CPU #0                            CPU #1
----                              ----
...                               <offline>
hrtimer_start()
lock_hrtimer_base(base #1)
...                               init_hrtimers_cpu()
switch_hrtimer_base()             ...
...                               raw_spin_lock_init(&cpu_base->lock)
raw_spin_unlock(&cpu_base->lock)  ...
<spin_bug>

Solve this by statically initializing the lock.

Signed-off-by: Michael Bohan <mbohan@codeaurora.org>
Link: http://lkml.kernel.org/r/1363745965-23475-1-git-send-email-mbohan@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/hrtimer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -61,6 +61,7 @@
 DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
 
+	.lock = __RAW_SPIN_LOCK_UNLOCKED(hrtimer_bases.lock),
 	.clock_base =
 	{
 		{
@@ -1640,8 +1641,6 @@ static void __cpuinit init_hrtimers_cpu(
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	raw_spin_lock_init(&cpu_base->lock);
-
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		cpu_base->clock_base[i].cpu_base = cpu_base;
 		timerqueue_init_head(&cpu_base->clock_base[i].active);

