Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144Ab3DBNW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:22:28 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46554 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761061Ab3DBNWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:22:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 8/9] mfd: db8500-prcmu: Return early if the TCPM cannot be located
Date: Tue,  2 Apr 2013 14:21:55 +0100
Message-Id: <1364908916-29803-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we check to see if we obtained the Tightly Coupled Program
Memory (TCPM) base and only execute the code within the check if we
have it. It's more traditional to return early if we don't have it.
This way we can flatten most of the function's code down to a single
tab spacing.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 21f261b..1c4edbf8 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2794,6 +2794,7 @@ static void dbx500_fw_version_init(struct platform_device *pdev,
 {
 	struct resource *res;
 	void __iomem *tcpm_base;
+	u32 version;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 					   "prcmu-tcpm");
@@ -2803,26 +2804,27 @@ static void dbx500_fw_version_init(struct platform_device *pdev,
 		return;
 	}
 	tcpm_base = ioremap(res->start, resource_size(res));
-	if (tcpm_base != NULL) {
-		u32 version;
-
-		version = readl(tcpm_base + version_offset);
-		fw_info.version.project = (version & 0xFF);
-		fw_info.version.api_version = (version >> 8) & 0xFF;
-		fw_info.version.func_version = (version >> 16) & 0xFF;
-		fw_info.version.errata = (version >> 24) & 0xFF;
-		strncpy(fw_info.version.project_name,
-			fw_project_name(fw_info.version.project),
-			PRCMU_FW_PROJECT_NAME_LEN);
-		fw_info.valid = true;
-		pr_info("PRCMU firmware: %s(%d), version %d.%d.%d\n",
-			fw_info.version.project_name,
-			fw_info.version.project,
-			fw_info.version.api_version,
-			fw_info.version.func_version,
-			fw_info.version.errata);
-		iounmap(tcpm_base);
+	if (!tcpm_base) {
+		dev_err(&pdev->dev, "no prcmu tcpm mem region provided\n");
+		return;
 	}
+
+	version = readl(tcpm_base + version_offset);
+	fw_info.version.project = (version & 0xFF);
+	fw_info.version.api_version = (version >> 8) & 0xFF;
+	fw_info.version.func_version = (version >> 16) & 0xFF;
+	fw_info.version.errata = (version >> 24) & 0xFF;
+	strncpy(fw_info.version.project_name,
+		fw_project_name(fw_info.version.project),
+		PRCMU_FW_PROJECT_NAME_LEN);
+	fw_info.valid = true;
+	pr_info("PRCMU firmware: %s(%d), version %d.%d.%d\n",
+		fw_info.version.project_name,
+		fw_info.version.project,
+		fw_info.version.api_version,
+		fw_info.version.func_version,
+		fw_info.version.errata);
+	iounmap(tcpm_base);
 }
 
 void __init db8500_prcmu_early_init(void)
-- 
1.7.10.4

