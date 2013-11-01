Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3KAWJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:09:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48600 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab3KAWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:09:05 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 08/11] ARM: msm: Add SMP support for KPSSv1
Date: Fri,  1 Nov 2013 15:08:56 -0700
Message-Id: <1383343739-23080-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

Implement support for the Krait CPU release sequence when the
CPUs are part of the first version of the krait processor
subsystem.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/platsmp.c  | 56 ++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/scm-boot.h |  8 ++++---
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 369d8f7..e187c6e 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -17,6 +17,7 @@
 #include <linux/of_address.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/sizes.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
@@ -30,6 +31,10 @@
 #define SCSS_CPU1CORE_RESET		0x2d80
 #define SCSS_DBG_STATUS_CORE_PWRDUP	0x2e64
 
+#define APCS_CPU_PWR_CTL	0x04
+
+#define APCS_SAW2_VCTL		0x14
+
 extern void secondary_startup(void);
 
 static DEFINE_SPINLOCK(boot_lock);
@@ -66,6 +71,54 @@ static int scss_release_secondary(struct device_node *node, unsigned int cpu)
 	return 0;
 }
 
+static int kpssv1_release_secondary(struct device_node *node, unsigned int cpu)
+{
+	u32 off;
+	struct resource res;
+	void __iomem *reg;
+
+	if (of_property_read_u32(node, "cpu-offset", &off))
+		return -EINVAL;
+
+	if (of_address_to_resource(node, 0, &res))
+		return -EINVAL;
+
+	/* The SAW base is always next to the ACC base so just map both */
+	reg = ioremap(res.start + off + (SZ_64K * cpu),
+			resource_size(&res) + SZ_4K);
+	if (!reg)
+		return -ENOMEM;
+
+	/* Turn on CPU rail */
+	writel_relaxed(0xA4, reg + SZ_4K + APCS_SAW2_VCTL);
+	mb();
+	udelay(512);
+
+	/* Krait bring-up sequence */
+	writel_relaxed(0x109, reg + APCS_CPU_PWR_CTL);
+	writel_relaxed(0x101, reg + APCS_CPU_PWR_CTL);
+	mb();
+	ndelay(300);
+
+	writel_relaxed(0x121, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(2);
+
+	writel_relaxed(0x120, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(2);
+
+	writel_relaxed(0x100, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(100);
+
+	writel_relaxed(0x180, reg + APCS_CPU_PWR_CTL);
+	mb();
+
+	iounmap(reg);
+	return 0;
+}
+
 static DEFINE_PER_CPU(int, cold_boot_done);
 
 static int boot_cold_cpu(unsigned int cpu)
@@ -77,6 +130,7 @@ static int boot_cold_cpu(unsigned int cpu)
 #define M(c, f) { .compatible = c, .data = f }
 	static const struct of_device_id match_table[] = {
 		M("qcom,gcc-8660", scss_release_secondary),
+		M("qcom,kpss-acc-v1", kpssv1_release_secondary),
 	};
 #undef M
 
@@ -155,6 +209,8 @@ static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 	static const int cold_boot_flags[] = {
 		0,
 		SCM_FLAG_COLDBOOT_CPU1,
+		SCM_FLAG_COLDBOOT_CPU2,
+		SCM_FLAG_COLDBOOT_CPU3,
 	};
 
 	for_each_present_cpu(cpu) {
diff --git a/arch/arm/mach-msm/scm-boot.h b/arch/arm/mach-msm/scm-boot.h
index 7be32ff..6aabb24 100644
--- a/arch/arm/mach-msm/scm-boot.h
+++ b/arch/arm/mach-msm/scm-boot.h
@@ -13,9 +13,11 @@
 #define __MACH_SCM_BOOT_H
 
 #define SCM_BOOT_ADDR			0x1
-#define SCM_FLAG_COLDBOOT_CPU1		0x1
-#define SCM_FLAG_WARMBOOT_CPU1		0x2
-#define SCM_FLAG_WARMBOOT_CPU0		0x4
+#define SCM_FLAG_COLDBOOT_CPU1		0x01
+#define SCM_FLAG_COLDBOOT_CPU2		0x08
+#define SCM_FLAG_COLDBOOT_CPU3		0x20
+#define SCM_FLAG_WARMBOOT_CPU0		0x04
+#define SCM_FLAG_WARMBOOT_CPU1		0x02
 
 int scm_set_boot_addr(phys_addr_t addr, int flags);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

