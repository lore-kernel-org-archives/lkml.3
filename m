Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3ARMm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:42:57 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:59380 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3ARMmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:42:55 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 75/76] ARC: [Review] Multi-platform image #8: platform registers SMP callbacks
Date: Fri, 18 Jan 2013 18:10:26 +0530
Message-ID: <1358512827-7694-4-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358512827-7694-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
 <1358512827-7694-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms export their SMP callbacks by populating arc_smp_ops.
The population itself needs to be done pretty early, from init_early
callback.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/plat-arcfpga/include/plat/smp.h |    1 +
 arch/arc/plat-arcfpga/platform.c         |    4 +++
 arch/arc/plat-arcfpga/smp.c              |   41 ++++++++++++++++-------------
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/arch/arc/plat-arcfpga/include/plat/smp.h b/arch/arc/plat-arcfpga/include/plat/smp.h
index 27822ac..c09eb4c 100644
--- a/arch/arc/plat-arcfpga/include/plat/smp.h
+++ b/arch/arc/plat-arcfpga/include/plat/smp.h
@@ -111,6 +111,7 @@ extern void idu_irq_set_tgtcpu(uint8_t irq, uint32_t mask);
 extern void idu_irq_set_mode(uint8_t irq, uint8_t dest_mode, uint8_t trig_mode);
 
 extern void iss_model_init_smp(unsigned int cpu);
+extern void iss_model_init_early_smp(void);
 
 #endif	/* CONFIG_SMP */
 
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index 1a9f2f2..b99bfea 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -171,6 +171,10 @@ static void __init plat_fpga_early_init(void)
 	setup_bvci_lat_unit();
 
 	arc_fpga_serial_init();
+
+#ifdef CONFIG_SMP
+	iss_model_init_early_smp();
+#endif
 }
 
 static struct of_dev_auxdata plat_auxdata_lookup[] __initdata = {
diff --git a/arch/arc/plat-arcfpga/smp.c b/arch/arc/plat-arcfpga/smp.c
index 68a53b1..91b5534 100644
--- a/arch/arc/plat-arcfpga/smp.c
+++ b/arch/arc/plat-arcfpga/smp.c
@@ -24,25 +24,10 @@ static char smp_cpuinfo_buf[128];
  *-------------------------------------------------------------------
  */
 
-const char *arc_platform_smp_cpuinfo(void)
-{
-#define IS_AVAIL1(var, str)    ((var) ? str : "")
-
-	struct bcr_mp mp;
-
-	READ_BCR(ARC_REG_MP_BCR, mp);
-
-	sprintf(smp_cpuinfo_buf, "Extn [700-SMP]: v%d, arch(%d) %s %s %s\n",
-		mp.ver, mp.mp_arch, IS_AVAIL1(mp.scu, "SCU"),
-		IS_AVAIL1(mp.idu, "IDU"), IS_AVAIL1(mp.sdu, "SDU"));
-
-	return smp_cpuinfo_buf;
-}
-
 /*
  * Master kick starting another CPU
  */
-void arc_platform_smp_wakeup_cpu(int cpu, unsigned long pc)
+static void iss_model_smp_wakeup_cpu(int cpu, unsigned long pc)
 {
 	/* setup the start PC */
 	write_aux_reg(ARC_AUX_XTL_REG_PARAM, pc);
@@ -103,19 +88,39 @@ void iss_model_init_smp(unsigned int cpu)
 	smp_ipi_irq_setup(cpu, IDU_INTERRUPT_0 + cpu);
 }
 
-void arc_platform_ipi_send(const struct cpumask *callmap)
+static void iss_model_ipi_send(void *arg)
 {
+	struct cpumask *callmap = arg;
 	unsigned int cpu;
 
 	for_each_cpu(cpu, callmap)
 		idu_irq_assert(cpu);
 }
 
-void arc_platform_ipi_clear(int cpu, int irq)
+static void iss_model_ipi_clear(int cpu, int irq)
 {
 	idu_irq_clear(IDU_INTERRUPT_0 + cpu);
 }
 
+void iss_model_init_early_smp(void)
+{
+#define IS_AVAIL1(var, str)    ((var) ? str : "")
+
+	struct bcr_mp mp;
+
+	READ_BCR(ARC_REG_MP_BCR, mp);
+
+	sprintf(smp_cpuinfo_buf, "Extn [ISS-SMP]: v%d, arch(%d) %s %s %s\n",
+		mp.ver, mp.mp_arch, IS_AVAIL1(mp.scu, "SCU"),
+		IS_AVAIL1(mp.idu, "IDU"), IS_AVAIL1(mp.sdu, "SDU"));
+
+	plat_smp_ops.info = smp_cpuinfo_buf;
+
+	plat_smp_ops.cpu_kick = iss_model_smp_wakeup_cpu;
+	plat_smp_ops.ipi_send = iss_model_ipi_send;
+	plat_smp_ops.ipi_clear = iss_model_ipi_clear;
+}
+
 /*
  *-------------------------------------------------------------------
  * Low level Platform IPI Providers
-- 
1.7.4.1

