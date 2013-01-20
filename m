Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3ATKZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:25:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41428 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab3ATKYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:24:41 -0500
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5/6] powernow-k8: Cleanup module request
Date: Sun, 20 Jan 2013 11:24:29 +0100
Message-Id: <1358677470-17394-6-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358677470-17394-1-git-send-email-bp@alien8.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Check whether we've actually already loaded acpi-cpufreq before
requesting it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/powernow-k8.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 056faf6af1a9..0234d0c6d68c 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1249,6 +1249,24 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
 	.attr		= powernow_k8_attr,
 };
 
+static void __request_acpi_cpufreq(void)
+{
+	const char *cur_drv, *drv = "acpi-cpufreq";
+
+	cur_drv = cpufreq_get_current_driver();
+	if (!cur_drv)
+		goto request;
+
+	if (strncmp(cur_drv, drv, min_t(size_t, strlen(cur_drv), strlen(drv))))
+		pr_warn(PFX "WTF driver: %s\n", cur_drv);
+
+	return;
+
+ request:
+	pr_warn(PFX "This CPU is not supported anymore, using acpi-cpufreq instead.\n");
+	request_module(drv);
+}
+
 /* driver entry point for init */
 static int __cpuinit powernowk8_init(void)
 {
@@ -1256,8 +1274,7 @@ static int __cpuinit powernowk8_init(void)
 	int rv;
 
 	if (static_cpu_has(X86_FEATURE_HW_PSTATE)) {
-		pr_warn(PFX "this CPU is not supported anymore, using acpi-cpufreq instead.\n");
-		request_module("acpi-cpufreq");
+		__request_acpi_cpufreq();
 		return -ENODEV;
 	}
 
-- 
1.8.1.rc3

