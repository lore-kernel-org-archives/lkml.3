Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaCLWjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:39:53 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:54904 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaCLWjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:39:51 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@imgtec.com>, Paul Bolle <pebolle@tiscali.nl>,
        Huacai Chen <chenhc@lemote.com>, Andreas Barth <aba@ayous.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH RESEND 2/2] MIPS: fpu: fix conflict of register usage
Date: Thu, 13 Mar 2014 00:41:07 +0200
Message-Id: <1394664067-17712-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394664067-17712-1-git-send-email-aaro.koskinen@iki.fi>
References: <1394664067-17712-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

In _restore_fp_context/_restore_fp_context32, t0 is used for both
CP0_Status and CP1_FCSR. This is a mistake and cause FP exeception on
boot, so fix it.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Andreas Barth <aba@ayous.org>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/kernel/r4k_fpu.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/r4k_fpu.S b/arch/mips/kernel/r4k_fpu.S
index 841ffc2..73b0ddf 100644
--- a/arch/mips/kernel/r4k_fpu.S
+++ b/arch/mips/kernel/r4k_fpu.S
@@ -146,7 +146,7 @@ LEAF(_save_fp_context32)
  *  - cp1 status/control register
  */
 LEAF(_restore_fp_context)
-	EX	lw t0, SC_FPC_CSR(a0)
+	EX	lw t1, SC_FPC_CSR(a0)
 
 #if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	.set	push
@@ -191,7 +191,7 @@ LEAF(_restore_fp_context)
 	EX	ldc1 $f26, SC_FPREGS+208(a0)
 	EX	ldc1 $f28, SC_FPREGS+224(a0)
 	EX	ldc1 $f30, SC_FPREGS+240(a0)
-	ctc1	t0, fcr31
+	ctc1	t1, fcr31
 	jr	ra
 	 li	v0, 0					# success
 	END(_restore_fp_context)
@@ -199,7 +199,7 @@ LEAF(_restore_fp_context)
 #ifdef CONFIG_MIPS32_COMPAT
 LEAF(_restore_fp_context32)
 	/* Restore an o32 sigcontext.  */
-	EX	lw t0, SC32_FPC_CSR(a0)
+	EX	lw t1, SC32_FPC_CSR(a0)
 
 	mfc0	t0, CP0_STATUS
 	sll	t0, t0, 5
@@ -239,7 +239,7 @@ LEAF(_restore_fp_context32)
 	EX	ldc1 $f26, SC32_FPREGS+208(a0)
 	EX	ldc1 $f28, SC32_FPREGS+224(a0)
 	EX	ldc1 $f30, SC32_FPREGS+240(a0)
-	ctc1	t0, fcr31
+	ctc1	t1, fcr31
 	jr	ra
 	 li	v0, 0					# success
 	END(_restore_fp_context32)
-- 
1.9.0

