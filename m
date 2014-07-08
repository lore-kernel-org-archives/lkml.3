Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaGHTIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:08:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:58166 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbaGHTEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:04:08 -0400
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
Subject: [PATCH 11/16] perf kvm: Refactoring of cpu_isa_config()
Date: Tue,  8 Jul 2014 16:02:59 -0300
Message-Id: <1404846184-20075-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

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
index 75f354459005..41dbeaf8cc11 100644
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
-- 
1.9.3

