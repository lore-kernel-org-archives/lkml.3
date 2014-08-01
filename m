Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaHACma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:42:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25195 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaHACm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:42:29 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Russell King <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] ARM: l2x0: fix build warning without CONFIG_OF
Date: Fri, 1 Aug 2014 10:42:00 +0800
Message-ID: <1406860920-23520-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cf9ea8f13(ARM: l2c: remove obsolete l2x0 ops for non-OF init)
remove some obsolete l2x0 ops, the rest of ops: l2x0_cache_sync,
l2x0_cache_sync, l2x0_disable only use under OF enable, so move them
into OF part, or "defined but not used" warning occurs.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 arch/arm/mm/cache-l2x0.c | 134 +++++++++++++++++++++++------------------------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 7c3fb41..77e57b0 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -135,73 +135,6 @@ static void l2c_disable(void)
 	dsb(st);
 }
 
-#ifdef CONFIG_CACHE_PL310
-static inline void cache_wait(void __iomem *reg, unsigned long mask)
-{
-	/* cache operations by line are atomic on PL310 */
-}
-#else
-#define cache_wait	l2c_wait_mask
-#endif
-
-static inline void cache_sync(void)
-{
-	void __iomem *base = l2x0_base;
-
-	writel_relaxed(0, base + sync_reg_offset);
-	cache_wait(base + L2X0_CACHE_SYNC, 1);
-}
-
-#if defined(CONFIG_PL310_ERRATA_588369) || defined(CONFIG_PL310_ERRATA_727915)
-static inline void debug_writel(unsigned long val)
-{
-	l2c_set_debug(l2x0_base, val);
-}
-#else
-/* Optimised out for non-errata case */
-static inline void debug_writel(unsigned long val)
-{
-}
-#endif
-
-static void l2x0_cache_sync(void)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&l2x0_lock, flags);
-	cache_sync();
-	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
-}
-
-static void __l2x0_flush_all(void)
-{
-	debug_writel(0x03);
-	__l2c_op_way(l2x0_base + L2X0_CLEAN_INV_WAY);
-	cache_sync();
-	debug_writel(0x00);
-}
-
-static void l2x0_flush_all(void)
-{
-	unsigned long flags;
-
-	/* clean all ways */
-	raw_spin_lock_irqsave(&l2x0_lock, flags);
-	__l2x0_flush_all();
-	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
-}
-
-static void l2x0_disable(void)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&l2x0_lock, flags);
-	__l2x0_flush_all();
-	l2c_write_sec(0, l2x0_base, L2X0_CTRL);
-	dsb(st);
-	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
-}
-
 static void l2c_save(void __iomem *base)
 {
 	l2x0_saved_regs.aux_ctrl = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
@@ -945,6 +878,73 @@ static int l2_wt_override;
  * pass it though the device tree */
 static u32 cache_id_part_number_from_dt;
 
+#ifdef CONFIG_CACHE_PL310
+static inline void cache_wait(void __iomem *reg, unsigned long mask)
+{
+	/* cache operations by line are atomic on PL310 */
+}
+#else
+#define cache_wait	l2c_wait_mask
+#endif
+
+static inline void cache_sync(void)
+{
+	void __iomem *base = l2x0_base;
+
+	writel_relaxed(0, base + sync_reg_offset);
+	cache_wait(base + L2X0_CACHE_SYNC, 1);
+}
+
+#if defined(CONFIG_PL310_ERRATA_588369) || defined(CONFIG_PL310_ERRATA_727915)
+static inline void debug_writel(unsigned long val)
+{
+	l2c_set_debug(l2x0_base, val);
+}
+#else
+/* Optimised out for non-errata case */
+static inline void debug_writel(unsigned long val)
+{
+}
+#endif
+
+static void l2x0_cache_sync(void)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
+	cache_sync();
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
+}
+
+static void __l2x0_flush_all(void)
+{
+	debug_writel(0x03);
+	__l2c_op_way(l2x0_base + L2X0_CLEAN_INV_WAY);
+	cache_sync();
+	debug_writel(0x00);
+}
+
+static void l2x0_flush_all(void)
+{
+	unsigned long flags;
+
+	/* clean all ways */
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
+	__l2x0_flush_all();
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
+}
+
+static void l2x0_disable(void)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
+	__l2x0_flush_all();
+	l2c_write_sec(0, l2x0_base, L2X0_CTRL);
+	dsb(st);
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
+}
+
 static void __init l2x0_of_parse(const struct device_node *np,
 				 u32 *aux_val, u32 *aux_mask)
 {
-- 
1.7.12.4


