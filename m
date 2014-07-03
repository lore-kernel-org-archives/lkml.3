Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbaGCO3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:29:34 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:43941 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028AbaGCO3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:29:21 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: [PATCH 2/4] perf kvm: Move arch specific code into arch/
Date: Thu,  3 Jul 2014 18:29:05 +0400
Message-Id: <1404397747-20939-3-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070314-1948-0000-0000-000000691D43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parts of a 'perf kvm stat' code make sense only for x86.
Let's move this code into the arch/x86/kvm-stat.c file and add
util/kvm-stat.h for generic structure definitions.

Add a global array 'kvm_reg_events_ops' for accessing the
arch-specific 'kvm_events_ops' from generic code.

Since the several global arrays (i.e. 'kvm_events_tp') have been moved
to arch/*, we can not know their sizes and use them directly in
builtin-kvm.c. This patch fixes that problem by adding trimming
NULL element to each array and changing the behavior of their handlers
in generic code.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 tools/perf/Makefile.perf            |    1 +
 tools/perf/arch/x86/Makefile        |    1 +
 tools/perf/arch/x86/util/kvm-stat.c |  151 ++++++++++++++++++
 tools/perf/builtin-kvm.c            |  297 ++++-------------------------------
 tools/perf/util/kvm-stat.h          |  130 +++++++++++++++
 5 files changed, 317 insertions(+), 263 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/kvm-stat.c
 create mode 100644 tools/perf/util/kvm-stat.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ae20edf..f1a590f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -300,6 +300,7 @@ LIB_H += ui/progress.h
 LIB_H += ui/util.h
 LIB_H += ui/ui.h
 LIB_H += util/data.h
+LIB_H += util/kvm-stat.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index d393901..9b21881 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -16,3 +16,4 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
 LIB_H += arch/$(ARCH)/util/tsc.h
 HAVE_KVM_STAT_SUPPORT := 1
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/kvm-stat.o
diff --git a/tools/perf/arch/x86/util/kvm-stat.c b/tools/perf/arch/x86/util/kvm-stat.c
new file mode 100644
index 0000000..2f8d2c1
--- /dev/null
+++ b/tools/perf/arch/x86/util/kvm-stat.c
@@ -0,0 +1,151 @@
+#include "../../util/kvm-stat.h"
+#include <asm/kvm_perf.h>
+
+define_exit_reasons_table(vmx_exit_reasons, VMX_EXIT_REASONS);
+define_exit_reasons_table(svm_exit_reasons, SVM_EXIT_REASONS);
+
+static struct kvm_events_ops exit_events = {
+	.is_begin_event = exit_event_begin,
+	.is_end_event = exit_event_end,
+	.decode_key = exit_event_decode_key,
+	.name = "VM-EXIT"
+};
+
+/*
+ * For the mmio events, we treat:
+ * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
+ * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
+ */
+static void mmio_event_get_key(struct perf_evsel *evsel, struct perf_sample *sample,
+			       struct event_key *key)
+{
+	key->key  = perf_evsel__intval(evsel, sample, "gpa");
+	key->info = perf_evsel__intval(evsel, sample, "type");
+}
+
+#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
+#define KVM_TRACE_MMIO_READ 1
+#define KVM_TRACE_MMIO_WRITE 2
+
+static bool mmio_event_begin(struct perf_evsel *evsel,
+			     struct perf_sample *sample, struct event_key *key)
+{
+	/* MMIO read begin event in kernel. */
+	if (kvm_exit_event(evsel))
+		return true;
+
+	/* MMIO write begin event in kernel. */
+	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
+	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_WRITE) {
+		mmio_event_get_key(evsel, sample, key);
+		return true;
+	}
+
+	return false;
+}
+
+static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
+			   struct event_key *key)
+{
+	/* MMIO write end event in kernel. */
+	if (kvm_entry_event(evsel))
+		return true;
+
+	/* MMIO read end event in kernel.*/
+	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
+	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_READ) {
+		mmio_event_get_key(evsel, sample, key);
+		return true;
+	}
+
+	return false;
+}
+
+static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
+				  struct event_key *key,
+				  char *decode)
+{
+	scnprintf(decode, DECODE_STR_LEN, "%#lx:%s",
+		  (unsigned long)key->key,
+		  key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
+}
+
+static struct kvm_events_ops mmio_events = {
+	.is_begin_event = mmio_event_begin,
+	.is_end_event = mmio_event_end,
+	.decode_key = mmio_event_decode_key,
+	.name = "MMIO Access"
+};
+
+ /* The time of emulation pio access is from kvm_pio to kvm_entry. */
+static void ioport_event_get_key(struct perf_evsel *evsel,
+				 struct perf_sample *sample,
+				 struct event_key *key)
+{
+	key->key  = perf_evsel__intval(evsel, sample, "port");
+	key->info = perf_evsel__intval(evsel, sample, "rw");
+}
+
+static bool ioport_event_begin(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key)
+{
+	if (!strcmp(evsel->name, "kvm:kvm_pio")) {
+		ioport_event_get_key(evsel, sample, key);
+		return true;
+	}
+
+	return false;
+}
+
+static bool ioport_event_end(struct perf_evsel *evsel,
+			     struct perf_sample *sample __maybe_unused,
+			     struct event_key *key __maybe_unused)
+{
+	return kvm_entry_event(evsel);
+}
+
+static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
+				    struct event_key *key,
+				    char *decode)
+{
+	scnprintf(decode, DECODE_STR_LEN, "%#llx:%s",
+		  (unsigned long long)key->key,
+		  key->info ? "POUT" : "PIN");
+}
+
+static struct kvm_events_ops ioport_events = {
+	.is_begin_event = ioport_event_begin,
+	.is_end_event = ioport_event_end,
+	.decode_key = ioport_event_decode_key,
+	.name = "IO Port Access"
+};
+
+const char * const kvm_events_tp[] = {
+	"kvm:kvm_entry",
+	"kvm:kvm_exit",
+	"kvm:kvm_mmio",
+	"kvm:kvm_pio",
+	NULL,
+};
+
+struct kvm_reg_events_ops kvm_reg_events_ops[] = {
+	{ .name = "vmexit", .ops = &exit_events },
+	{ .name = "mmio", .ops = &mmio_events },
+	{ .name = "ioport", .ops = &ioport_events },
+	{ NULL, NULL },
+};
+
+int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
+{
+	if (strstr(cpuid, "Intel")) {
+		kvm->exit_reasons = vmx_exit_reasons;
+		kvm->exit_reasons_isa = "VMX";
+	} else if (strstr(cpuid, "AMD")) {
+		kvm->exit_reasons = svm_exit_reasons;
+		kvm->exit_reasons_isa = "SVM";
+	} else
+		return -ENOTSUP;
+
+	return 0;
+}
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 6d73346..75ee8c1 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -31,109 +31,23 @@
 
 #ifdef HAVE_KVM_STAT_SUPPORT
 #include <asm/kvm_perf.h>
+#include "util/kvm-stat.h"
 
-struct event_key {
-	#define INVALID_KEY     (~0ULL)
-	u64 key;
-	int info;
-};
-
-struct kvm_event_stats {
-	u64 time;
-	struct stats stats;
-};
-
-struct kvm_event {
-	struct list_head hash_entry;
-	struct rb_node rb;
-
-	struct event_key key;
-
-	struct kvm_event_stats total;
-
-	#define DEFAULT_VCPU_NUM 8
-	int max_vcpu;
-	struct kvm_event_stats *vcpu;
-};
-
-typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
-
-struct kvm_event_key {
-	const char *name;
-	key_cmp_fun key;
-};
-
-
-struct perf_kvm_stat;
-
-struct kvm_events_ops {
-	bool (*is_begin_event)(struct perf_evsel *evsel,
-			       struct perf_sample *sample,
-			       struct event_key *key);
-	bool (*is_end_event)(struct perf_evsel *evsel,
-			     struct perf_sample *sample, struct event_key *key);
-	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
-			   char *decode);
-	const char *name;
-};
-
-struct exit_reasons_table {
-	unsigned long exit_code;
-	const char *reason;
-};
-
-#define EVENTS_BITS		12
-#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
-
-struct perf_kvm_stat {
-	struct perf_tool    tool;
-	struct record_opts  opts;
-	struct perf_evlist  *evlist;
-	struct perf_session *session;
-
-	const char *file_name;
-	const char *report_event;
-	const char *sort_key;
-	int trace_vcpu;
-
-	struct exit_reasons_table *exit_reasons;
-	const char *exit_reasons_isa;
-
-	struct kvm_events_ops *events_ops;
-	key_cmp_fun compare;
-	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
-
-	u64 total_time;
-	u64 total_count;
-	u64 lost_events;
-	u64 duration;
-
-	const char *pid_str;
-	struct intlist *pid_list;
-
-	struct rb_root result;
-
-	int timerfd;
-	unsigned int display_time;
-	bool live;
-};
-
-
-static void exit_event_get_key(struct perf_evsel *evsel,
-			       struct perf_sample *sample,
-			       struct event_key *key)
+void exit_event_get_key(struct perf_evsel *evsel,
+			struct perf_sample *sample,
+			struct event_key *key)
 {
 	key->info = 0;
 	key->key = perf_evsel__intval(evsel, sample, KVM_EXIT_REASON);
 }
 
-static bool kvm_exit_event(struct perf_evsel *evsel)
+bool kvm_exit_event(struct perf_evsel *evsel)
 {
 	return !strcmp(evsel->name, KVM_EXIT_TRACE);
 }
 
-static bool exit_event_begin(struct perf_evsel *evsel,
-			     struct perf_sample *sample, struct event_key *key)
+bool exit_event_begin(struct perf_evsel *evsel,
+		      struct perf_sample *sample, struct event_key *key)
 {
 	if (kvm_exit_event(evsel)) {
 		exit_event_get_key(evsel, sample, key);
@@ -143,26 +57,18 @@ static bool exit_event_begin(struct perf_evsel *evsel,
 	return false;
 }
 
-static bool kvm_entry_event(struct perf_evsel *evsel)
+bool kvm_entry_event(struct perf_evsel *evsel)
 {
 	return !strcmp(evsel->name, KVM_ENTRY_TRACE);
 }
 
-static bool exit_event_end(struct perf_evsel *evsel,
-			   struct perf_sample *sample __maybe_unused,
-			   struct event_key *key __maybe_unused)
+bool exit_event_end(struct perf_evsel *evsel,
+		    struct perf_sample *sample __maybe_unused,
+		    struct event_key *key __maybe_unused)
 {
 	return kvm_entry_event(evsel);
 }
 
-#define define_exit_reasons_table(name, symbols)	\
-	static struct exit_reasons_table name[] = {	\
-		symbols, { -1, NULL }			\
-	}
-
-define_exit_reasons_table(vmx_exit_reasons, VMX_EXIT_REASONS);
-define_exit_reasons_table(svm_exit_reasons, SVM_EXIT_REASONS);
-
 static const char *get_exit_reason(struct perf_kvm_stat *kvm,
 				   struct exit_reasons_table *tbl,
 				   u64 exit_code)
@@ -178,9 +84,9 @@ static const char *get_exit_reason(struct perf_kvm_stat *kvm,
 	return "UNKNOWN";
 }
 
-static void exit_event_decode_key(struct perf_kvm_stat *kvm,
-				  struct event_key *key,
-				  char *decode)
+void exit_event_decode_key(struct perf_kvm_stat *kvm,
+			   struct event_key *key,
+			   char *decode)
 {
 	const char *exit_reason = get_exit_reason(kvm, kvm->exit_reasons,
 						  key->key);
@@ -188,139 +94,20 @@ static void exit_event_decode_key(struct perf_kvm_stat *kvm,
 	scnprintf(decode, DECODE_STR_LEN, "%s", exit_reason);
 }
 
-static struct kvm_events_ops exit_events = {
-	.is_begin_event = exit_event_begin,
-	.is_end_event = exit_event_end,
-	.decode_key = exit_event_decode_key,
-	.name = "VM-EXIT"
-};
-
-/*
- * For the mmio events, we treat:
- * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
- * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
- */
-static void mmio_event_get_key(struct perf_evsel *evsel, struct perf_sample *sample,
-			       struct event_key *key)
-{
-	key->key  = perf_evsel__intval(evsel, sample, "gpa");
-	key->info = perf_evsel__intval(evsel, sample, "type");
-}
-
-#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
-#define KVM_TRACE_MMIO_READ 1
-#define KVM_TRACE_MMIO_WRITE 2
-
-static bool mmio_event_begin(struct perf_evsel *evsel,
-			     struct perf_sample *sample, struct event_key *key)
-{
-	/* MMIO read begin event in kernel. */
-	if (kvm_exit_event(evsel))
-		return true;
-
-	/* MMIO write begin event in kernel. */
-	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
-	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_WRITE) {
-		mmio_event_get_key(evsel, sample, key);
-		return true;
-	}
-
-	return false;
-}
-
-static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
-			   struct event_key *key)
-{
-	/* MMIO write end event in kernel. */
-	if (kvm_entry_event(evsel))
-		return true;
-
-	/* MMIO read end event in kernel.*/
-	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
-	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_READ) {
-		mmio_event_get_key(evsel, sample, key);
-		return true;
-	}
-
-	return false;
-}
-
-static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
-				  struct event_key *key,
-				  char *decode)
-{
-	scnprintf(decode, DECODE_STR_LEN, "%#lx:%s", (unsigned long)key->key,
-				key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
-}
-
-static struct kvm_events_ops mmio_events = {
-	.is_begin_event = mmio_event_begin,
-	.is_end_event = mmio_event_end,
-	.decode_key = mmio_event_decode_key,
-	.name = "MMIO Access"
-};
-
- /* The time of emulation pio access is from kvm_pio to kvm_entry. */
-static void ioport_event_get_key(struct perf_evsel *evsel,
-				 struct perf_sample *sample,
-				 struct event_key *key)
+static bool register_kvm_events_ops(struct perf_kvm_stat *kvm)
 {
-	key->key  = perf_evsel__intval(evsel, sample, "port");
-	key->info = perf_evsel__intval(evsel, sample, "rw");
-}
+	struct kvm_reg_events_ops *events_ops = kvm_reg_events_ops;
 
-static bool ioport_event_begin(struct perf_evsel *evsel,
-			       struct perf_sample *sample,
-			       struct event_key *key)
-{
-	if (!strcmp(evsel->name, "kvm:kvm_pio")) {
-		ioport_event_get_key(evsel, sample, key);
-		return true;
+	for (events_ops = kvm_reg_events_ops; events_ops->name; events_ops++) {
+		if (!strcmp(events_ops->name, kvm->report_event)) {
+			kvm->events_ops = events_ops->ops;
+			return true;
+		}
 	}
 
 	return false;
 }
 
-static bool ioport_event_end(struct perf_evsel *evsel,
-			     struct perf_sample *sample __maybe_unused,
-			     struct event_key *key __maybe_unused)
-{
-	return kvm_entry_event(evsel);
-}
-
-static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
-				    struct event_key *key,
-				    char *decode)
-{
-	scnprintf(decode, DECODE_STR_LEN, "%#llx:%s", (unsigned long long)key->key,
-				key->info ? "POUT" : "PIN");
-}
-
-static struct kvm_events_ops ioport_events = {
-	.is_begin_event = ioport_event_begin,
-	.is_end_event = ioport_event_end,
-	.decode_key = ioport_event_decode_key,
-	.name = "IO Port Access"
-};
-
-static bool register_kvm_events_ops(struct perf_kvm_stat *kvm)
-{
-	bool ret = true;
-
-	if (!strcmp(kvm->report_event, "vmexit"))
-		kvm->events_ops = &exit_events;
-	else if (!strcmp(kvm->report_event, "mmio"))
-		kvm->events_ops = &mmio_events;
-	else if (!strcmp(kvm->report_event, "ioport"))
-		kvm->events_ops = &ioport_events;
-	else {
-		pr_err("Unknown report event:%s\n", kvm->report_event);
-		ret = false;
-	}
-
-	return ret;
-}
-
 struct vcpu_event_record {
 	int vcpu_id;
 	u64 start_time;
@@ -833,20 +620,6 @@ static int process_sample_event(struct perf_tool *tool,
 	return 0;
 }
 
-static int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
-{
-	if (strstr(cpuid, "Intel")) {
-		kvm->exit_reasons = vmx_exit_reasons;
-		kvm->exit_reasons_isa = "VMX";
-	} else if (strstr(cpuid, "AMD")) {
-		kvm->exit_reasons = svm_exit_reasons;
-		kvm->exit_reasons_isa = "SVM";
-	} else
-		return -ENOTSUP;
-
-	return 0;
-}
-
 static int cpu_isa_config(struct perf_kvm_stat *kvm)
 {
 	char buf[64], *cpuid;
@@ -1305,13 +1078,6 @@ exit:
 	return ret;
 }
 
-static const char * const kvm_events_tp[] = {
-	"kvm:kvm_entry",
-	"kvm:kvm_exit",
-	"kvm:kvm_mmio",
-	"kvm:kvm_pio",
-};
-
 #define STRDUP_FAIL_EXIT(s)		\
 	({	char *_p;		\
 	_p = strdup(s);		\
@@ -1323,7 +1089,7 @@ static const char * const kvm_events_tp[] = {
 static int
 kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
-	unsigned int rec_argc, i, j;
+	unsigned int rec_argc, i, j, events_tp_size;
 	const char **rec_argv;
 	const char * const record_args[] = {
 		"record",
@@ -1331,9 +1097,14 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		"-m", "1024",
 		"-c", "1",
 	};
+	const char * const *events_tp;
+	events_tp_size = 0;
+
+	for (events_tp = kvm_events_tp; *events_tp; events_tp++)
+		events_tp_size++;
 
 	rec_argc = ARRAY_SIZE(record_args) + argc + 2 +
-		   2 * ARRAY_SIZE(kvm_events_tp);
+		   2 * events_tp_size;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
@@ -1342,7 +1113,7 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = STRDUP_FAIL_EXIT(record_args[i]);
 
-	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
+	for (j = 0; j < events_tp_size; j++) {
 		rec_argv[i++] = "-e";
 		rec_argv[i++] = STRDUP_FAIL_EXIT(kvm_events_tp[j]);
 	}
@@ -1396,16 +1167,16 @@ static struct perf_evlist *kvm_live_event_list(void)
 {
 	struct perf_evlist *evlist;
 	char *tp, *name, *sys;
-	unsigned int j;
 	int err = -1;
+	const char * const *events_tp;
 
 	evlist = perf_evlist__new();
 	if (evlist == NULL)
 		return NULL;
 
-	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
+	for (events_tp = kvm_events_tp; *events_tp; events_tp++) {
 
-		tp = strdup(kvm_events_tp[j]);
+		tp = strdup(*events_tp);
 		if (tp == NULL)
 			goto out;
 
@@ -1414,7 +1185,7 @@ static struct perf_evlist *kvm_live_event_list(void)
 		name = strchr(tp, ':');
 		if (name == NULL) {
 			pr_err("Error parsing %s tracepoint: subsystem delimiter not found\n",
-				kvm_events_tp[j]);
+			       *events_tp);
 			free(tp);
 			goto out;
 		}
@@ -1422,7 +1193,7 @@ static struct perf_evlist *kvm_live_event_list(void)
 		name++;
 
 		if (perf_evlist__add_newtp(evlist, sys, name, NULL)) {
-			pr_err("Failed to add %s tracepoint to the list\n", kvm_events_tp[j]);
+			pr_err("Failed to add %s tracepoint to the list\n", *events_tp);
 			free(tp);
 			goto out;
 		}
diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
new file mode 100644
index 0000000..d0d9fb1
--- /dev/null
+++ b/tools/perf/util/kvm-stat.h
@@ -0,0 +1,130 @@
+#ifndef __PERF_KVM_STAT_H
+#define __PERF_KVM_STAT_H
+
+#include "../perf.h"
+#include "evsel.h"
+#include "evlist.h"
+#include "session.h"
+#include "tool.h"
+#include "stat.h"
+
+struct event_key {
+	#define INVALID_KEY     (~0ULL)
+	u64 key;
+	int info;
+};
+
+struct kvm_event_stats {
+	u64 time;
+	struct stats stats;
+};
+
+struct kvm_event {
+	struct list_head hash_entry;
+	struct rb_node rb;
+
+	struct event_key key;
+
+	struct kvm_event_stats total;
+
+	#define DEFAULT_VCPU_NUM 8
+	int max_vcpu;
+	struct kvm_event_stats *vcpu;
+};
+
+typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
+
+struct kvm_event_key {
+	const char *name;
+	key_cmp_fun key;
+};
+
+struct perf_kvm_stat;
+
+struct kvm_events_ops {
+	bool (*is_begin_event)(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key);
+	bool (*is_end_event)(struct perf_evsel *evsel,
+			     struct perf_sample *sample, struct event_key *key);
+	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
+			   char *decode);
+	const char *name;
+};
+
+struct exit_reasons_table {
+	unsigned long exit_code;
+	const char *reason;
+};
+
+#define EVENTS_BITS		12
+#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
+
+struct perf_kvm_stat {
+	struct perf_tool    tool;
+	struct record_opts  opts;
+	struct perf_evlist  *evlist;
+	struct perf_session *session;
+
+	const char *file_name;
+	const char *report_event;
+	const char *sort_key;
+	int trace_vcpu;
+
+	struct exit_reasons_table *exit_reasons;
+	const char *exit_reasons_isa;
+
+	struct kvm_events_ops *events_ops;
+	key_cmp_fun compare;
+	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
+
+	u64 total_time;
+	u64 total_count;
+	u64 lost_events;
+	u64 duration;
+
+	const char *pid_str;
+	struct intlist *pid_list;
+
+	struct rb_root result;
+
+	int timerfd;
+	unsigned int display_time;
+	bool live;
+};
+
+struct kvm_reg_events_ops {
+	const char *name;
+	struct kvm_events_ops *ops;
+};
+
+void exit_event_get_key(struct perf_evsel *evsel,
+			struct perf_sample *sample,
+			struct event_key *key);
+bool exit_event_begin(struct perf_evsel *evsel,
+		      struct perf_sample *sample,
+		      struct event_key *key);
+bool exit_event_end(struct perf_evsel *evsel,
+		    struct perf_sample *sample,
+		    struct event_key *key);
+void exit_event_decode_key(struct perf_kvm_stat *kvm,
+			   struct event_key *key,
+			   char *decode);
+
+bool kvm_exit_event(struct perf_evsel *evsel);
+bool kvm_entry_event(struct perf_evsel *evsel);
+
+#define define_exit_reasons_table(name, symbols)	\
+	static struct exit_reasons_table name[] = {	\
+		symbols, { -1, NULL }			\
+	}
+
+/*
+ * arch specific callbacks and data structures
+ */
+int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid);
+
+extern const char * const kvm_events_tp[];
+extern struct kvm_reg_events_ops kvm_reg_events_ops[];
+
+#endif /* __PERF_KVM_STAT_H */
-- 
1.7.9.5

