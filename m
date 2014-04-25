Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaDYJPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:15:19 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:47896 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaDYJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:12:22 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 07/11] perf kvm: Refactoring of cpu_isa_config()
Date: Fri, 25 Apr 2014 11:12:29 +0200
Message-Id: <1398417153-57347-8-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042509-0542-0000-0000-000008C524A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

cpu_isa_config() does two different things: searching for cpuid and
initializing perf_kvm_stat struct with proper parameters.

Let's move initialization to a separate function cpu_isa_init(), which
is used to initialize all possible ISAs and can be used to init
arch-depended things.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/perf/builtin-kvm.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 9b97737..922706c 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -834,10 +834,26 @@ static int process_sample_event(struct perf_tool *tool,
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
+	} else {
+		pr_err("CPU %s is not supported.\n", cpuid);
+		return -ENOTSUP;
+	}
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
@@ -849,21 +865,12 @@ static int cpu_isa_config(struct perf_kvm_stat *kvm)
 	} else
 		cpuid = kvm->session->header.env.cpuid;
 
-	if (strstr(cpuid, "Intel"))
-		isa = 1;
-	else if (strstr(cpuid, "AMD"))
-		isa = 0;
-	else {
-		pr_err("CPU %s is not supported.\n", cpuid);
-		return -ENOTSUP;
-	}
-
-	if (isa == 1) {
-		kvm->exit_reasons = vmx_exit_reasons;
-		kvm->exit_reasons_isa = "VMX";
+	if (!cpuid) {
+		pr_err("Failed to look up CPU type\n");
+		return -EINVAL;
 	}
 
-	return 0;
+	return cpu_isa_init(kvm, cpuid);
 }
 
 static bool verify_vcpu(int vcpu)
@@ -1582,8 +1589,6 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 		.report_event	= "vmexit",
 		.sort_key	= "sample",
 
-		.exit_reasons = svm_exit_reasons,
-		.exit_reasons_isa = "SVM",
 	};
 
 	if (argc == 1) {
-- 
1.8.4.2

