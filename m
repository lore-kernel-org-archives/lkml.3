Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbaIOWUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:20:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51286 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410AbaIOWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 124/187] MIPS: GIC: Prevent array overrun
Date: Mon, 15 Sep 2014 15:08:54 -0700
Message-Id: <1410818997-9432-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffrey Deans <jeffrey.deans@imgtec.com>

commit ffc8415afab20bd97754efae6aad1f67b531132b upstream.

A GIC interrupt which is declared as having a GIC_MAP_TO_NMI_MSK
mapping causes the cpu parameter to gic_setup_intr() to be increased
to 32, causing memory corruption when pcpu_masks[] is written to again
later in the function.

Signed-off-by: Jeffrey Deans <jeffrey.deans@imgtec.com>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7375/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/mips/kernel/irq-gic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index 5b5ddb2..78f1843 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -255,11 +255,13 @@ static void __init gic_setup_intr(unsigned int intr, unsigned int cpu,
 
 	/* Setup Intr to Pin mapping */
 	if (pin & GIC_MAP_TO_NMI_MSK) {
+		int i;
+
 		GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_MAP_TO_PIN(intr)), pin);
 		/* FIXME: hack to route NMI to all cpu's */
-		for (cpu = 0; cpu < NR_CPUS; cpu += 32) {
+		for (i = 0; i < NR_CPUS; i += 32) {
 			GICWRITE(GIC_REG_ADDR(SHARED,
-					  GIC_SH_MAP_TO_VPE_REG_OFF(intr, cpu)),
+					  GIC_SH_MAP_TO_VPE_REG_OFF(intr, i)),
 				 0xffffffff);
 		}
 	} else {
-- 
1.9.1

