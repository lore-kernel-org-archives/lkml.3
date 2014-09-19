Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaISKqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:46:20 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61613 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbaISKqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:46:19 -0400
Date: Fri, 19 Sep 2014 12:46:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140919104613.GA11764@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 3577af70a2ce4853d58e57d832e687d739281479 perf: Fix a race condition in perf_remove_from_context()

Two kernel side fixes: a kprobes fix and a 
perf_remove_from_context() fix (which does
not yet fix the migration bug which is WIP).

 Thanks,

	Ingo

------------------>
Cong Wang (1):
      perf: Fix a race condition in perf_remove_from_context()

Wang Nan (1):
      kprobes/x86: Free 'optinsn' cache when range check fails


 arch/x86/kernel/kprobes/opt.c |  4 +++-
 kernel/events/core.c          | 10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index f304773285ae..f1314d0bcf0a 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -338,8 +338,10 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 	 * a relative jump.
 	 */
 	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
-	if (abs(rel) > 0x7fffffff)
+	if (abs(rel) > 0x7fffffff) {
+		__arch_remove_optimized_kprobe(op, 0);
 		return -ERANGE;
+	}
 
 	buf = (u8 *)op->optinsn.insn;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f9c1ed002dbc..d640a8b4dcbc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1524,6 +1524,11 @@ static void perf_remove_from_context(struct perf_event *event, bool detach_group
 	 */
 	if (ctx->is_active) {
 		raw_spin_unlock_irq(&ctx->lock);
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out().
+		 */
+		task = ctx->task;
 		goto retry;
 	}
 
@@ -1967,6 +1972,11 @@ perf_install_in_context(struct perf_event_context *ctx,
 	 */
 	if (ctx->is_active) {
 		raw_spin_unlock_irq(&ctx->lock);
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out().
+		 */
+		task = ctx->task;
 		goto retry;
 	}
 
