Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3EIWco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:32:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab3EIWck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 02/73] powerpc: Emulate non privileged DSCR read and write
Date: Thu,  9 May 2013 15:31:25 -0700
Message-Id: <20130509222758.194456243@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 73d2fb758e678c93bc76d40876c2359f0729b0ef upstream.

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
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/ppc-opcode.h |    4 ++++
 arch/powerpc/kernel/traps.c           |   10 ++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -112,6 +112,10 @@
 #define PPC_INST_MFSPR_DSCR_MASK	0xfc1fffff
 #define PPC_INST_MTSPR_DSCR		0x7c1103a6
 #define PPC_INST_MTSPR_DSCR_MASK	0xfc1fffff
+#define PPC_INST_MFSPR_DSCR_USER	0x7c0302a6
+#define PPC_INST_MFSPR_DSCR_USER_MASK	0xfc1fffff
+#define PPC_INST_MTSPR_DSCR_USER	0x7c0303a6
+#define PPC_INST_MTSPR_DSCR_USER_MASK	0xfc1fffff
 #define PPC_INST_SLBFEE			0x7c0007a7
 
 #define PPC_INST_STRING			0x7c00042a
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -961,7 +961,10 @@ static int emulate_instruction(struct pt
 
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
@@ -969,7 +972,10 @@ static int emulate_instruction(struct pt
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


