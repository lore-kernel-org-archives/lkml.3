Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3BDSVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:21:04 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:54827 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3BDSVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:21:01 -0500
Date: Mon, 4 Feb 2013 19:20:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130204182053.GA12752@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 0231bb5336758426b44ccd798ccd3c5419c95d58 perf: Fix event group context move

Three fixlets and two small (and low risk) hw-enablement 
changes.

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      arch/x86/tools/insn_sanity.c: Identify source of messages

Jiri Olsa (1):
      perf: Fix event group context move

ShuoX Liu (1):
      perf/x86: Enable Intel Lincroft/Penwell/Cloverview Atom support

Youquan Song (1):
      x86/perf: Add IvyBridge EP support

yangyongqiang (1):
      perf/x86: Fix P6 driver section warning


 arch/x86/kernel/cpu/perf_event_intel.c |  6 +++++-
 arch/x86/kernel/cpu/perf_event_p6.c    |  2 +-
 arch/x86/tools/insn_sanity.c           | 10 ++++++++--
 kernel/events/core.c                   | 20 ++++++++++++++++++--
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 93b9e11..4914e94 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2019,7 +2019,10 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 28: /* Atom */
-	case 54: /* Cedariew */
+	case 38: /* Lincroft */
+	case 39: /* Penwell */
+	case 53: /* Cloverview */
+	case 54: /* Cedarview */
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -2084,6 +2087,7 @@ __init int intel_pmu_init(void)
 		pr_cont("SandyBridge events, ");
 		break;
 	case 58: /* IvyBridge */
+	case 62: /* IvyBridge EP */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index f2af39f..4820c23 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[] =
 
 };
 
-static __initconst u64 p6_hw_cache_event_ids
+static u64 p6_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
diff --git a/arch/x86/tools/insn_sanity.c b/arch/x86/tools/insn_sanity.c
index cc2f8c1..872eb60 100644
--- a/arch/x86/tools/insn_sanity.c
+++ b/arch/x86/tools/insn_sanity.c
@@ -55,7 +55,7 @@ static FILE		*input_file;	/* Input file name */
 static void usage(const char *err)
 {
 	if (err)
-		fprintf(stderr, "Error: %s\n\n", err);
+		fprintf(stderr, "%s: Error: %s\n\n", prog, err);
 	fprintf(stderr, "Usage: %s [-y|-n|-v] [-s seed[,no]] [-m max] [-i input]\n", prog);
 	fprintf(stderr, "\t-y	64bit mode\n");
 	fprintf(stderr, "\t-n	32bit mode\n");
@@ -269,7 +269,13 @@ int main(int argc, char **argv)
 		insns++;
 	}
 
-	fprintf(stdout, "%s: decoded and checked %d %s instructions with %d errors (seed:0x%x)\n", (errors) ? "Failure" : "Success", insns, (input_file) ? "given" : "random", errors, seed);
+	fprintf(stdout, "%s: %s: decoded and checked %d %s instructions with %d errors (seed:0x%x)\n",
+		prog,
+		(errors) ? "Failure" : "Success",
+		insns,
+		(input_file) ? "given" : "random",
+		errors,
+		seed);
 
 	return errors ? 1 : 0;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 301079d..7b6646a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -908,6 +908,15 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 }
 
 /*
+ * Initialize event state based on the perf_event_attr::disabled.
+ */
+static inline void perf_event__state_init(struct perf_event *event)
+{
+	event->state = event->attr.disabled ? PERF_EVENT_STATE_OFF :
+					      PERF_EVENT_STATE_INACTIVE;
+}
+
+/*
  * Called at perf_event creation and when events are attached/detached from a
  * group.
  */
@@ -6179,8 +6188,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	event->overflow_handler	= overflow_handler;
 	event->overflow_handler_context = context;
 
-	if (attr->disabled)
-		event->state = PERF_EVENT_STATE_OFF;
+	perf_event__state_init(event);
 
 	pmu = NULL;
 
@@ -6609,9 +6617,17 @@ SYSCALL_DEFINE5(perf_event_open,
 
 		mutex_lock(&gctx->mutex);
 		perf_remove_from_context(group_leader);
+
+		/*
+		 * Removing from the context ends up with disabled
+		 * event. What we want here is event in the initial
+		 * startup state, ready to be add into new context.
+		 */
+		perf_event__state_init(group_leader);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
 			perf_remove_from_context(sibling);
+			perf_event__state_init(sibling);
 			put_ctx(gctx);
 		}
 		mutex_unlock(&gctx->mutex);
