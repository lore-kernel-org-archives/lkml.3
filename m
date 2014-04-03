Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaDCWRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:17:51 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:40601 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaDCWRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:31 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 03/20] mips: xlp: copy built-in DTB out of init section
Date: Thu,  3 Apr 2014 17:16:46 -0500
Message-Id: <1396563423-30893-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The existing code is buggy because built-in DTBs are in init memory.
It is also broken because the reserved bootmem was then freed after
unflattening, but the unflattened tree points to data in the flat tree.
Fix this by using the unflatten_and_copy_device_tree function.

This removes all accesses to FDT header data by the arch code.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/netlogic/xlp/dt.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/arch/mips/netlogic/xlp/dt.c b/arch/mips/netlogic/xlp/dt.c
index 5754097..7f9615a 100644
--- a/arch/mips/netlogic/xlp/dt.c
+++ b/arch/mips/netlogic/xlp/dt.c
@@ -87,22 +87,7 @@ void __init xlp_early_init_devtree(void)
 
 void __init device_tree_init(void)
 {
-	unsigned long base, size;
-	struct boot_param_header *fdtp = xlp_fdt_blob;
-
-	if (!fdtp)
-		return;
-
-	base = virt_to_phys(fdtp);
-	size = be32_to_cpu(fdtp->totalsize);
-
-	/* Before we do anything, lets reserve the dt blob */
-	reserve_bootmem(base, size, BOOTMEM_DEFAULT);
-
-	unflatten_device_tree();
-
-	/* free the space reserved for the dt blob */
-	free_bootmem(base, size);
+	unflatten_and_copy_device_tree();
 }
 
 static struct of_device_id __initdata xlp_ids[] = {
-- 
1.8.3.2

