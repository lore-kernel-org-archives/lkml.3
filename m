Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaLOOvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:51:22 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35446 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaLOOvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:51:17 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [PATCHv2 7/8] perf probe powerpc: Use DWARF info only if necessary
Date: Mon, 15 Dec 2014 20:20:37 +0530
Message-Id: <b80e76e221b925eb6206eb50e386370201087776.1418654436.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121514-0029-0000-0000-000000D1CF5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use symbol table lookups by default if DWARF is not necessary, since
powerpc ABIv2 encodes local entry points in the symbol table and the
function entry address in DWARF may not be appropriate for kprobes, as
described here:
https://sourceware.org/bugzilla/show_bug.cgi?id=17638

"The DWARF address ranges deliberately include the *whole* function,
both global and local entry points."
...
"If you want to set probes on a local entry point, you should look up
the symbol in the main symbol table (not DWARF), and check the st_other
bits; they will indicate whether the function has a local entry point,
and what its offset from the global entry point is.  Note that GDB does
the same when setting a breakpoint on a function entry."

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
Changes from previous patchset:
Generalize and introduce helper to prefer symbol table over DWARF.

 tools/perf/arch/powerpc/util/sym-handling.c | 9 +++++++++
 tools/perf/config/Makefile                  | 1 +
 tools/perf/util/probe-event.c               | 6 ++++++
 tools/perf/util/probe-event.h               | 6 ++++++
 4 files changed, 22 insertions(+)

diff --git a/tools/perf/arch/powerpc/util/sym-handling.c b/tools/perf/arch/powerpc/util/sym-handling.c
index a27bfaf..22fc2e6 100644
--- a/tools/perf/arch/powerpc/util/sym-handling.c
+++ b/tools/perf/arch/powerpc/util/sym-handling.c
@@ -36,3 +36,12 @@ inline void arch_elf_sym_decode(GElf_Sym *sym __maybe_unused)
 		sym->st_value += PPC64_LOCAL_ENTRY_OFFSET(sym->st_other);
 #endif
 }
+
+inline bool prefer_symtab(void)
+{
+#if defined(_CALL_ELF) && _CALL_ELF == 2
+	return true;
+#else
+	return false;
+#endif
+}
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 35cf934..849f686 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -384,6 +384,7 @@ ifeq ($(ARCH),powerpc)
     CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
   endif
   CFLAGS += -DHAVE_ARCH_SYMBOL_HANDLING
+  CFLAGS += -DARCH_PREFER_SYMTAB
 endif
 
 ifndef NO_LIBUNWIND
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7eb9b27..dfc3151 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2373,6 +2373,12 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		}
 	}
 
+	if (prefer_symtab() && !perf_probe_event_need_dwarf(pev)) {
+		ret = find_probe_trace_events_from_map(pev, tevs, max_tevs, target);
+		if (ret > 0)
+			return ret; /* Found in symbol table */
+	}
+
 	/* Convert perf_probe_event with debuginfo */
 	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
 	if (ret != 0)
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 8564451..5f92906 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -141,6 +141,12 @@ extern int show_available_funcs(const char *module, struct strfilter *filter,
 extern int probe_function_filter(struct map *map __maybe_unused,
 					struct symbol *sym);
 
+#ifdef ARCH_PREFER_SYMTAB
+extern bool prefer_symtab(void);
+#else
+static inline bool prefer_symtab(void) { return false; };
+#endif
+
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024
 
-- 
2.1.3

