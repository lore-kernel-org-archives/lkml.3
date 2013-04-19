Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968233Ab3DSKuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:50:21 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:20880
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968105Ab3DSKs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:48:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 07/15] powerpc/85xx: add time base sync for SoCs based on e500mc/e5500
Date: Fri, 19 Apr 2013 18:47:40 +0800
Message-ID: <1366368468-29143-7-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen-Hui Zhao <chenhui.zhao@freescale.com>

In the case of SMP, during the time base sync period, all time bases of
online cores must stop, then start simultaneously.

There is a RCPM (Run Control/Power Management) module in CoreNet based SoCs.
Define a struct ccsr_rcpm to describe the register map.

This patch supports SoCs based on e500mc/e5500, such as P4080, P5020,
etc.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 arch/powerpc/include/asm/fsl_guts.h |   38 +++++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/85xx/smp.c   |   32 +++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/fsl_guts.h b/arch/powerpc/include/asm/fsl_guts.h
index 77ced0b..4eac1cf 100644
--- a/arch/powerpc/include/asm/fsl_guts.h
+++ b/arch/powerpc/include/asm/fsl_guts.h
@@ -106,6 +106,44 @@ struct ccsr_guts {
 /* Alternate function signal multiplex control */
 #define MPC85xx_PMUXCR_QE(x) (0x8000 >> (x))
 
+struct ccsr_rcpm {
+	u8	res0000[4];
+	__be32	cdozsr;		/* 0x0004 - Core Doze Status Register */
+	u8	res0008[4];
+	__be32	cdozcr;		/* 0x000c - Core Doze Control Register */
+	u8	res0010[4];
+	__be32	cnapsr;		/* 0x0014 - Core Nap Status Register */
+	u8	res0018[4];
+	__be32	cnapcr;		/* 0x001c - Core Nap Control Register */
+	u8	res0020[4];
+	__be32	cdozpsr;	/* 0x0024 - Core Doze Previous Status Register */
+	u8	res0028[4];
+	__be32	cnappsr;	/* 0x002c - Core Nap Previous Status Register */
+	u8	res0030[4];
+	__be32	cwaitsr;	/* 0x0034 - Core Wait Status Register */
+	u8	res0038[4];
+	__be32	cwdtdsr;	/* 0x003c - Core watchdog detect status register */
+	__be32	powmgtcsr;	/* 0x0040 - Power Mangement Control & Status Register */
+	u8	res0044[12];
+	__be32	ippdexpcr;	/* 0x0050 - IP Powerdown Exception Control Register */
+	u8	res0054[16];
+	__be32	cpmimr;		/* 0x0064 - Core PM IRQ Mask Register */
+	u8	res0068[4];
+	__be32	cpmcimr;	/* 0x006c - Core PM Critical IRQ Mask Register */
+	u8	res0070[4];
+	__be32	cpmmcmr;	/* 0x0074 - Core PM Machine Check Mask Register */
+	u8	res0078[4];
+	__be32	cpmnmimr;	/* 0x007c - Core PM NMI Mask Register */
+	u8	res0080[4];
+	__be32	ctbenr;		/* 0x0084 - Core Time Base Enable Register */
+	u8	res0088[4];
+	__be32	ctbckselr;	/* 0x008c - Core Time Base Clock Select Register */
+	u8	res0090[4];
+	__be32	ctbhltcr;	/* 0x0094 - Core Time Base Halt Control Register */
+	u8	res0098[4];
+	__be32	cmcpmaskcr;	/* 0x00a4 - Core machine check mask control register */
+};
+
 #ifdef CONFIG_PPC_86xx
 
 #define CCSR_GUTS_DMACR_DEV_SSI	0	/* DMA controller/channel set to SSI */
diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 6a17599..6c2fe6b 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -44,7 +44,36 @@ static struct ccsr_guts __iomem *guts;
 static u64 timebase;
 static int tb_req;
 static int tb_valid;
+static u32 cur_booting_core;
 
+#ifdef CONFIG_PPC_E500MC
+/* get a physical mask of online cores and booting core */
+static inline u32 get_phy_cpu_mask(void)
+{
+	u32 mask;
+	int cpu;
+
+	mask = 1 << cur_booting_core;
+	for_each_online_cpu(cpu)
+		mask |= 1 << get_hard_smp_processor_id(cpu);
+
+	return mask;
+}
+
+static void mpc85xx_timebase_freeze(int freeze)
+{
+	struct ccsr_rcpm __iomem *rcpm = (typeof(rcpm))guts;
+	u32 mask = get_phy_cpu_mask();
+
+	if (freeze)
+		clrbits32(&rcpm->ctbenr, mask);
+	else
+		setbits32(&rcpm->ctbenr, mask);
+
+	/* read back to push the previos write */
+	in_be32(&rcpm->ctbenr);
+}
+#else
 static void mpc85xx_timebase_freeze(int freeze)
 {
 	uint32_t mask;
@@ -57,6 +86,7 @@ static void mpc85xx_timebase_freeze(int freeze)
 
 	in_be32(&guts->devdisr);
 }
+#endif
 
 static void mpc85xx_give_timebase(void)
 {
@@ -244,6 +274,7 @@ out:
 	  __pa((u64)*((unsigned long long *)generic_secondary_smp_init)));
 	flush_spin_table(spin_table);
 #endif
+	cur_booting_core = hw_cpu;
 
 	local_irq_restore(flags);
 
@@ -378,6 +409,7 @@ static const struct of_device_id mpc85xx_smp_guts_ids[] = {
 	{ .compatible = "fsl,p1022-guts", },
 	{ .compatible = "fsl,p1023-guts", },
 	{ .compatible = "fsl,p2020-guts", },
+	{ .compatible = "fsl,qoriq-rcpm-1.0", },
 	{},
 };
 
-- 
1.7.3


