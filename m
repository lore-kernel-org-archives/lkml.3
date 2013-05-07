Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab3EGE2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:28:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab3EGE0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:26:00 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xZPe3FF7SAEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OB5AkOFj6tkA:10 a=LpQP-O61AAAA:8 a=VwQbUJbxAAAA:8 a=Da1No7cPAAAA:8 a=S0oxW1tziPcxVXH5SaUA:9 a=6z04QOUsx9AA:10 a=YDjxKKMXsvQA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035851.111105716@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Bohan <mbohan@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [061/126] hrtimer: Dont reinitialize a cpu_base lock on CPU_UP
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0061-hrtimer-Don-t-reinitialize-a-cpu_base-lock-on-CPU_UP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michael Bohan <mbohan@codeaurora.org>

[ Upstream commit 84cc8fd2fe65866e49d70b38b3fdf7219dd92fe0 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/hrtimer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..1c5ab31 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -61,6 +61,7 @@
 DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
 
+	.lock = __RAW_SPIN_LOCK_UNLOCKED(hrtimer_bases.lock),
 	.clock_base =
 	{
 		{
@@ -1640,8 +1641,6 @@ static void __cpuinit init_hrtimers_cpu(int cpu)
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	raw_spin_lock_init(&cpu_base->lock);
-
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		cpu_base->clock_base[i].cpu_base = cpu_base;
 		timerqueue_init_head(&cpu_base->clock_base[i].active);
-- 
1.7.10.4


