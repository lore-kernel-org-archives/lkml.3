Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaHTPKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:10:40 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:38349 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaHTPKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:10:38 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] of: Fix memory block alignment in early_init_dt_add_memory_arch()
Date: Wed, 20 Aug 2014 17:10:31 +0200
Message-Id: <1408547431-24001-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a memory block is not aligned to PAGE_SIZE, its base address must be
rounded up, not down, and its size must be reduced.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/of/fdt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index f46a24ffa3fe..95fa81b8ca19 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -928,7 +928,11 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 {
 	const u64 phys_offset = __pa(PAGE_OFFSET);
-	base &= PAGE_MASK;
+
+	if (!PAGE_ALIGNED(base)) {
+		size -= PAGE_SIZE - (base & ~PAGE_MASK);
+		base = PAGE_ALIGN(base);
+	}
 	size &= PAGE_MASK;
 
 	if (base > MAX_PHYS_ADDR) {
-- 
1.9.1

