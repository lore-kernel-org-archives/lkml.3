Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3ATKZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:25:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41427 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab3ATKYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:24:41 -0500
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 6/6] powernow-k8: Cleanup init function
Date: Sun, 20 Jan 2013 11:24:30 +0100
Message-Id: <1358677470-17394-7-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358677470-17394-1-git-send-email-bp@alien8.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Make it hotplug-safe and cleanup formatting.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/powernow-k8.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 0234d0c6d68c..d13a13678b5f 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1271,7 +1271,7 @@ static void __request_acpi_cpufreq(void)
 static int __cpuinit powernowk8_init(void)
 {
 	unsigned int i, supported_cpus = 0;
-	int rv;
+	int ret;
 
 	if (static_cpu_has(X86_FEATURE_HW_PSTATE)) {
 		__request_acpi_cpufreq();
@@ -1281,24 +1281,27 @@ static int __cpuinit powernowk8_init(void)
 	if (!x86_match_cpu(powernow_k8_ids))
 		return -ENODEV;
 
+	get_online_cpus();
 	for_each_online_cpu(i) {
-		int rc;
-		smp_call_function_single(i, check_supported_cpu, &rc, 1);
-		if (rc == 0)
+		smp_call_function_single(i, check_supported_cpu, &ret, 1);
+		if (!ret)
 			supported_cpus++;
 	}
 
-	if (supported_cpus != num_online_cpus())
+	if (supported_cpus != num_online_cpus()) {
+		put_online_cpus();
 		return -ENODEV;
+	}
+	put_online_cpus();
 
-	rv = cpufreq_register_driver(&cpufreq_amd64_driver);
+	ret = cpufreq_register_driver(&cpufreq_amd64_driver);
+	if (ret)
+		return ret;
 
-	if (!rv)
-		pr_info(PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
-			num_online_nodes(), boot_cpu_data.x86_model_id,
-			supported_cpus);
+	pr_info(PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
+		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
 
-	return rv;
+	return ret;
 }
 
 /* driver entry point for term */
-- 
1.8.1.rc3

