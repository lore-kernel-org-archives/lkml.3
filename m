Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965762AbaGPTQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:16:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965647AbaGPTQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:16:33 -0400
Date: Wed, 16 Jul 2014 12:16:11 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-df74c13b6c53c97576652f7b2840764ad7d5f949@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, jolsa@redhat.com, cornelia.huck@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, jolsa@redhat.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1404395992-17095-3-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1404395992-17095-3-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm:
  Simplify exit reasons tables definitions
Git-Commit-ID: df74c13b6c53c97576652f7b2840764ad7d5f949
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

Commit-ID:  df74c13b6c53c97576652f7b2840764ad7d5f949
Gitweb:     http://git.kernel.org/tip/df74c13b6c53c97576652f7b2840764ad7d5f949
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Thu, 3 Jul 2014 17:59:50 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 16:55:24 -0300

perf kvm: Simplify exit reasons tables definitions

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
index 214ec0e..75f3544 100644
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
 
