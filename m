Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaGHAp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:45:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50804 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbaGHApy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:45:54 -0400
From: Laura Abbott <lauraa@codeaurora.org>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@linaro.org>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nicolas Pitre <nico@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] of: Use proper types for checking memory overflow
Date: Mon,  7 Jul 2014 17:45:43 -0700
Message-Id: <1404780343-32188-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a67a6ed15513541579d38bcbd127e7be170710e5
(of: Check for phys_addr_t overflows in early_init_dt_add_memory_arch)
corrected early_init_dt_add_memory_arch to account for overflows
but did so in an unclean way using ULONG_MAX. There is no
guarantee that sizeof(unsigned long) == sizeof(phys_addr_t).
Check against phys_addr_t instead.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 drivers/of/fdt.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index b777d8f..b88a68e 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -875,24 +875,24 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK
+#define MAX_PHYS_ADDR	((phys_addr_t)~0)
+
 void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 {
 	const u64 phys_offset = __pa(PAGE_OFFSET);
 	base &= PAGE_MASK;
 	size &= PAGE_MASK;
 
-	if (sizeof(phys_addr_t) < sizeof(u64)) {
-		if (base > ULONG_MAX) {
-			pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
-					base, base + size);
-			return;
-		}
+	if (base > MAX_PHYS_ADDR) {
+		pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
+				base, base + size);
+		return;
+	}
 
-		if (base + size > ULONG_MAX) {
-			pr_warning("Ignoring memory range 0x%lx - 0x%llx\n",
-					ULONG_MAX, base + size);
-			size = ULONG_MAX - base;
-		}
+	if (base + size > MAX_PHYS_ADDR) {
+		pr_warning("Ignoring memory range 0x%lx - 0x%llx\n",
+				ULONG_MAX, base + size);
+		size = MAX_PHYS_ADDR - base;
 	}
 
 	if (base + size < phys_offset) {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

