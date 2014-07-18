Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbaGREW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:22:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32990 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbaGREWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:22:23 -0400
Date: Thu, 17 Jul 2014 21:21:38 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-44b3802122174ba499613bac3aab2e66e948ce1e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, jolsa@redhat.com, cornelia.huck@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, jolsa@redhat.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1404397747-20939-2-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1404397747-20939-2-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Use defines of kvm events
Git-Commit-ID: 44b3802122174ba499613bac3aab2e66e948ce1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44b3802122174ba499613bac3aab2e66e948ce1e
Gitweb:     http://git.kernel.org/tip/44b3802122174ba499613bac3aab2e66e948ce1e
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Thu, 3 Jul 2014 18:29:04 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:32 -0300

perf kvm: Use defines of kvm events

Currently perf-kvm uses string literals for kvm event names, but it
works only for x86, because other architectures may have other names for
those events.

To reduce dependence on architecture, we add <asm/kvm_perf.h> file with
defines for:

- kvm_entry and kvm_exit events,
- exit reason field name in kvm_exit event,
- length of exit reasons strings,
- vcpu_id field name in kvm trace events,

and replace literals in perf-kvm.

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by David Ahern <dsahern@gmail.com>
Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1404397747-20939-2-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/include/uapi/asm/Kbuild     |  1 +
 arch/x86/include/uapi/asm/kvm_perf.h | 16 ++++++++++++++++
 tools/perf/MANIFEST                  |  1 +
 tools/perf/builtin-kvm.c             | 34 ++++++++++++++++------------------
 4 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/uapi/asm/Kbuild b/arch/x86/include/uapi/asm/Kbuild
index 09409c4..3dec769 100644
--- a/arch/x86/include/uapi/asm/Kbuild
+++ b/arch/x86/include/uapi/asm/Kbuild
@@ -22,6 +22,7 @@ header-y += ipcbuf.h
 header-y += ist.h
 header-y += kvm.h
 header-y += kvm_para.h
+header-y += kvm_perf.h
 header-y += ldt.h
 header-y += mce.h
 header-y += mman.h
diff --git a/arch/x86/include/uapi/asm/kvm_perf.h b/arch/x86/include/uapi/asm/kvm_perf.h
new file mode 100644
index 0000000..3bb964f
--- /dev/null
+++ b/arch/x86/include/uapi/asm/kvm_perf.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_X86_KVM_PERF_H
+#define _ASM_X86_KVM_PERF_H
+
+#include <asm/svm.h>
+#include <asm/vmx.h>
+#include <asm/kvm.h>
+
+#define DECODE_STR_LEN 20
+
+#define VCPU_ID "vcpu_id"
+
+#define KVM_ENTRY_TRACE "kvm:kvm_entry"
+#define KVM_EXIT_TRACE "kvm:kvm_exit"
+#define KVM_EXIT_REASON "exit_reason"
+
+#endif /* _ASM_X86_KVM_PERF_H */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 45da209..02b485d 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -37,3 +37,4 @@ arch/x86/include/asm/kvm_host.h
 arch/x86/include/uapi/asm/svm.h
 arch/x86/include/uapi/asm/vmx.h
 arch/x86/include/uapi/asm/kvm.h
+arch/x86/include/uapi/asm/kvm_perf.h
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 41dbeaf..6d73346 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -30,9 +30,7 @@
 #include <math.h>
 
 #ifdef HAVE_KVM_STAT_SUPPORT
-#include <asm/svm.h>
-#include <asm/vmx.h>
-#include <asm/kvm.h>
+#include <asm/kvm_perf.h>
 
 struct event_key {
 	#define INVALID_KEY     (~0ULL)
@@ -75,7 +73,7 @@ struct kvm_events_ops {
 	bool (*is_end_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample, struct event_key *key);
 	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
-			   char decode[20]);
+			   char *decode);
 	const char *name;
 };
 
@@ -126,12 +124,12 @@ static void exit_event_get_key(struct perf_evsel *evsel,
 			       struct event_key *key)
 {
 	key->info = 0;
-	key->key = perf_evsel__intval(evsel, sample, "exit_reason");
+	key->key = perf_evsel__intval(evsel, sample, KVM_EXIT_REASON);
 }
 
 static bool kvm_exit_event(struct perf_evsel *evsel)
 {
-	return !strcmp(evsel->name, "kvm:kvm_exit");
+	return !strcmp(evsel->name, KVM_EXIT_TRACE);
 }
 
 static bool exit_event_begin(struct perf_evsel *evsel,
@@ -147,7 +145,7 @@ static bool exit_event_begin(struct perf_evsel *evsel,
 
 static bool kvm_entry_event(struct perf_evsel *evsel)
 {
-	return !strcmp(evsel->name, "kvm:kvm_entry");
+	return !strcmp(evsel->name, KVM_ENTRY_TRACE);
 }
 
 static bool exit_event_end(struct perf_evsel *evsel,
@@ -182,12 +180,12 @@ static const char *get_exit_reason(struct perf_kvm_stat *kvm,
 
 static void exit_event_decode_key(struct perf_kvm_stat *kvm,
 				  struct event_key *key,
-				  char decode[20])
+				  char *decode)
 {
 	const char *exit_reason = get_exit_reason(kvm, kvm->exit_reasons,
 						  key->key);
 
-	scnprintf(decode, 20, "%s", exit_reason);
+	scnprintf(decode, DECODE_STR_LEN, "%s", exit_reason);
 }
 
 static struct kvm_events_ops exit_events = {
@@ -249,9 +247,9 @@ static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
 
 static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
 				  struct event_key *key,
-				  char decode[20])
+				  char *decode)
 {
-	scnprintf(decode, 20, "%#lx:%s", (unsigned long)key->key,
+	scnprintf(decode, DECODE_STR_LEN, "%#lx:%s", (unsigned long)key->key,
 				key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
 }
 
@@ -292,9 +290,9 @@ static bool ioport_event_end(struct perf_evsel *evsel,
 
 static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
 				    struct event_key *key,
-				    char decode[20])
+				    char *decode)
 {
-	scnprintf(decode, 20, "%#llx:%s", (unsigned long long)key->key,
+	scnprintf(decode, DECODE_STR_LEN, "%#llx:%s", (unsigned long long)key->key,
 				key->info ? "POUT" : "PIN");
 }
 
@@ -524,7 +522,7 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
 	time_diff = sample->time - time_begin;
 
 	if (kvm->duration && time_diff > kvm->duration) {
-		char decode[32];
+		char decode[DECODE_STR_LEN];
 
 		kvm->events_ops->decode_key(kvm, &event->key, decode);
 		if (strcmp(decode, "HLT")) {
@@ -552,7 +550,7 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 			return NULL;
 		}
 
-		vcpu_record->vcpu_id = perf_evsel__intval(evsel, sample, "vcpu_id");
+		vcpu_record->vcpu_id = perf_evsel__intval(evsel, sample, VCPU_ID);
 		thread->priv = vcpu_record;
 	}
 
@@ -739,7 +737,7 @@ static void show_timeofday(void)
 
 static void print_result(struct perf_kvm_stat *kvm)
 {
-	char decode[20];
+	char decode[DECODE_STR_LEN];
 	struct kvm_event *event;
 	int vcpu = kvm->trace_vcpu;
 
@@ -750,7 +748,7 @@ static void print_result(struct perf_kvm_stat *kvm)
 
 	pr_info("\n\n");
 	print_vcpu_info(kvm);
-	pr_info("%20s ", kvm->events_ops->name);
+	pr_info("%*s ", DECODE_STR_LEN, kvm->events_ops->name);
 	pr_info("%10s ", "Samples");
 	pr_info("%9s ", "Samples%");
 
@@ -769,7 +767,7 @@ static void print_result(struct perf_kvm_stat *kvm)
 		min = get_event_min(event, vcpu);
 
 		kvm->events_ops->decode_key(kvm, &event->key, decode);
-		pr_info("%20s ", decode);
+		pr_info("%*s ", DECODE_STR_LEN, decode);
 		pr_info("%10llu ", (unsigned long long)ecount);
 		pr_info("%8.2f%% ", (double)ecount / kvm->total_count * 100);
 		pr_info("%8.2f%% ", (double)etime / kvm->total_time * 100);
