Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaLOOvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:51:25 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35457 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaLOOvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:51:18 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [PATCHv2 8/8] perf probe powerpc: Fixup function entry if using kallsyms lookup
Date: Mon, 15 Dec 2014 20:20:38 +0530
Message-Id: <e27b74c5d94b240cb72ce0c7d6221acf758ebc8a.1418654436.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121514-0029-0000-0000-000000D1CF5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On powerpc ABIv2, if no debug-info is found and we use kallsyms, we need
to fixup the function entry to point to the local entry point. Use
offset of 8 since current toolchains always generate 2 instructions (8
bytes).

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
Changes:
Generalize and introduce helper to post-process trace point.

 tools/perf/arch/powerpc/util/sym-handling.c | 17 +++++++++++++++++
 tools/perf/util/probe-event.c               |  1 +
 tools/perf/util/probe-event.h               | 10 ++++++++++
 3 files changed, 28 insertions(+)

diff --git a/tools/perf/arch/powerpc/util/sym-handling.c b/tools/perf/arch/powerpc/util/sym-handling.c
index 22fc2e6..30c8797 100644
--- a/tools/perf/arch/powerpc/util/sym-handling.c
+++ b/tools/perf/arch/powerpc/util/sym-handling.c
@@ -45,3 +45,20 @@ inline bool prefer_symtab(void)
 	return false;
 #endif
 }
+
+void arch_fix_tev_from_maps(struct perf_probe_event *pev __maybe_unused,
+			    struct probe_trace_event *tev __maybe_unused,
+			    struct map *map __maybe_unused)
+{
+#if defined(_CALL_ELF) && _CALL_ELF == 2
+	/*
+	 * If we used kallsyms, we should fixup the function entry address here.
+	 * ppc64 ABIv2 local entry point is currently always 2 instructions (8 bytes)
+	 * after the global entry point. Fix this if it ever changes.
+	 */
+	if (!pev->uprobes && map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS) {
+		tev->point.address += 8;
+		tev->point.offset += 8;
+	}
+#endif
+}
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index dfc3151..85f37a4 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2340,6 +2340,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 					strdup_or_goto(pev->args[i].type,
 							nomem_out);
 		}
+		arch_fix_tev_from_maps(pev, tev, map);
 	}
 
 out:
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 5f92906..335a6a4 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -147,6 +147,16 @@ extern bool prefer_symtab(void);
 static inline bool prefer_symtab(void) { return false; };
 #endif
 
+#ifdef HAVE_ARCH_SYMBOL_HANDLING
+extern void arch_fix_tev_from_maps(struct perf_probe_event *pev __maybe_unused,
+				   struct probe_trace_event *tev __maybe_unused,
+				   struct map *map __maybe_unused);
+#else
+static inline void arch_fix_tev_from_maps(struct perf_probe_event *pev __maybe_unused,
+					  struct probe_trace_event *tev __maybe_unused,
+					  struct map *map __maybe_unused) { }
+#endif
+
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024
 
-- 
2.1.3

