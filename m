Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab3IPXJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:09:42 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:58022 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3IPXJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:37 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 04/28] arc: use unflatten_and_copy_device_tree
Date: Mon, 16 Sep 2013 18:09:00 -0500
Message-Id: <1379372965-22359-5-git-send-email-robherring2@gmail.com>
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
Cc: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/mach_desc.h |  1 -
 arch/arc/kernel/devtree.c        | 15 ---------------
 arch/arc/kernel/setup.c          |  3 +--
 3 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arc/include/asm/mach_desc.h b/arch/arc/include/asm/mach_desc.h
index 9998dc8..d3e9c0a 100644
--- a/arch/arc/include/asm/mach_desc.h
+++ b/arch/arc/include/asm/mach_desc.h
@@ -82,6 +82,5 @@ __attribute__((__section__(".arch.info.init"))) = {	\
 };
 
 extern struct machine_desc *setup_machine_fdt(void *dt);
-extern void __init copy_devtree(void);
 
 #endif
diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index 2340af0..eeb613a 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -100,18 +100,3 @@ struct machine_desc * __init setup_machine_fdt(void *dt)
 
 	return mdesc_best;
 }
-
-/*
- * Copy the flattened DT out of .init since unflattening doesn't copy strings
- * and the normal DT APIs refs them from orig flat DT
- */
-void __init copy_devtree(void)
-{
-	void *alloc = early_init_dt_alloc_memory_arch(
-			be32_to_cpu(initial_boot_params->totalsize), 64);
-	if (alloc) {
-		memcpy(alloc, initial_boot_params,
-				be32_to_cpu(initial_boot_params->totalsize));
-		initial_boot_params = alloc;
-	}
-}
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 2c68bc7e..710bf89 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -346,8 +346,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_arch_memory();
 
 	/* copy flat DT out of .init and then unflatten it */
-	copy_devtree();
-	unflatten_device_tree();
+	unflatten_and_copy_device_tree();
 
 	/* Can be issue if someone passes cmd line arg "ro"
 	 * But that is unlikely so keeping it as it is
-- 
1.8.1.2

