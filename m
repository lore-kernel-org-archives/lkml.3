Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3IPXJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:09:45 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35514 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3IPXJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:38 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net
Subject: [PATCH 05/28] openrisc: use unflatten_and_copy_device_tree
Date: Mon, 16 Sep 2013 18:09:01 -0500
Message-Id: <1379372965-22359-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Use the common unflatten_and_copy_device_tree to copy the built-in FDT
out of init section. This moves the copy later in the boot, but there
do not appear to be any references to strings in the FDT before the copy.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
---
 arch/openrisc/kernel/prom.c  | 13 -------------
 arch/openrisc/kernel/setup.c |  2 +-
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index bf3fd05..3b94972 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -55,8 +55,6 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 
 void __init early_init_devtree(void *params)
 {
-	void *alloc;
-
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
 
@@ -72,17 +70,6 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
 	memblock_allow_resize();
-
-	/* We must copy the flattend device tree from init memory to regular
-	 * memory because the device tree references the strings in it
-	 * directly.
-	 */
-
-	alloc = __va(memblock_alloc(initial_boot_params->totalsize, PAGE_SIZE));
-
-	memcpy(alloc, initial_boot_params, initial_boot_params->totalsize);
-
-	initial_boot_params = alloc;
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index 719c5c8..09a769b 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -283,7 +283,7 @@ void __init setup_arch(char **cmdline_p)
 {
 	unsigned long max_low_pfn;
 
-	unflatten_device_tree();
+	unflatten_and_copy_device_tree();
 
 	setup_cpuinfo();
 
-- 
1.8.1.2

