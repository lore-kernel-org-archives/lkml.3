Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348Ab3D3SjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:39:21 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4845 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760824Ab3D3SjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:39:18 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Christian Daudt" <csd@broadcom.com>
To: "Russell King" <linux@arm.linux.org.uk>,
        "John Stultz" <johnstul@us.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Olof Johansson" <olof@lixom.net>, "Arnd Bergmann" <arnd@arndb.de>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Will Deacon" <will.deacon@arm.com>
cc: "Christian Daudt" <csd@broadcom.com>, "arm@kernel.org" <arm@kernel.org>,
        linux-arm-kernel@lists.infradead.org, csd_b@daudt.org,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Rob Landley" <rob@landley.net>,
        "Josh Cartwright" <josh.cartwright@ni.com>,
        "Yehuda Yitschak" <yehuday@marvell.com>,
        "Gregory CLEMENT" <gregory.clement@free-electrons.com>,
        "John Stultz" <john.stultz@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: bcm281xx: Add L2 support for Rev A2 chips
Date: Tue, 30 Apr 2013 11:38:09 -0700
Message-ID: <1367347089-23788-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7D9ED17031W13071248-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rev A2 SoCs have an unorthodox memory re-mapping and this needs
to be reflected in the cache operations.
This patch adds new outer cache functions for the l2x0 driver
to support this SoC revision. It also adds a new compatible
value for the cache to enable this functionality.

Signed-off-by: Christian Daudt <csd@broadcom.com>

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index cbef09b..69ddf9f 100644
--- a/Documentation/devicetree/bindings/arm/l2cc.txt
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -16,6 +16,9 @@ Required properties:
      performs the same operation).
 	"marvell,"aurora-outer-cache: Marvell Controller designed to be
 	 compatible with the ARM one with outer cache mode.
+	"bcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
+	offset needs to be added to the address before passing down to the L2
+	cache controller
 - cache-unified : Specifies the cache is a unified cache.
 - cache-level : Should be set to 2 for a level 2 cache.
 - reg : Physical base address and size of cache controller's memory mapped
diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 41b2c6c..5e48c85 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -47,10 +47,10 @@
 	};
 
 	L2: l2-cache {
-		    compatible = "arm,pl310-cache";
-		    reg = <0x3ff20000 0x1000>;
-		    cache-unified;
-		    cache-level = <2>;
+		compatible = "bcm,bcm11351-a2-pl310-cache";
+		reg = <0x3ff20000 0x1000>;
+		cache-unified;
+		cache-level = <2>;
 	};
 
 	timer@35006000 {
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index c465fac..6edba13 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -523,6 +523,162 @@ static void aurora_flush_range(unsigned long start, unsigned long end)
 	}
 }
 
+/*
+ * For certain Broadcom SoCs, depending on the address range, different offsets
+ * need to be added to the address before passing it to L2 for
+ * invalidation/clean/flush
+ *
+ * Section Address Range              Offset        EMI
+ *   1     0x00000000 - 0x3FFFFFFF    0x80000000    VC
+ *   2     0x40000000 - 0xBFFFFFFF    0x40000000    SYS
+ *   3     0xC0000000 - 0xFFFFFFFF    0x80000000    VC
+ *
+ * When the start and end addresses have crossed two different sections, we
+ * need to break the L2 operation into two, each within its own section.
+ * For example, if we need to invalidate addresses starts at 0xBFFF0000 and
+ * ends at 0xC0001000, we need do invalidate 1) 0xBFFF0000 - 0xBFFFFFFF and 2)
+ * 0xC0000000 - 0xC0001000
+ *
+ * Note 1:
+ * By breaking a single L2 operation into two, we may potentially suffer some
+ * performance hit, but keep in mind the cross section case is very rare
+ *
+ * Note 2:
+ * We do not need to handle the case when the start address is in
+ * Section 1 and the end address is in Section 3, since it is not a valid use
+ * case
+ */
+
+#define BCM_VC_EMI_SEC1_START_ADDR    0x00000000UL
+#define BCM_VC_EMI_SEC1_END_ADDR      0x3FFFFFFFUL
+#define BCM_SYS_EMI_START_ADDR        0x40000000UL
+#define BCM_SYS_EMI_END_ADDR          0xBFFFFFFFUL
+#define BCM_VC_EMI_SEC3_START_ADDR    0xC0000000UL
+#define BCM_VC_EMI_SEC3_END_ADDR      0xFFFFFFFFUL
+
+#define BCM_SYS_EMI_OFFSET            0x40000000UL
+#define BCM_VC_EMI_OFFSET             0x80000000UL
+
+static inline int bcm_addr_is_sys_emi(unsigned long addr)
+{
+	return (addr >= BCM_SYS_EMI_START_ADDR) &&
+		(addr <= BCM_SYS_EMI_END_ADDR);
+}
+
+static inline unsigned long bcm_l2_phys_addr(unsigned long addr)
+{
+	if (bcm_addr_is_sys_emi(addr))
+		return addr + BCM_SYS_EMI_OFFSET;
+	else
+		return addr + BCM_VC_EMI_OFFSET;
+}
+
+static void bcm_inv_range(unsigned long start, unsigned long end)
+{
+	unsigned long new_start, new_end;
+
+	if (unlikely(end <= start))
+		return;
+
+	new_start = bcm_l2_phys_addr(start);
+	new_end = bcm_l2_phys_addr(end);
+
+	/* normal case, no cross section between start and end */
+	if (likely((bcm_addr_is_sys_emi(start) && bcm_addr_is_sys_emi(end)) ||
+		(!bcm_addr_is_sys_emi(start) && !bcm_addr_is_sys_emi(end)))) {
+		l2x0_inv_range(new_start, new_end);
+		return;
+	}
+
+	if (bcm_addr_is_sys_emi(start)) {
+		/* start address in Section 2. end address in Section 3 */
+		l2x0_inv_range(new_start,
+				bcm_l2_phys_addr(BCM_SYS_EMI_END_ADDR));
+		l2x0_inv_range(bcm_l2_phys_addr(BCM_VC_EMI_SEC3_START_ADDR),
+				new_end);
+	} else {
+		/* start address in Section 1. end address in Section 2 */
+		l2x0_inv_range(new_start,
+				bcm_l2_phys_addr(BCM_VC_EMI_SEC1_END_ADDR));
+		l2x0_inv_range(bcm_l2_phys_addr(BCM_SYS_EMI_START_ADDR),
+				new_end);
+	}
+}
+
+static void bcm_clean_range(unsigned long start, unsigned long end)
+{
+	unsigned long new_start, new_end;
+
+	if (unlikely(end <= start))
+		return;
+
+	if ((end - start) >= l2x0_size) {
+		l2x0_clean_all();
+		return;
+	}
+
+	new_start = bcm_l2_phys_addr(start);
+	new_end = bcm_l2_phys_addr(end);
+
+	/* normal case, no cross section between start and end */
+	if (likely((bcm_addr_is_sys_emi(start) && bcm_addr_is_sys_emi(end)) ||
+		(!bcm_addr_is_sys_emi(start) && !bcm_addr_is_sys_emi(end)))) {
+		l2x0_clean_range(new_start, new_end);
+		return;
+	}
+
+	if (bcm_addr_is_sys_emi(start)) {
+		/* start address in Section 2. end address in Section 3 */
+		l2x0_clean_range(new_start,
+				bcm_l2_phys_addr(BCM_SYS_EMI_END_ADDR));
+		l2x0_clean_range(bcm_l2_phys_addr(BCM_VC_EMI_SEC3_START_ADDR),
+				new_end);
+	} else {
+		/* start address in Section 1. end address in Section 2 */
+		l2x0_clean_range(new_start,
+				bcm_l2_phys_addr(BCM_VC_EMI_SEC1_END_ADDR));
+		l2x0_clean_range(bcm_l2_phys_addr(BCM_SYS_EMI_START_ADDR),
+				new_end);
+	}
+}
+
+static void bcm_flush_range(unsigned long start, unsigned long end)
+{
+	unsigned long new_start, new_end;
+
+	if (unlikely(end <= start))
+		return;
+
+	if ((end - start) >= l2x0_size) {
+		l2x0_flush_all();
+		return;
+	}
+
+	new_start = bcm_l2_phys_addr(start);
+	new_end = bcm_l2_phys_addr(end);
+
+	/* normal case, no cross section between start and end */
+	if (likely((bcm_addr_is_sys_emi(start) && bcm_addr_is_sys_emi(end)) ||
+		(!bcm_addr_is_sys_emi(start) && !bcm_addr_is_sys_emi(end)))) {
+		l2x0_flush_range(new_start, new_end);
+		return;
+	}
+
+	if (bcm_addr_is_sys_emi(start)) {
+		/* start address in Section 2. end address in Section 3 */
+		l2x0_flush_range(new_start,
+				bcm_l2_phys_addr(BCM_SYS_EMI_END_ADDR));
+		l2x0_flush_range(bcm_l2_phys_addr(BCM_VC_EMI_SEC3_START_ADDR),
+				new_end);
+	} else {
+		/* start address in Section 1. end address in Section 2 */
+		l2x0_flush_range(new_start,
+				bcm_l2_phys_addr(BCM_VC_EMI_SEC1_END_ADDR));
+		l2x0_flush_range(bcm_l2_phys_addr(BCM_SYS_EMI_START_ADDR),
+				new_end);
+	}
+}
+
 static void __init l2x0_of_setup(const struct device_node *np,
 				 u32 *aux_val, u32 *aux_mask)
 {
@@ -765,6 +921,21 @@ static const struct l2x0_of_data aurora_no_outer_data = {
 	},
 };
 
+static const struct l2x0_of_data bcm_l2x0_data = {
+	.setup = pl310_of_setup,
+	.save  = pl310_save,
+	.outer_cache = {
+		.resume      = pl310_resume,
+		.inv_range   = bcm_inv_range,
+		.clean_range = bcm_clean_range,
+		.flush_range = bcm_flush_range,
+		.sync        = l2x0_cache_sync,
+		.flush_all   = l2x0_flush_all,
+		.inv_all     = l2x0_inv_all,
+		.disable     = l2x0_disable,
+	},
+};
+
 static const struct of_device_id l2x0_ids[] __initconst = {
 	{ .compatible = "arm,pl310-cache", .data = (void *)&pl310_data },
 	{ .compatible = "arm,l220-cache", .data = (void *)&l2x0_data },
@@ -773,6 +944,8 @@ static const struct of_device_id l2x0_ids[] __initconst = {
 	  .data = (void *)&aurora_no_outer_data},
 	{ .compatible = "marvell,aurora-outer-cache",
 	  .data = (void *)&aurora_with_outer_data},
+	{ .compatible = "bcm,bcm11351-a2-pl310-cache",
+	  .data = (void *)&bcm_l2x0_data},
 	{}
 };
 
-- 
1.7.10.4


