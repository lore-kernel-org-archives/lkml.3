Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaKPATn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 19:19:43 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39683 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaKPATj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 19:19:39 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 12/22] MIPS: BMIPS: Explicitly configure reset vectors prior to secondary boot
Date: Sat, 15 Nov 2014 16:17:36 -0800
Message-Id: <1416097066-20452-13-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The secondary CPU's reset vector needs to be set to KSEG1 for a cold
boot (release from reset), or KSEG0 for a warm restart.  On a cold boot
KSEG0 may be unavailable (BMIPS4380), and on a warm restart KSEG1 may
be unavailable (XKS01 mode on 4380 or 5000).

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/kernel/smp-bmips.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index f7b1bee..162391d 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -47,6 +47,8 @@ cpumask_t bmips_booted_mask;
 #define RESET_FROM_KSEG0		0x80080800
 #define RESET_FROM_KSEG1		0xa0080800
 
+static void bmips_set_reset_vec(int cpu, u32 val);
+
 #ifdef CONFIG_SMP
 
 /* initial $sp, $gp - used by arch/mips/kernel/bmips_vec.S */
@@ -198,6 +200,9 @@ static void bmips_boot_secondary(int cpu, struct task_struct *idle)
 	pr_info("SMP: Booting CPU%d...\n", cpu);
 
 	if (cpumask_test_cpu(cpu, &bmips_booted_mask)) {
+		/* kseg1 might not exist if this CPU enabled XKS01 */
+		bmips_set_reset_vec(cpu, RESET_FROM_KSEG0);
+
 		switch (current_cpu_type()) {
 		case CPU_BMIPS4350:
 		case CPU_BMIPS4380:
@@ -207,8 +212,9 @@ static void bmips_boot_secondary(int cpu, struct task_struct *idle)
 			bmips5000_send_ipi_single(cpu, 0);
 			break;
 		}
-	}
-	else {
+	} else {
+		bmips_set_reset_vec(cpu, RESET_FROM_KSEG1);
+
 		switch (current_cpu_type()) {
 		case CPU_BMIPS4350:
 		case CPU_BMIPS4380:
@@ -229,31 +235,12 @@ static void bmips_boot_secondary(int cpu, struct task_struct *idle)
  */
 static void bmips_init_secondary(void)
 {
-	/* move NMI vector to kseg0, in case XKS01 is enabled */
-
-	void __iomem *cbr;
-	unsigned long old_vec;
-	unsigned long relo_vector;
-	int boot_cpu;
-
 	switch (current_cpu_type()) {
 	case CPU_BMIPS4350:
 	case CPU_BMIPS4380:
-		cbr = BMIPS_GET_CBR();
-
-		boot_cpu = !!(read_c0_brcm_cmt_local() & (1 << 31));
-		relo_vector = boot_cpu ? BMIPS_RELO_VECTOR_CONTROL_0 :
-				  BMIPS_RELO_VECTOR_CONTROL_1;
-
-		old_vec = __raw_readl(cbr + relo_vector);
-		__raw_writel(old_vec & ~0x20000000, cbr + relo_vector);
-
 		clear_c0_cause(smp_processor_id() ? C_SW1 : C_SW0);
 		break;
 	case CPU_BMIPS5000:
-		write_c0_brcm_bootvec(read_c0_brcm_bootvec() &
-			(smp_processor_id() & 0x01 ? ~0x20000000 : ~0x2000));
-
 		write_c0_brcm_action(ACTION_CLR_IPI(smp_processor_id(), 0));
 		break;
 	}
-- 
2.1.1

