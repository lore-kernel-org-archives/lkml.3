Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab3IPXPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:15:23 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41193 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3IPXJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:39 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 06/28] x86: use unflatten_and_copy_device_tree
Date: Mon, 16 Sep 2013 18:09:02 -0500
Message-Id: <1379372965-22359-7-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Use the common unflatten_and_copy_device_tree to copy the built-in FDT
out of init section.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/devicetree.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 376dc78..0db805c 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -230,7 +230,7 @@ static void __init dtb_apic_setup(void)
 static void __init x86_flattree_get_config(void)
 {
 	u32 size, map_len;
-	void *new_dtb;
+	struct boot_param_header *dt;
 
 	if (!initial_dtb)
 		return;
@@ -238,24 +238,17 @@ static void __init x86_flattree_get_config(void)
 	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK),
 			(u64)sizeof(struct boot_param_header));
 
-	initial_boot_params = early_memremap(initial_dtb, map_len);
-	size = be32_to_cpu(initial_boot_params->totalsize);
+	dt = early_memremap(initial_dtb, map_len);
+	size = be32_to_cpu(dt->totalsize);
 	if (map_len < size) {
-		early_iounmap(initial_boot_params, map_len);
-		initial_boot_params = early_memremap(initial_dtb, size);
+		early_iounmap(dt, map_len);
+		dt = early_memremap(initial_dtb, size);
 		map_len = size;
 	}
 
-	new_dtb = alloc_bootmem(size);
-	memcpy(new_dtb, initial_boot_params, size);
-	early_iounmap(initial_boot_params, map_len);
-
-	initial_boot_params = new_dtb;
-
-	/* root level address cells */
-	of_scan_flat_dt(early_init_dt_scan_root, NULL);
-
-	unflatten_device_tree();
+	initial_boot_params = dt;
+	unflatten_and_copy_device_tree();
+	early_iounmap(dt, map_len);
 }
 #else
 static inline void x86_flattree_get_config(void) { }
-- 
1.8.1.2

