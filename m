Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaDYJPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:15:12 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:34842 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaDYJMX (ORCPT
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
Subject: [PATCH 06/11] perf kvm: simplify of exit reasons tables definitions
Date: Fri, 25 Apr 2014 11:12:28 +0200
Message-Id: <1398417153-57347-7-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042509-2966-0000-0000-00000B0C5C58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

perf_kvm_stat struct keeps the size of a table of exit reasons in the field
'exit_reasons_size'. The field is initialized and then
used by get_exit_reason() for serial access to the table, so that the
calling function does not actually need to know table size.

Usage of tables with 'end of sequence' marker can simplify
get_exit_reason() function.

Also patch introduces a define_exit_reasons_table, which makes easier to
define new tables.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/perf/builtin-kvm.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 202b9b0..9b97737 100644
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
@@ -861,7 +860,6 @@ static int cpu_isa_config(struct perf_kvm_stat *kvm)
 
 	if (isa == 1) {
 		kvm->exit_reasons = vmx_exit_reasons;
-		kvm->exit_reasons_size = ARRAY_SIZE(vmx_exit_reasons);
 		kvm->exit_reasons_isa = "VMX";
 	}
 
@@ -1585,7 +1583,6 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 		.sort_key	= "sample",
 
 		.exit_reasons = svm_exit_reasons,
-		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
 		.exit_reasons_isa = "SVM",
 	};
 
-- 
1.8.4.2

