Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbbAMK0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:26:09 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:44694 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbAMKW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:22:56 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org, shuahkh@osg.samsung.com
Subject: [PATCH V2 01/12] powerpc: Fix handling of DSCR related facility unavailable exception
Date: Tue, 13 Jan 2015 15:52:29 +0530
Message-Id: <1421144560-15901-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011310-0009-0000-0000-000000CACA66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently DSCR (Data Stream Control Register) can be accessed with
mfspr or mtspr instructions inside a thread via two different SPR
numbers. One being the user accessible problem state SPR number 0x03
and the other being the privilege state SPR number 0x11. All access
through the privilege state SPR number get emulated through illegal
instruction exception. Any access through the problem state SPR number
raises one facility unavailable exception which sets the thread based
dscr_inherit bit and enables DSCR facility through FSCR register thus
allowing direct access to DSCR without going through this exception in
the future. We set the thread.dscr_inherit bit whether the access was
with mfspr or mtspr instruction which is neither correct nor does it
match the behaviour through the instruction emulation code path driven
from privilege state SPR number. User currently observes two different
kind of behaviour when accessing the DSCR through these two SPR numbers.
This problem can be observed through these two test cases by replacing
the privilege state SPR number with the problem state SPR number.

	(1) http://ozlabs.org/~anton/junkcode/dscr_default_test.c
	(2) http://ozlabs.org/~anton/junkcode/dscr_explicit_test.c

This patch fixes the problem by making sure that the behaviour visible
to the user remains the same irrespective of which SPR number is being
used. Inside facility unavailable exception, we check whether it was
cuased by a mfspr or a mtspr isntrucction. In case of mfspr instruction,
just emulate the instruction. In case of mtspr instruction, set the
thread based dscr_inherit bit and also enable the facility through FSCR.
All user SPR based mfspr instruction will be emulated till one user SPR
based mtspr has been executed.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/traps.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index e6595b7..cd69340 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1377,6 +1377,7 @@ void facility_unavailable_exception(struct pt_regs *regs)
 	};
 	char *facility = "unknown";
 	u64 value;
+	u32 instword, rd;
 	u8 status;
 	bool hv;
 
@@ -1388,12 +1389,46 @@ void facility_unavailable_exception(struct pt_regs *regs)
 
 	status = value >> 56;
 	if (status == FSCR_DSCR_LG) {
-		/* User is acessing the DSCR.  Set the inherit bit and allow
-		 * the user to set it directly in future by setting via the
-		 * FSCR DSCR bit.  We always leave HFSCR DSCR set.
+		/*
+		 * User is accessing the DSCR register using the problem
+		 * state only SPR number (0x03) either through a mfspr or
+		 * a mtspr instruction. If it is a write attempt through
+		 * a mtspr, then we set the inherit bit. This also allows
+		 * the user to write or read the register directly in the
+		 * future by setting via the FSCR DSCR bit. But in case it
+		 * is a read DSCR attempt through a mfspr instruction, we
+		 * just emulate the instruction instead. This code path will
+		 * always emulate all the mfspr instructions till the user
+		 * has attempted atleast one mtspr instruction. This way it
+		 * preserves the same behaviour when the user is accessing
+		 * the DSCR through privilege level only SPR number (0x11)
+		 * which is emulated through illegal instruction exception.
+		 * We always leave HFSCR DSCR set.
 		 */
-		current->thread.dscr_inherit = 1;
-		mtspr(SPRN_FSCR, value | FSCR_DSCR);
+		if (get_user(instword, (u32 __user *)(regs->nip))) {
+			pr_err("Failed to fetch the user instruction\n");
+			return;
+		}
+
+		/* Write into DSCR (mtspr 0x03, RS) */
+		if ((instword & PPC_INST_MTSPR_DSCR_USER_MASK)
+				== PPC_INST_MTSPR_DSCR_USER) {
+			rd = (instword >> 21) & 0x1f;
+			current->thread.dscr = regs->gpr[rd];
+			current->thread.dscr_inherit = 1;
+			mtspr(SPRN_FSCR, value | FSCR_DSCR);
+		}
+
+		/* Read from DSCR (mfspr RT, 0x03) */
+		if ((instword & PPC_INST_MFSPR_DSCR_USER_MASK)
+				== PPC_INST_MFSPR_DSCR_USER) {
+			if (emulate_instruction(regs)) {
+				pr_err("DSCR based mfspr emulation failed\n");
+				return;
+			}
+			regs->nip += 4;
+			emulate_single_step(regs);
+		}
 		return;
 	}
 
-- 
1.9.3

