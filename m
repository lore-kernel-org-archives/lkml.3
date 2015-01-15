Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbbAONNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:13:30 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17943 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbbAONNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:13:25 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v3 11/15] MIPS: OCTEON: Core-15169 Workaround and general CVMSEG cleanup.
Date: Thu, 15 Jan 2015 16:11:15 +0300
Message-ID: <1421327487-28679-12-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
References: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 arch/mips/cavium-octeon/setup.c                       |  4 +---
 .../asm/mach-cavium-octeon/kernel-entry-init.h        | 19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 45e17a1..aea091d 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -583,12 +583,10 @@ void octeon_user_io_init(void)
 	/* R/W If set, CVMSEG is available for loads/stores in user
 	 * mode. */
 	cvmmemctl.s.cvmsegenau = 0;
-	/* R/W Size of local memory in cache blocks, 54 (6912 bytes)
-	 * is max legal value. */
-	cvmmemctl.s.lmemsz = CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE;
 
 	write_c0_cvmmemctl(cvmmemctl.u64);
 
+	/* Setup of CVMSEG is done in kernel-entry-init.h */
 	if (smp_processor_id() == 0)
 		pr_notice("CVMSEG size: %d cache lines (%d bytes)\n",
 			  CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE,
diff --git a/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h b/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
index 21732c3..c7ce081 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
@@ -8,11 +8,10 @@
 #ifndef __ASM_MACH_CAVIUM_OCTEON_KERNEL_ENTRY_H
 #define __ASM_MACH_CAVIUM_OCTEON_KERNEL_ENTRY_H
 
-
-#define CP0_CYCLE_COUNTER $9, 6
 #define CP0_CVMCTL_REG $9, 7
 #define CP0_CVMMEMCTL_REG $11,7
 #define CP0_PRID_REG $15, 0
+#define CP0_DCACHE_ERR_REG $27, 1
 #define CP0_PRID_OCTEON_PASS1 0x000d0000
 #define CP0_PRID_OCTEON_CN30XX 0x000d0200
 
@@ -60,7 +59,7 @@
 skip:
 	# First clear off CvmCtl[IPPCI] bit and move the performance
 	# counters interrupt to IRQ 6
-	li	v1, ~(7 << 7)
+	dli	v1, ~(7 << 7)
 	and	v0, v0, v1
 	ori	v0, v0, (6 << 7)
 
@@ -90,6 +89,20 @@ skip:
 	sync
 	# Flush dcache after config change
 	cache	9, 0($0)
+	# Zero all of CVMSEG to make sure parity is correct
+	dli	v0, CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE
+	dsll	v0, 7
+	beqz	v0, 2f
+1:	dsubu	v0, 8
+	sd	$0, -32768(v0)
+	bnez	v0, 1b
+2:
+	mfc0	v0, CP0_PRID_REG
+	bbit0	v0, 15, 1f
+	# OCTEON II or better have bit 15 set.  Clear the error bits.
+	dli	v0, 0x27
+	dmtc0	v0, CP0_DCACHE_ERR_REG
+1:
 	# Get my core id
 	rdhwr	v0, $0
 	# Jump the master to kernel_entry
-- 
2.2.2

