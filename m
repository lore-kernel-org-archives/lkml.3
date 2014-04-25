Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaDYJPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:15:08 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:34838 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaDYJMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:12:23 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 11/11] perf kvm: add stat support on s390
Date: Fri, 25 Apr 2014 11:12:33 +0200
Message-Id: <1398417153-57347-12-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042509-2966-0000-0000-00000B0C5C59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

This patch allows perf to record SIE trace events, decode them and print
performance statistics.

Commands perf kvm stat record, report and stat are supported.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/uapi/asm/kvm.h |   7 ++
 tools/perf/MANIFEST              |   3 +
 tools/perf/arch/s390/Makefile    |   1 +
 tools/perf/builtin-kvm.c         | 151 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 159 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 0fc2643..7ef3dd4 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -13,6 +13,7 @@
  *               Christian Borntraeger <borntraeger@de.ibm.com>
  */
 #include <linux/types.h>
+#include <asm/sie.h>
 
 #define __KVM_S390
 #define __KVM_HAVE_GUEST_DEBUG
@@ -128,4 +129,10 @@ struct kvm_sync_regs {
 #define KVM_REG_S390_PFSELECT	(KVM_REG_S390 | KVM_REG_SIZE_U64 | 0x7)
 #define KVM_REG_S390_PP		(KVM_REG_S390 | KVM_REG_SIZE_U64 | 0x8)
 #define KVM_REG_S390_GBEA	(KVM_REG_S390 | KVM_REG_SIZE_U64 | 0x9)
+
+#define VCPU_ID "id"
+
+#define KVM_ENTRY "kvm:kvm_s390_sie_enter"
+#define KVM_EXIT "kvm:kvm_s390_sie_exit"
+#define KVM_EXIT_REASON "icptcode"
 #endif
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index c0c87c8..021124d 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -35,3 +35,6 @@ arch/x86/include/asm/kvm_host.h
 arch/x86/include/uapi/asm/svm.h
 arch/x86/include/uapi/asm/vmx.h
 arch/x86/include/uapi/asm/kvm.h
+arch/s390/include/asm/sigp.h
+arch/s390/include/uapi/asm/sie.h
+arch/s390/include/uapi/asm/kvm.h
diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 744e629..ddfdb80 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -3,3 +3,4 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+HAVE_KVM_STAT_SUPPORT := 1
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 9a162ae..7ca4d31 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -36,6 +36,7 @@ struct event_key {
 	#define INVALID_KEY     (~0ULL)
 	u64 key;
 	int info;
+	struct exit_reasons_table *exit_reasons;
 };
 
 struct kvm_event_stats {
@@ -70,6 +71,9 @@ struct kvm_events_ops {
 	bool (*is_begin_event)(struct perf_evsel *evsel,
 			       struct perf_sample *sample,
 			       struct event_key *key);
+	bool (*is_child_event)(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key);
 	bool (*is_end_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample, struct event_key *key);
 	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
@@ -82,6 +86,13 @@ struct exit_reasons_table {
 	const char *reason;
 };
 
+struct child_event_ops {
+	const char *name;
+	void (*get_key)(struct perf_evsel *evsel,
+			struct perf_sample *sample,
+			struct event_key *key);
+};
+
 #define DECODE_STR_LEN_MAX 80
 
 #define EVENTS_BITS		12
@@ -164,9 +175,84 @@ static bool exit_event_end(struct perf_evsel *evsel,
 		symbols, { -1, NULL }			\
 	}
 
+#if defined(__i386__) || defined(__x86_64__)
+
 define_exit_reasons_table(vmx_exit_reasons, VMX_EXIT_REASONS);
 define_exit_reasons_table(svm_exit_reasons, SVM_EXIT_REASONS);
 
+static struct child_event_ops child_events[] = {};
+
+#elif defined(__s390x__)
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
+};
+#endif
+
+static bool exit_event_child(struct perf_evsel *evsel,
+			     struct perf_sample *sample,
+			     struct event_key *key)
+{
+	int i;
+	int nevents = ARRAY_SIZE(child_events);
+
+	for (i = 0; i < nevents; i++) {
+		if (!strcmp(evsel->name, child_events[i].name)) {
+			child_events[i].get_key(evsel, sample, key);
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static const char *get_exit_reason(struct perf_kvm_stat *kvm,
 				   struct exit_reasons_table *tbl,
 				   u64 exit_code)
@@ -186,7 +272,7 @@ static void exit_event_decode_key(struct perf_kvm_stat *kvm,
 				  struct event_key *key,
 				  char *decode)
 {
-	const char *exit_reason = get_exit_reason(kvm, kvm->exit_reasons,
+	const char *exit_reason = get_exit_reason(kvm, key->exit_reasons,
 						  key->key);
 
 	scnprintf(decode, kvm->decode_str_len, "%s", exit_reason);
@@ -195,10 +281,12 @@ static void exit_event_decode_key(struct perf_kvm_stat *kvm,
 static struct kvm_events_ops exit_events = {
 	.is_begin_event = exit_event_begin,
 	.is_end_event = exit_event_end,
+	.is_child_event = exit_event_child,
 	.decode_key = exit_event_decode_key,
 	.name = "VM-EXIT"
 };
 
+#if defined(__i386__) || defined(__x86_64__)
 /*
  * For the mmio events, we treat:
  * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
@@ -308,6 +396,7 @@ static struct kvm_events_ops ioport_events = {
 	.decode_key = ioport_event_decode_key,
 	.name = "IO Port Access"
 };
+#endif
 
 static bool register_kvm_events_ops(struct perf_kvm_stat *kvm)
 {
@@ -315,10 +404,12 @@ static bool register_kvm_events_ops(struct perf_kvm_stat *kvm)
 
 	if (!strcmp(kvm->report_event, "vmexit"))
 		kvm->events_ops = &exit_events;
+#if defined(__i386__) || defined(__x86_64__)
 	else if (!strcmp(kvm->report_event, "mmio"))
 		kvm->events_ops = &mmio_events;
 	else if (!strcmp(kvm->report_event, "ioport"))
 		kvm->events_ops = &ioport_events;
+#endif
 	else {
 		pr_err("Unknown report event:%s\n", kvm->report_event);
 		ret = false;
@@ -530,16 +621,38 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
 		char decode[DECODE_STR_LEN_MAX];
 
 		kvm->events_ops->decode_key(kvm, &event->key, decode);
+
+#if defined(__i386__) || defined(__x86_64__)
 		if (strcmp(decode, "HLT")) {
 			pr_info("%" PRIu64 " VM %d, vcpu %d: %*s event took %" PRIu64 "usec\n",
 				 sample->time, sample->pid, vcpu_record->vcpu_id,
 				 32, decode, time_diff/1000);
 		}
+
+#elif defined(__s390x__)
+		pr_info("%" PRIu64 " VM %d, vcpu %d: %*s event took %" PRIu64 "usec\n",
+			sample->time, sample->pid, vcpu_record->vcpu_id,
+			kvm->decode_str_len, decode, time_diff/1000);
+#endif
 	}
 
 	return update_kvm_event(event, vcpu, time_diff);
 }
 
+static bool handle_child_event(struct perf_kvm_stat *kvm,
+			       struct vcpu_event_record *vcpu_record,
+			       struct event_key *key)
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
 static
 struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 					  struct perf_evsel *evsel,
@@ -568,7 +681,8 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 			     struct perf_sample *sample)
 {
 	struct vcpu_event_record *vcpu_record;
-	struct event_key key = {.key = INVALID_KEY};
+	struct event_key key = { .key = INVALID_KEY,
+				 .exit_reasons = kvm->exit_reasons };
 
 	vcpu_record = per_vcpu_record(thread, evsel, sample);
 	if (!vcpu_record)
@@ -582,6 +696,9 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
 		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
 
+	if (kvm->events_ops->is_child_event(evsel, sample, &key))
+		return handle_child_event(kvm, vcpu_record, &key);
+
 	if (kvm->events_ops->is_end_event(evsel, sample, &key))
 		return handle_end_event(kvm, vcpu_record, &key, sample);
 
@@ -838,6 +955,7 @@ static int process_sample_event(struct perf_tool *tool,
 	return 0;
 }
 
+#if defined(__i386__) || defined(__x86_64__)
 static int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
 {
 	if (strstr(cpuid, "Intel")) {
@@ -856,6 +974,22 @@ static int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
 	return 0;
 }
 
+#elif defined(__s390x__)
+static int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
+{
+	if (strstr(cpuid, "IBM/S390")) {
+		kvm->exit_reasons = sie_exit_reasons;
+		kvm->decode_str_len = 40;
+		kvm->exit_reasons_isa = "SIE";
+	} else {
+		pr_err("CPU %s is not supported.\n", cpuid);
+		return -ENOTSUP;
+	}
+
+	return 0;
+}
+#endif
+
 static int cpu_isa_config(struct perf_kvm_stat *kvm)
 {
 	char buf[64], *cpuid;
@@ -864,7 +998,7 @@ static int cpu_isa_config(struct perf_kvm_stat *kvm)
 	if (kvm->live) {
 		err = get_cpuid(buf, sizeof(buf));
 		if (err != 0) {
-			pr_err("Failed to look up CPU type (Intel or AMD)\n");
+			pr_err("Failed to look up CPU type\n");
 			return err;
 		}
 		cpuid = buf;
@@ -1310,12 +1444,23 @@ exit:
 	return ret;
 }
 
+#if defined(__i386__) || defined(__x86_64__)
 static const char * const kvm_events_tp[] = {
 	"kvm:kvm_entry",
 	"kvm:kvm_exit",
 	"kvm:kvm_mmio",
 	"kvm:kvm_pio",
 };
+#elif defined(__s390x__)
+static const char * const kvm_events_tp[] = {
+	"kvm:kvm_s390_sie_enter",
+	"kvm:kvm_s390_sie_exit",
+	"kvm:kvm_s390_intercept_instruction",
+	"kvm:kvm_s390_handle_sigp",
+	"kvm:kvm_s390_handle_diag",
+	"kvm:kvm_s390_intercept_prog",
+};
+#endif
 
 #define STRDUP_FAIL_EXIT(s)		\
 	({	char *_p;		\
-- 
1.8.4.2

