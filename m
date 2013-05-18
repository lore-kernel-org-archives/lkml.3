Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab3ERDHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:07:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783Ab3ERDAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:25 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9acEEe3W6k4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=onhswb2BP_AA:10 a=hGzw-44bAAAA:8 a=voM4FWlXAAAA:8 a=VwQbUJbxAAAA:8 a=wMNdZWldAAAA:8 a=8WXfJLGesGv5xUiFjkQA:9 a=dowx1zmaLagA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021655.431101252@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>, <stable@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 085/136 ] powerpc: Emulate non privileged DSCR read and write
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0085-powerpc-Emulate-non-privileged-DSCR-read-and-write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

[ Upstream commit 73d2fb758e678c93bc76d40876c2359f0729b0ef ]

POWER8 allows read and write of the DSCR in userspace. We added
kernel emulation so applications could always use the instructions
regardless of the CPU type.

Unfortunately there are two SPRs for the DSCR and we only added
emulation for the privileged one. Add code to match the non
privileged one.

A simple test was created to verify the fix:

http://ozlabs.org/~anton/junkcode/user_dscr_test.c

Without the patch we get a SIGILL and it passes with the patch.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/include/asm/ppc-opcode.h |    4 ++++
 arch/powerpc/kernel/traps.c           |   10 ++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index 4c25319..d486ec3 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -111,6 +111,10 @@
 #define PPC_INST_MFSPR_DSCR_MASK	0xfc1fffff
 #define PPC_INST_MTSPR_DSCR		0x7c1103a6
 #define PPC_INST_MTSPR_DSCR_MASK	0xfc1fffff
+#define PPC_INST_MFSPR_DSCR_USER	0x7c0302a6
+#define PPC_INST_MFSPR_DSCR_USER_MASK	0xfc1fffff
+#define PPC_INST_MTSPR_DSCR_USER	0x7c0303a6
+#define PPC_INST_MTSPR_DSCR_USER_MASK	0xfc1fffff
 #define PPC_INST_SLBFEE			0x7c0007a7
 
 #define PPC_INST_STRING			0x7c00042a
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index ae0843f..3bb7197 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -960,7 +960,10 @@ static int emulate_instruction(struct pt_regs *regs)
 
 #ifdef CONFIG_PPC64
 	/* Emulate the mfspr rD, DSCR. */
-	if (((instword & PPC_INST_MFSPR_DSCR_MASK) == PPC_INST_MFSPR_DSCR) &&
+	if ((((instword & PPC_INST_MFSPR_DSCR_USER_MASK) ==
+		PPC_INST_MFSPR_DSCR_USER) ||
+	     ((instword & PPC_INST_MFSPR_DSCR_MASK) ==
+		PPC_INST_MFSPR_DSCR)) &&
 			cpu_has_feature(CPU_FTR_DSCR)) {
 		PPC_WARN_EMULATED(mfdscr, regs);
 		rd = (instword >> 21) & 0x1f;
@@ -968,7 +971,10 @@ static int emulate_instruction(struct pt_regs *regs)
 		return 0;
 	}
 	/* Emulate the mtspr DSCR, rD. */
-	if (((instword & PPC_INST_MTSPR_DSCR_MASK) == PPC_INST_MTSPR_DSCR) &&
+	if ((((instword & PPC_INST_MTSPR_DSCR_USER_MASK) ==
+		PPC_INST_MTSPR_DSCR_USER) ||
+	     ((instword & PPC_INST_MTSPR_DSCR_MASK) ==
+		PPC_INST_MTSPR_DSCR)) &&
 			cpu_has_feature(CPU_FTR_DSCR)) {
 		PPC_WARN_EMULATED(mtdscr, regs);
 		rd = (instword >> 21) & 0x1f;
-- 
1.7.10.4


