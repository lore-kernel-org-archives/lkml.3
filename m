Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaKKMCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:02:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57259 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaKKLJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 034/170] MIPS: cp1emu: Fix ISA restrictions for cop1x_op instructions
Date: Tue, 11 Nov 2014 11:06:33 +0000
Message-Id: <1415704129-12709-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit a5466d7bba9af83a82cc7c081b2a7d557cde3204 upstream.

Commit 08a07904e1828 ("MIPS: math-emu: Remove most ifdefery") removed
the #ifdef ISA conditions and switched to runtime detection. However,
according to the instruction set manual, the cop1x_op instructions are
available in >=MIPS32r2 as well. This fixes a problem on MIPS32r2
with the ntpd package which failed to execute with a SIGILL exit code due
to the fact that a madd.d instruction was not being emulated.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Fixes: 08a07904e1828 ("MIPS: math-emu: Remove most ifdefery")
Cc: linux-mips@linux-mips.org
Reviewed-by: Paul Burton <paul.burton@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: Markos Chandras <markos.chandras@imgtec.com>
Patchwork: https://patchwork.linux-mips.org/patch/8173/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/math-emu/cp1emu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index 7a4727795a70..51a0fde4bec1 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -1023,7 +1023,7 @@ emul:
 					goto emul;
 
 				case cop1x_op:
-					if (cpu_has_mips_4_5 || cpu_has_mips64)
+					if (cpu_has_mips_4_5 || cpu_has_mips64 || cpu_has_mips32r2)
 						/* its one of ours */
 						goto emul;
 
@@ -1068,7 +1068,7 @@ emul:
 		break;
 
 	case cop1x_op:
-		if (!cpu_has_mips_4_5 && !cpu_has_mips64)
+		if (!cpu_has_mips_4_5 && !cpu_has_mips64 && !cpu_has_mips32r2)
 			return SIGILL;
 
 		sig = fpux_emu(xcp, ctx, ir, fault_addr);
-- 
2.1.0

