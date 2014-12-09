Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbaLILCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:02:19 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33725 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbaLILCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:02:17 -0500
Date: Tue, 9 Dec 2014 12:02:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] perf fixes, leftover from the v3.18 cycle
Message-ID: <20141209110212.GA21052@gmail.com>
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

   # HEAD: 201e7deb9062bb9a8a5bc113e36457c3ff55b226 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Two perf fixes left over from the previous cycle.

 Thanks,

	Ingo

------------------>
Andy Lutomirski (1):
      x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs

Jiri Olsa (1):
      perf session: Do not fail on processing out of order event


 arch/x86/kernel/traps.c   |  5 +++--
 tools/perf/util/event.h   |  1 +
 tools/perf/util/session.c | 11 +++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index de801f22128a..07ab8e9733c5 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -387,7 +387,7 @@ NOKPROBE_SYMBOL(do_int3);
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __visible struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage __visible notrace struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
 	/* Did already sync */
@@ -413,7 +413,7 @@ struct bad_iret_stack {
 	struct pt_regs regs;
 };
 
-asmlinkage __visible
+asmlinkage __visible notrace
 struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
 {
 	/*
@@ -436,6 +436,7 @@ struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
 	BUG_ON(!user_mode_vm(&new_stack->regs));
 	return new_stack;
 }
+NOKPROBE_SYMBOL(fixup_bad_iret);
 #endif
 
 /*
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 5699e7e2a790..50a7b115698c 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -214,6 +214,7 @@ struct events_stats {
 	u32 nr_invalid_chains;
 	u32 nr_unknown_id;
 	u32 nr_unprocessable_samples;
+	u32 nr_unordered_events;
 };
 
 struct attr_event {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6702ac28754b..80dbba095f30 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -521,15 +521,11 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 		return -ETIME;
 
 	if (timestamp < oe->last_flush) {
-		WARN_ONCE(1, "Timestamp below last timeslice flush\n");
-
-		pr_oe_time(timestamp,      "out of order event");
+		pr_oe_time(timestamp,      "out of order event\n");
 		pr_oe_time(oe->last_flush, "last flush, last_flush_type %d\n",
 			   oe->last_flush_type);
 
-		/* We could get out of order messages after forced flush. */
-		if (oe->last_flush_type != OE_FLUSH__HALF)
-			return -EINVAL;
+		s->stats.nr_unordered_events++;
 	}
 
 	new = ordered_events__new(oe, timestamp, event);
@@ -1057,6 +1053,9 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 			    "Do you have a KVM guest running and not using 'perf kvm'?\n",
 			    session->stats.nr_unprocessable_samples);
 	}
+
+	if (session->stats.nr_unordered_events != 0)
+		ui__warning("%u out of order events recorded.\n", session->stats.nr_unordered_events);
 }
 
 volatile int session_done;
