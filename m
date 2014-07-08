Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaGHTEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:04:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:58148 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbaGHTEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:04:04 -0400
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
Subject: [PATCH 10/16] perf kvm: Simplify exit reasons tables definitions
Date: Tue,  8 Jul 2014 16:02:58 -0300
Message-Id: <1404846184-20075-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

The perf_kvm_stat struct keeps the size of a table of exit reasons in
the field 'exit_reasons_size'.

The field is initialized and then used by get_exit_reason() for serial
access to the table, so that the calling function does not actually need
to know table size.

Usage of tables with 'end of sequence' marker simplifies the
get_exit_reason() function.

Also the patch introduces a define_exit_reasons_table, which makes it
easier to define new tables.

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1404395992-17095-3-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 214ec0e7492b..75f354459005 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -99,7 +99,6 @@ struct perf_kvm_stat {
 	int trace_vcpu;
 
 	struct exit_reasons_table *exit_reasons;
-	int exit_reasons_size;
 	const char *exit_reasons_isa;
 
 	struct kvm_events_ops *events_ops;
@@ -158,20 +157,19 @@ static bool exit_event_end(struct perf_evsel *evsel,
 	return kvm_entry_event(evsel);
 }
 
-static struct exit_reasons_table vmx_exit_reasons[] = {
-	VMX_EXIT_REASONS
-};
+#define define_exit_reasons_table(name, symbols)	\
+	static struct exit_reasons_table name[] = {	\
+		symbols, { -1, NULL }			\
+	}
 
-static struct exit_reasons_table svm_exit_reasons[] = {
-	SVM_EXIT_REASONS
-};
+define_exit_reasons_table(vmx_exit_reasons, VMX_EXIT_REASONS);
+define_exit_reasons_table(svm_exit_reasons, SVM_EXIT_REASONS);
 
-static const char *get_exit_reason(struct perf_kvm_stat *kvm, u64 exit_code)
+static const char *get_exit_reason(struct perf_kvm_stat *kvm,
+				   struct exit_reasons_table *tbl,
+				   u64 exit_code)
 {
-	int i = kvm->exit_reasons_size;
-	struct exit_reasons_table *tbl = kvm->exit_reasons;
-
-	while (i--) {
+	while (tbl->reason != NULL) {
 		if (tbl->exit_code == exit_code)
 			return tbl->reason;
 		tbl++;
@@ -186,7 +184,8 @@ static void exit_event_decode_key(struct perf_kvm_stat *kvm,
 				  struct event_key *key,
 				  char decode[20])
 {
-	const char *exit_reason = get_exit_reason(kvm, key->key);
+	const char *exit_reason = get_exit_reason(kvm, kvm->exit_reasons,
+						  key->key);
 
 	scnprintf(decode, 20, "%s", exit_reason);
 }
@@ -862,7 +861,6 @@ static int cpu_isa_config(struct perf_kvm_stat *kvm)
 
 	if (isa == 1) {
 		kvm->exit_reasons = vmx_exit_reasons;
-		kvm->exit_reasons_size = ARRAY_SIZE(vmx_exit_reasons);
 		kvm->exit_reasons_isa = "VMX";
 	}
 
@@ -1586,7 +1584,6 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 		.sort_key	= "sample",
 
 		.exit_reasons = svm_exit_reasons,
-		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
 		.exit_reasons_isa = "SVM",
 	};
 
-- 
1.9.3

