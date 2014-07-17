Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaGQQXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:23:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:52084 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934743AbaGQQNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:08 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/33] perf kvm: Add stat support on s390
Date: Thu, 17 Jul 2014 13:12:06 -0300
Message-Id: <1405613555-23380-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

On s390, the vmexit event has a tree-like structure: between
exit_event_begin and exit_event_end several other events may happen and
with each of them refining the previous ones.

This patch adds a decoder for such events to the generic code and also
the files <asm/kvm_perf.h> and kvm-stat.c for s390.

Commands 'perf kvm stat record', 'report' and 'live' are supported.

Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1404397747-20939-5-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/s390/include/uapi/asm/Kbuild     |   1 +
 arch/s390/include/uapi/asm/kvm_perf.h |  25 ++++++++
 tools/perf/Documentation/perf-kvm.txt |  16 +++---
 tools/perf/MANIFEST                   |   2 +
 tools/perf/arch/s390/Makefile         |   2 +
 tools/perf/arch/s390/util/kvm-stat.c  | 105 ++++++++++++++++++++++++++++++++++
 tools/perf/builtin-kvm.c              |  52 +++++++++++++++--
 tools/perf/util/kvm-stat.h            |   9 +++
 8 files changed, 201 insertions(+), 11 deletions(-)
 create mode 100644 arch/s390/include/uapi/asm/kvm_perf.h
 create mode 100644 tools/perf/arch/s390/util/kvm-stat.c

diff --git a/arch/s390/include/uapi/asm/Kbuild b/arch/s390/include/uapi/asm/Kbuild
index 6a9a9eb645f5..0e2b54db82bc 100644
--- a/arch/s390/include/uapi/asm/Kbuild
+++ b/arch/s390/include/uapi/asm/Kbuild
@@ -16,6 +16,7 @@ header-y += ioctls.h
 header-y += ipcbuf.h
 header-y += kvm.h
 header-y += kvm_para.h
+header-y += kvm_perf.h
 header-y += kvm_virtio.h
 header-y += mman.h
 header-y += monwriter.h
diff --git a/arch/s390/include/uapi/asm/kvm_perf.h b/arch/s390/include/uapi/asm/kvm_perf.h
new file mode 100644
index 000000000000..397282727e21
--- /dev/null
+++ b/arch/s390/include/uapi/asm/kvm_perf.h
@@ -0,0 +1,25 @@
+/*
+ * Definitions for perf-kvm on s390
+ *
+ * Copyright 2014 IBM Corp.
+ * Author(s): Alexander Yarygin <yarygin@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_KVM_PERF_S390_H
+#define __LINUX_KVM_PERF_S390_H
+
+#include <asm/sie.h>
+
+#define DECODE_STR_LEN 40
+
+#define VCPU_ID "id"
+
+#define KVM_ENTRY_TRACE "kvm:kvm_s390_sie_enter"
+#define KVM_EXIT_TRACE "kvm:kvm_s390_sie_exit"
+#define KVM_EXIT_REASON "icptcode"
+
+#endif
diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 52276a6d2b75..6e689dc89a2f 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -51,9 +51,9 @@ There are a couple of variants of perf kvm:
   'perf kvm stat <command>' to run a command and gather performance counter
   statistics.
   Especially, perf 'kvm stat record/report' generates a statistical analysis
-  of KVM events. Currently, vmexit, mmio and ioport events are supported.
-  'perf kvm stat record <command>' records kvm events and the events between
-  start and end <command>.
+  of KVM events. Currently, vmexit, mmio (x86 only) and ioport (x86 only)
+  events are supported. 'perf kvm stat record <command>' records kvm events
+  and the events between start and end <command>.
   And this command produces a file which contains tracing results of kvm
   events.
 
@@ -103,8 +103,8 @@ STAT REPORT OPTIONS
        analyze events which occures on this vcpu. (default: all vcpus)
 
 --event=<value>::
-       event to be analyzed. Possible values: vmexit, mmio, ioport.
-       (default: vmexit)
+       event to be analyzed. Possible values: vmexit, mmio (x86 only),
+       ioport (x86 only). (default: vmexit)
 -k::
 --key=<value>::
        Sorting key. Possible values: sample (default, sort by samples
@@ -138,7 +138,8 @@ STAT LIVE OPTIONS
 
 
 --event=<value>::
-       event to be analyzed. Possible values: vmexit, mmio, ioport.
+       event to be analyzed. Possible values: vmexit,
+       mmio (x86 only), ioport (x86 only).
        (default: vmexit)
 
 -k::
@@ -147,7 +148,8 @@ STAT LIVE OPTIONS
        number), time (sort by average time).
 
 --duration=<value>::
-       Show events other than HLT that take longer than duration usecs.
+       Show events other than HLT (x86 only) or Wait state (s390 only)
+       that take longer than duration usecs.
 
 SEE ALSO
 --------
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 02b485d619cd..344c4d3d0a4a 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -38,3 +38,5 @@ arch/x86/include/uapi/asm/svm.h
 arch/x86/include/uapi/asm/vmx.h
 arch/x86/include/uapi/asm/kvm.h
 arch/x86/include/uapi/asm/kvm_perf.h
+arch/s390/include/uapi/asm/sie.h
+arch/s390/include/uapi/asm/kvm_perf.h
diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 744e629797be..798ac7379c5f 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -3,3 +3,5 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+HAVE_KVM_STAT_SUPPORT := 1
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/kvm-stat.o
diff --git a/tools/perf/arch/s390/util/kvm-stat.c b/tools/perf/arch/s390/util/kvm-stat.c
new file mode 100644
index 000000000000..a5dbc07ec9dc
--- /dev/null
+++ b/tools/perf/arch/s390/util/kvm-stat.c
@@ -0,0 +1,105 @@
+/*
+ * Arch specific functions for perf kvm stat.
+ *
+ * Copyright 2014 IBM Corp.
+ * Author(s): Alexander Yarygin <yarygin@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+
+#include "../../util/kvm-stat.h"
+#include <asm/kvm_perf.h>
+
+define_exit_reasons_table(sie_exit_reasons, sie_intercept_code);
+define_exit_reasons_table(sie_icpt_insn_codes, icpt_insn_codes);
+define_exit_reasons_table(sie_sigp_order_codes, sigp_order_codes);
+define_exit_reasons_table(sie_diagnose_codes, diagnose_codes);
+define_exit_reasons_table(sie_icpt_prog_codes, icpt_prog_codes);
+
+static void event_icpt_insn_get_key(struct perf_evsel *evsel,
+				    struct perf_sample *sample,
+				    struct event_key *key)
+{
+	unsigned long insn;
+
+	insn = perf_evsel__intval(evsel, sample, "instruction");
+	key->key = icpt_insn_decoder(insn);
+	key->exit_reasons = sie_icpt_insn_codes;
+}
+
+static void event_sigp_get_key(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key)
+{
+	key->key = perf_evsel__intval(evsel, sample, "order_code");
+	key->exit_reasons = sie_sigp_order_codes;
+}
+
+static void event_diag_get_key(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key)
+{
+	key->key = perf_evsel__intval(evsel, sample, "code");
+	key->exit_reasons = sie_diagnose_codes;
+}
+
+static void event_icpt_prog_get_key(struct perf_evsel *evsel,
+				    struct perf_sample *sample,
+				    struct event_key *key)
+{
+	key->key = perf_evsel__intval(evsel, sample, "code");
+	key->exit_reasons = sie_icpt_prog_codes;
+}
+
+static struct child_event_ops child_events[] = {
+	{ .name = "kvm:kvm_s390_intercept_instruction",
+	  .get_key = event_icpt_insn_get_key },
+	{ .name = "kvm:kvm_s390_handle_sigp",
+	  .get_key = event_sigp_get_key },
+	{ .name = "kvm:kvm_s390_handle_diag",
+	  .get_key = event_diag_get_key },
+	{ .name = "kvm:kvm_s390_intercept_prog",
+	  .get_key = event_icpt_prog_get_key },
+	{ NULL, NULL },
+};
+
+static struct kvm_events_ops exit_events = {
+	.is_begin_event = exit_event_begin,
+	.is_end_event = exit_event_end,
+	.child_ops = child_events,
+	.decode_key = exit_event_decode_key,
+	.name = "VM-EXIT"
+};
+
+const char * const kvm_events_tp[] = {
+	"kvm:kvm_s390_sie_enter",
+	"kvm:kvm_s390_sie_exit",
+	"kvm:kvm_s390_intercept_instruction",
+	"kvm:kvm_s390_handle_sigp",
+	"kvm:kvm_s390_handle_diag",
+	"kvm:kvm_s390_intercept_prog",
+	NULL,
+};
+
+struct kvm_reg_events_ops kvm_reg_events_ops[] = {
+	{ .name = "vmexit", .ops = &exit_events },
+	{ NULL, NULL },
+};
+
+const char * const kvm_skip_events[] = {
+	"Wait state",
+	NULL,
+};
+
+int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
+{
+	if (strstr(cpuid, "IBM/S390")) {
+		kvm->exit_reasons = sie_exit_reasons;
+		kvm->exit_reasons_isa = "SIE";
+	} else
+		return -ENOTSUP;
+
+	return 0;
+}
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index fc2d63d3e791..43367eb00510 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -88,7 +88,7 @@ void exit_event_decode_key(struct perf_kvm_stat *kvm,
 			   struct event_key *key,
 			   char *decode)
 {
-	const char *exit_reason = get_exit_reason(kvm, kvm->exit_reasons,
+	const char *exit_reason = get_exit_reason(kvm, key->exit_reasons,
 						  key->key);
 
 	scnprintf(decode, DECODE_STR_LEN, "%s", exit_reason);
@@ -261,6 +261,43 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 	return true;
 }
 
+static bool is_child_event(struct perf_kvm_stat *kvm,
+			   struct perf_evsel *evsel,
+			   struct perf_sample *sample,
+			   struct event_key *key)
+{
+	struct child_event_ops *child_ops;
+
+	child_ops = kvm->events_ops->child_ops;
+
+	if (!child_ops)
+		return false;
+
+	for (; child_ops->name; child_ops++) {
+		if (!strcmp(evsel->name, child_ops->name)) {
+			child_ops->get_key(evsel, sample, key);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool handle_child_event(struct perf_kvm_stat *kvm,
+			       struct vcpu_event_record *vcpu_record,
+			       struct event_key *key,
+			       struct perf_sample *sample __maybe_unused)
+{
+	struct kvm_event *event = NULL;
+
+	if (key->key != INVALID_KEY)
+		event = find_create_kvm_event(kvm, key);
+
+	vcpu_record->last_event = event;
+
+	return true;
+}
+
 static bool skip_event(const char *event)
 {
 	const char * const *skip_events;
@@ -361,7 +398,8 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 			     struct perf_sample *sample)
 {
 	struct vcpu_event_record *vcpu_record;
-	struct event_key key = {.key = INVALID_KEY};
+	struct event_key key = { .key = INVALID_KEY,
+				 .exit_reasons = kvm->exit_reasons };
 
 	vcpu_record = per_vcpu_record(thread, evsel, sample);
 	if (!vcpu_record)
@@ -375,6 +413,9 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
 		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
 
+	if (is_child_event(kvm, evsel, sample, &key))
+		return handle_child_event(kvm, vcpu_record, &key, sample);
+
 	if (kvm->events_ops->is_end_event(evsel, sample, &key))
 		return handle_end_event(kvm, vcpu_record, &key, sample);
 
@@ -1143,7 +1184,8 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
 	const struct option kvm_events_report_options[] = {
 		OPT_STRING(0, "event", &kvm->report_event, "report event",
-			    "event for reporting: vmexit, mmio, ioport"),
+			   "event for reporting: vmexit, "
+			   "mmio (x86 only), ioport (x86 only)"),
 		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
 			    "vcpu id to report"),
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
@@ -1249,7 +1291,9 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 			"key for sorting: sample(sort by samples number)"
 			" time (sort by avg time)"),
 		OPT_U64(0, "duration", &kvm->duration,
-		    "show events other than HALT that take longer than duration usecs"),
+			"show events other than"
+			" HLT (x86 only) or Wait state (s390 only)"
+			" that take longer than duration usecs"),
 		OPT_END()
 	};
 	const char * const live_usage[] = {
diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
index ba937caa28ac..0b5a8cd2ee79 100644
--- a/tools/perf/util/kvm-stat.h
+++ b/tools/perf/util/kvm-stat.h
@@ -12,6 +12,7 @@ struct event_key {
 	#define INVALID_KEY     (~0ULL)
 	u64 key;
 	int info;
+	struct exit_reasons_table *exit_reasons;
 };
 
 struct kvm_event_stats {
@@ -41,12 +42,20 @@ struct kvm_event_key {
 
 struct perf_kvm_stat;
 
+struct child_event_ops {
+	void (*get_key)(struct perf_evsel *evsel,
+			struct perf_sample *sample,
+			struct event_key *key);
+	const char *name;
+};
+
 struct kvm_events_ops {
 	bool (*is_begin_event)(struct perf_evsel *evsel,
 			       struct perf_sample *sample,
 			       struct event_key *key);
 	bool (*is_end_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample, struct event_key *key);
+	struct child_event_ops *child_ops;
 	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
 			   char *decode);
 	const char *name;
-- 
1.9.3

