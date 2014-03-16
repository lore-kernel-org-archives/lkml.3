Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaCPQeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:34:22 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60919 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbaCPQeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:34:20 -0400
Date: Sun, 16 Mar 2014 17:34:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140316163414.GA8476@gmail.com>
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

   # HEAD: b7b4839d93e50adccef29eccb694807cdcb8bee3 perf/x86: Fix leak in uncore_type_init failure paths

Misc smaller fixes.

 Thanks,

	Ingo

------------------>
Ben Hutchings (1):
      perf trace: Decode architecture-specific signal numbers

Dave Jones (1):
      perf/x86: Fix leak in uncore_type_init failure paths

Don Zickus (1):
      perf machine: Use map as success in ip__resolve_ams

Jiri Olsa (1):
      perf symbols: Fix crash in elf_section_by_name


 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  3 ++-
 tools/perf/builtin-trace.c                    | 10 +++++++++-
 tools/perf/util/machine.c                     |  2 +-
 tools/perf/util/symbol-elf.c                  |  6 +++---
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index c88f7f4..047f540 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3334,6 +3334,8 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 	if (!pmus)
 		return -ENOMEM;
 
+	type->pmus = pmus;
+
 	type->unconstrainted = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << type->num_counters) - 1,
 				0, type->num_counters, 0, 0);
@@ -3369,7 +3371,6 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 	}
 
 	type->pmu_group = &uncore_pmu_attr_group;
-	type->pmus = pmus;
 	return 0;
 fail:
 	uncore_type_exit(type);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6aa6fb6..f954c26 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -825,7 +825,6 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 	P_SIGNUM(PIPE);
 	P_SIGNUM(ALRM);
 	P_SIGNUM(TERM);
-	P_SIGNUM(STKFLT);
 	P_SIGNUM(CHLD);
 	P_SIGNUM(CONT);
 	P_SIGNUM(STOP);
@@ -841,6 +840,15 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 	P_SIGNUM(IO);
 	P_SIGNUM(PWR);
 	P_SIGNUM(SYS);
+#ifdef SIGEMT
+	P_SIGNUM(EMT);
+#endif
+#ifdef SIGSTKFLT
+	P_SIGNUM(STKFLT);
+#endif
+#ifdef SIGSWI
+	P_SIGNUM(SWI);
+#endif
 	default: break;
 	}
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c872991..620a198 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1213,7 +1213,7 @@ static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 		 */
 		thread__find_addr_location(thread, machine, m, MAP__FUNCTION,
 				ip, &al);
-		if (al.sym)
+		if (al.map)
 			goto found;
 	}
 found:
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3e9f336..516d19f 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -151,15 +151,15 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 
 		gelf_getshdr(sec, shp);
 		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
-		if (!strcmp(name, str)) {
+		if (str && !strcmp(name, str)) {
 			if (idx)
 				*idx = cnt;
-			break;
+			return sec;
 		}
 		++cnt;
 	}
 
-	return sec;
+	return NULL;
 }
 
 #define elf_section__for_each_rel(reldata, pos, pos_mem, idx, nr_entries) \
