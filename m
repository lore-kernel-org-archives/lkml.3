Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3LQT0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:26:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:40272 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3LQT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:26:48 -0500
Date: Tue, 17 Dec 2013 20:26:46 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.5-rt7
Message-ID: <20131217192646.GA1710@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.5-rt7 patch set.

Changes since v3.12.5-rt6
- the ptrace fix got a little wrong in check_task_state() and we had two
  return 0 which ensured that ptrace did not work. Noticed by Mike
  Galbraith.

Known issues:

      - bcache is disabled.

      - Brian Silverman reported a BUG (via Debian BTS) where gdb's
        record command does something nasty and causes a double fault on
        x86-64 kernel with 32bit userland (the debugged application).
        32bit and 64bit setup are not kernels are not affected. As far
        as I understand the problem so far, it is limited to x86.

The delta patch against v3.12.5-rt6 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.5-rt6-rt7.patch.xz

The RT patch against 3.12.5 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.5-rt7.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.5-rt7.tar.xz

Sebastian

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9c87a17..b69f280 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1076,9 +1076,7 @@ static bool check_task_state(struct task_struct *p, long match_state)
 	bool match = false;
 
 	raw_spin_lock_irq(&p->pi_lock);
-	if (p->state == match_state)
-		match = true;
-	else if (p->saved_state == match_state)
+	if (p->state == match_state || p->saved_state == match_state)
 		match = true;
 	raw_spin_unlock_irq(&p->pi_lock);
 
@@ -1129,11 +1127,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * is actually now running somewhere else!
 		 */
 		while (task_running(rq, p)) {
-			if (match_state) {
-				if (!unlikely(check_task_state(p, match_state)))
-					return 0;
+			if (match_state && !check_task_state(p, match_state))
 				return 0;
-			}
 			cpu_relax();
 		}
 
diff --git a/localversion-rt b/localversion-rt
index 8fc605d..0454789 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt6
+-rt7
