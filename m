Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbbAIMe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:34:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755AbbAIMez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:34:55 -0500
Date: Fri, 9 Jan 2015 04:34:19 -0800
From: tip-bot for Tetsuo Handa <tipbot@zytor.com>
Message-ID: <tip-7f1a169b88f513e32a432ca0f85bfd282d117bd6@git.kernel.org>
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, peterz@infradead.org,
        hpa@zytor.com, penguin-kernel@I-love.SAKURA.ne.jp,
        linux-kernel@vger.kernel.org, mingo@kernel.org, bsegall@google.com,
        pjt@google.com
Reply-To: hpa@zytor.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, pjt@google.com, bsegall@google.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <201412252210.GCC30204.SOMVFFOtQJFLOH@I-love.SAKURA.ne.jp>
References: <201412252210.GCC30204.SOMVFFOtQJFLOH@I-love.SAKURA.ne.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/fair:
  Fix RCU stall upon -ENOMEM in sched_create_group()
Git-Commit-ID: 7f1a169b88f513e32a432ca0f85bfd282d117bd6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f1a169b88f513e32a432ca0f85bfd282d117bd6
Gitweb:     http://git.kernel.org/tip/7f1a169b88f513e32a432ca0f85bfd282d117bd6
Author:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
AuthorDate: Thu, 25 Dec 2014 15:51:21 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 9 Jan 2015 11:19:00 +0100

sched/fair: Fix RCU stall upon -ENOMEM in sched_create_group()

When alloc_fair_sched_group() in sched_create_group() fails,
free_sched_group() is called, and free_fair_sched_group() is called by
free_sched_group(). Since destroy_cfs_bandwidth() is called by
free_fair_sched_group() without calling init_cfs_bandwidth(),
RCU stall occurs at hrtimer_cancel():

  INFO: rcu_sched self-detected stall on CPU { 1}  (t=60000 jiffies g=13074 c=13073 q=0)
  Task dump for CPU 1:
  (fprintd)       R  running task        0  6249      1 0x00000088
  ...
  Call Trace:
   <IRQ>  [<ffffffff81094988>] sched_show_task+0xa8/0x110
   [<ffffffff81097acd>] dump_cpu_task+0x3d/0x50
   [<ffffffff810c3a80>] rcu_dump_cpu_stacks+0x90/0xd0
   [<ffffffff810c7751>] rcu_check_callbacks+0x491/0x700
   [<ffffffff810cbf2b>] update_process_times+0x4b/0x80
   [<ffffffff810db046>] tick_sched_handle.isra.20+0x36/0x50
   [<ffffffff810db0a2>] tick_sched_timer+0x42/0x70
   [<ffffffff810ccb19>] __run_hrtimer+0x69/0x1a0
   [<ffffffff810db060>] ? tick_sched_handle.isra.20+0x50/0x50
   [<ffffffff810ccedf>] hrtimer_interrupt+0xef/0x230
   [<ffffffff810452cb>] local_apic_timer_interrupt+0x3b/0x70
   [<ffffffff8164a465>] smp_apic_timer_interrupt+0x45/0x60
   [<ffffffff816485bd>] apic_timer_interrupt+0x6d/0x80
   <EOI>  [<ffffffff810cc588>] ? lock_hrtimer_base.isra.23+0x18/0x50
   [<ffffffff81193cf1>] ? __kmalloc+0x211/0x230
   [<ffffffff810cc9d2>] hrtimer_try_to_cancel+0x22/0xd0
   [<ffffffff81193cf1>] ? __kmalloc+0x211/0x230
   [<ffffffff810ccaa2>] hrtimer_cancel+0x22/0x30
   [<ffffffff810a3cb5>] free_fair_sched_group+0x25/0xd0
   [<ffffffff8108df46>] free_sched_group+0x16/0x40
   [<ffffffff810971bb>] sched_create_group+0x4b/0x80
   [<ffffffff810aa383>] sched_autogroup_create_attach+0x43/0x1c0
   [<ffffffff8107dc9c>] sys_setsid+0x7c/0x110
   [<ffffffff81647729>] system_call_fastpath+0x12/0x17

Check whether init_cfs_bandwidth() was called before calling
destroy_cfs_bandwidth().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
[ Move the check into destroy_cfs_bandwidth() to aid compilability. ]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/201412252210.GCC30204.SOMVFFOtQJFLOH@I-love.SAKURA.ne.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b99659..40667cb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4005,6 +4005,10 @@ void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b, bool force)
 
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
+	/* init_cfs_bandwidth() was not called */
+	if (!cfs_b->throttled_cfs_rq.next)
+		return;
+
 	hrtimer_cancel(&cfs_b->period_timer);
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
