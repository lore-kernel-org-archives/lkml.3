Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbbAONMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:12:17 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17896 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbbAONMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:12:13 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v3 02/15] MIPS: OCTEON: Fix FP context save.
Date: Thu, 15 Jan 2015 16:11:06 +0300
Message-ID: <1421327487-28679-3-git-send-email-aleksey.makarov@auriga.com>
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

It wasn't being saved on task switch.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 arch/mips/kernel/octeon_switch.S | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/mips/kernel/octeon_switch.S b/arch/mips/kernel/octeon_switch.S
index 3dec1e8..2787c01 100644
--- a/arch/mips/kernel/octeon_switch.S
+++ b/arch/mips/kernel/octeon_switch.S
@@ -31,15 +31,11 @@
 	/*
 	 * check if we need to save FPU registers
 	 */
-	PTR_L	t3, TASK_THREAD_INFO(a0)
-	LONG_L	t0, TI_FLAGS(t3)
-	li	t1, _TIF_USEDFPU
-	and	t2, t0, t1
-	beqz	t2, 1f
-	nor	t1, zero, t1
-
-	and	t0, t0, t1
-	LONG_S	t0, TI_FLAGS(t3)
+	.set push
+	.set noreorder
+	beqz	a3, 1f
+	 PTR_L	t3, TASK_THREAD_INFO(a0)
+	.set pop
 
 	/*
 	 * clear saved user stack CU1 bit
@@ -57,14 +53,13 @@
 1:
 
 	/* check if we need to save COP2 registers */
-	PTR_L	t2, TASK_THREAD_INFO(a0)
-	LONG_L	t0, ST_OFF(t2)
+	LONG_L	t0, ST_OFF(t3)
 	bbit0	t0, 30, 1f
 
 	/* Disable COP2 in the stored process state */
 	li	t1, ST0_CU2
 	xor	t0, t1
-	LONG_S	t0, ST_OFF(t2)
+	LONG_S	t0, ST_OFF(t3)
 
 	/* Enable COP2 so we can save it */
 	mfc0	t0, CP0_STATUS
-- 
2.2.2

