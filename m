Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab3IPXMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:12:45 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:58690 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3IPXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:48 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org
Subject: [PATCH 17/28] xtensa: use early_init_dt_scan
Date: Mon, 16 Sep 2013 18:09:13 -0500
Message-Id: <1379372965-22359-18-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert xtensa to use new early_init_dt_scan function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
---
 arch/xtensa/kernel/setup.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index fc31ec1..65974a8 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -219,9 +219,13 @@ static int __init parse_bootparam(const bp_tag_t* tag)
 }
 
 #ifdef CONFIG_OF
+bool __initdata dt_memory_scan = false;
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
+	if (!dt_memory_scan)
+		return;
+
 	size &= PAGE_MASK;
 	add_sysmem_bank(MEMORY_TYPE_CONVENTIONAL, base, base + size);
 }
@@ -233,20 +237,13 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 
 void __init early_init_devtree(void *params)
 {
-	/* Setup flat device-tree pointer */
-	initial_boot_params = params;
+	if (sysmem.nr_banks == 0)
+		dt_memory_scan = true;
 
-	/* Retrieve various informations from the /chosen node of the
-	 * device-tree, including the platform type, initrd location and
-	 * size, TCE reserve, and more ...
-	 */
-	if (!command_line[0])
-		of_scan_flat_dt(early_init_dt_scan_chosen, command_line);
+	early_init_dt_scan(params);
 
-	/* Scan memory nodes and rebuild MEMBLOCKs */
-	of_scan_flat_dt(early_init_dt_scan_root, NULL);
-	if (sysmem.nr_banks == 0)
-		of_scan_flat_dt(early_init_dt_scan_memory, NULL);
+	if (!command_line[0])
+		strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 }
 
 static int __init xtensa_device_probe(void)
-- 
1.8.1.2

