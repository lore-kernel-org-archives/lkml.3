Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965800AbaGPTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:16:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965764AbaGPTQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:16:55 -0400
Date: Wed, 16 Jul 2014 12:16:26 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-65c647a65c155e69bd5765d5e454982566ac1c62@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, jolsa@redhat.com, cornelia.huck@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, jolsa@redhat.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1404395992-17095-4-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1404395992-17095-4-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Refactoring of cpu_isa_config()
Git-Commit-ID: 65c647a65c155e69bd5765d5e454982566ac1c62
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

Commit-ID:  65c647a65c155e69bd5765d5e454982566ac1c62
Gitweb:     http://git.kernel.org/tip/65c647a65c155e69bd5765d5e454982566ac1c62
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Thu, 3 Jul 2014 17:59:51 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 16:55:24 -0300

perf kvm: Refactoring of cpu_isa_config()

cpu_isa_config() does two different things: searching for cpuid and
initializing perf_kvm_stat struct with proper parameters.

Let's move initialization to a separate function cpu_isa_init(), which
is used to initialize all possible ISAs and can be used to init
arch-depended things.

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
Link: http://lkml.kernel.org/r/1404395992-17095-4-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 75f3544..41dbeaf 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -835,36 +835,45 @@ static int process_sample_event(struct perf_tool *tool,
 	return 0;
 }
 
+static int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
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
+
 static int cpu_isa_config(struct perf_kvm_stat *kvm)
 {
 	char buf[64], *cpuid;
-	int err, isa;
+	int err;
 
 	if (kvm->live) {
 		err = get_cpuid(buf, sizeof(buf));
 		if (err != 0) {
-			pr_err("Failed to look up CPU type (Intel or AMD)\n");
+			pr_err("Failed to look up CPU type\n");
 			return err;
 		}
 		cpuid = buf;
 	} else
 		cpuid = kvm->session->header.env.cpuid;
 
-	if (strstr(cpuid, "Intel"))
-		isa = 1;
-	else if (strstr(cpuid, "AMD"))
-		isa = 0;
-	else {
-		pr_err("CPU %s is not supported.\n", cpuid);
-		return -ENOTSUP;
+	if (!cpuid) {
+		pr_err("Failed to look up CPU type\n");
+		return -EINVAL;
 	}
 
-	if (isa == 1) {
-		kvm->exit_reasons = vmx_exit_reasons;
-		kvm->exit_reasons_isa = "VMX";
-	}
+	err = cpu_isa_init(kvm, cpuid);
+	if (err == -ENOTSUP)
+		pr_err("CPU %s is not supported.\n", cpuid);
 
-	return 0;
+	return err;
 }
 
 static bool verify_vcpu(int vcpu)
@@ -1583,8 +1592,6 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 		.report_event	= "vmexit",
 		.sort_key	= "sample",
 
-		.exit_reasons = svm_exit_reasons,
-		.exit_reasons_isa = "SVM",
 	};
 
 	if (argc == 1) {
