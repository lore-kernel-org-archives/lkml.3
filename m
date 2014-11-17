Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaKQTIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:08:30 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43871 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaKQTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:26 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v3 08/13] perf/x86: enforce HT bug workaround with PEBS for SNB/IVB/HSW
Date: Mon, 17 Nov 2014 20:07:00 +0100
Message-Id: <1416251225-17721-9-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416251225-17721-1-git-send-email-eranian@google.com>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

This patch modifies the PEBS constraint tables for SNB/IVB/HSW
such that corrupting events supporting PEBS activate the HT
workaround.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.h          | 20 +++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 28 ++++++++++++++++++----------
 2 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 964ded1..bbb7ffd3 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -324,22 +324,40 @@ struct cpu_hw_events {
 
 /* Check flags and event code, and set the HSW load flag */
 #define INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD(code, n) \
-	__EVENT_CONSTRAINT(code, n, 			\
+	__EVENT_CONSTRAINT(code, n,			\
 			  ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LD_HSW)
 
+#define INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_XLD(code, n) \
+	__EVENT_CONSTRAINT(code, n,			\
+			  ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS, \
+			  HWEIGHT(n), 0, \
+			  PERF_X86_EVENT_PEBS_LD_HSW|PERF_X86_EVENT_EXCL)
+
 /* Check flags and event code/umask, and set the HSW store flag */
 #define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(code, n) \
 	__EVENT_CONSTRAINT(code, n, 			\
 			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
+#define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XST(code, n) \
+	__EVENT_CONSTRAINT(code, n,			\
+			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  HWEIGHT(n), 0, \
+			  PERF_X86_EVENT_PEBS_ST_HSW|PERF_X86_EVENT_EXCL)
+
 /* Check flags and event code/umask, and set the HSW load flag */
 #define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(code, n) \
 	__EVENT_CONSTRAINT(code, n, 			\
 			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LD_HSW)
 
+#define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XLD(code, n) \
+	__EVENT_CONSTRAINT(code, n,			\
+			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  HWEIGHT(n), 0, \
+			  PERF_X86_EVENT_PEBS_LD_HSW|PERF_X86_EVENT_EXCL)
+
 /* Check flags and event code/umask, and set the HSW N/A flag */
 #define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_NA(code, n) \
 	__EVENT_CONSTRAINT(code, n, 			\
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 495ae97..d2f0214 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -611,6 +611,10 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+        INTEL_EXCLEVT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
+        INTEL_EXCLEVT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+        INTEL_EXCLEVT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+        INTEL_EXCLEVT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	/* Allow all events as PEBS with no flags */
 	INTEL_ALL_EVENT_CONSTRAINT(0, 0xf),
 	EVENT_CONSTRAINT_END
@@ -622,6 +626,10 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	INTEL_EXCLEVT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	/* Allow all events as PEBS with no flags */
 	INTEL_ALL_EVENT_CONSTRAINT(0, 0xf),
         EVENT_CONSTRAINT_END
@@ -633,16 +641,16 @@ struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_NA(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_STORES */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x42d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_STORES */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
-	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD(0xd2, 0xf),    /* MEM_LOAD_UOPS_L3_HIT_RETIRED.* */
-	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD(0xd3, 0xf),    /* MEM_LOAD_UOPS_L3_MISS_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XLD(0x11d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XLD(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XLD(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XLD(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XST(0x12d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XST(0x42d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XST(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
+	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_XLD(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_XLD(0xd2, 0xf),    /* MEM_LOAD_UOPS_L3_HIT_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_XLD(0xd3, 0xf),    /* MEM_LOAD_UOPS_L3_MISS_RETIRED.* */
 	/* Allow all events as PEBS with no flags */
 	INTEL_ALL_EVENT_CONSTRAINT(0, 0xf),
 	EVENT_CONSTRAINT_END
-- 
1.9.1

