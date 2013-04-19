Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030205Ab3DSKsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:48:55 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:38065
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968050Ab3DSKsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:48:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 12/15] powerpc/85xx: add time base sync support for e6500
Date: Fri, 19 Apr 2013 18:47:45 +0800
Message-ID: <1366368468-29143-12-git-send-email-chenhui.zhao@freescale.com>
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

For e6500, two threads in one core share one time base. Just need
to do time base sync on first thread of one core, and skip it on
the other thread.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Andy Fleming <afleming@freescale.com>
---
 arch/powerpc/platforms/85xx/smp.c |   52 +++++++++++++++++++++++++++++++-----
 1 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 74d8cde..5f3eee3 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -26,6 +26,7 @@
 #include <asm/cacheflush.h>
 #include <asm/dbell.h>
 #include <asm/fsl_guts.h>
+#include <asm/cputhreads.h>
 
 #include <sysdev/fsl_soc.h>
 #include <sysdev/mpic.h>
@@ -45,6 +46,7 @@ static u64 timebase;
 static int tb_req;
 static int tb_valid;
 static u32 cur_booting_core;
+static bool rcpmv2;
 
 #ifdef CONFIG_PPC_E500MC
 /* get a physical mask of online cores and booting core */
@@ -53,26 +55,40 @@ static inline u32 get_phy_cpu_mask(void)
 	u32 mask;
 	int cpu;
 
-	mask = 1 << cur_booting_core;
-	for_each_online_cpu(cpu)
-		mask |= 1 << get_hard_smp_processor_id(cpu);
+	if (smt_capable()) {
+		/* two threads in one core share one time base */
+		mask = 1 << cpu_core_index_of_thread(cur_booting_core);
+		for_each_online_cpu(cpu)
+			mask |= 1 << cpu_core_index_of_thread(
+					get_hard_smp_processor_id(cpu));
+	} else {
+		mask = 1 << cur_booting_core;
+		for_each_online_cpu(cpu)
+			mask |= 1 << get_hard_smp_processor_id(cpu);
+	}
 
 	return mask;
 }
 
 static void mpc85xx_timebase_freeze(int freeze)
 {
-	struct ccsr_rcpm __iomem *rcpm = guts_regs;
+	u32 *addr;
 	u32 mask = get_phy_cpu_mask();
 
+	if (rcpmv2)
+		addr = &((struct ccsr_rcpm_v2 *)guts_regs)->pctbenr;
+	else
+		addr = &((struct ccsr_rcpm *)guts_regs)->ctbenr;
+
 	if (freeze)
-		clrbits32(&rcpm->ctbenr, mask);
+		clrbits32(addr, mask);
 	else
-		setbits32(&rcpm->ctbenr, mask);
+		setbits32(addr, mask);
 
-	/* read back to push the previos write */
-	in_be32(&rcpm->ctbenr);
+	/* read back to push the previous write */
+	in_be32(addr);
 }
+
 #else
 static void mpc85xx_timebase_freeze(int freeze)
 {
@@ -94,6 +110,16 @@ static void mpc85xx_give_timebase(void)
 {
 	unsigned long flags;
 
+#ifdef CONFIG_PPC_E500MC
+	/*
+	 * If the booting thread is not the first thread of the core,
+	 * skip time base sync.
+	 */
+	if (smt_capable() &&
+		cur_booting_core != cpu_first_thread_sibling(cur_booting_core))
+		return;
+#endif
+
 	local_irq_save(flags);
 
 	while (!tb_req)
@@ -117,6 +143,12 @@ static void mpc85xx_take_timebase(void)
 {
 	unsigned long flags;
 
+#ifdef CONFIG_PPC_E500MC
+	if (smt_capable() &&
+		cur_booting_core != cpu_first_thread_sibling(cur_booting_core))
+		return;
+#endif
+
 	local_irq_save(flags);
 
 	tb_req = 1;
@@ -457,6 +489,7 @@ static const struct of_device_id mpc85xx_smp_guts_ids[] = {
 	{ .compatible = "fsl,p1023-guts", },
 	{ .compatible = "fsl,p2020-guts", },
 	{ .compatible = "fsl,qoriq-rcpm-1.0", },
+	{ .compatible = "fsl,qoriq-rcpm-2.0", },
 	{},
 };
 
@@ -483,6 +516,9 @@ void __init mpc85xx_smp_init(void)
 
 	np = of_find_matching_node(NULL, mpc85xx_smp_guts_ids);
 	if (np) {
+		if (of_device_is_compatible(np, "fsl,qoriq-rcpm-2.0"))
+			rcpmv2 = true;
+
 		guts_regs = of_iomap(np, 0);
 		of_node_put(np);
 		if (!guts_regs) {
-- 
1.7.3


