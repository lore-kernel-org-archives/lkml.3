Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaHRJfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:35:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaHRJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 069/137] s390/ptrace: fix PSW mask check
Date: Mon, 18 Aug 2014 10:32:10 +0100
Message-Id: <1408354398-10226-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit dab6cf55f81a6e16b8147aed9a843e1691dcd318 upstream.

The PSW mask check of the PTRACE_POKEUSR_AREA command is incorrect.
For the default user_mode=home address space layout the psw_user_bits
variable has the home space address-space-control bits set. But the
PSW_MASK_USER contains PSW_MASK_ASC, the ptrace validity check for the
PSW mask will therefore always fail.

Fixes CVE-2014-3534

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ luis: backported to 3.11: used Martin's backport to 3.2 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kernel/ptrace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index e9fadb04e3c6..319da563e6cf 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -322,7 +322,9 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
 		 * psw and gprs are stored on the stack
 		 */
 		if (addr == (addr_t) &dummy->regs.psw.mask &&
-		    ((data & ~PSW_MASK_USER) != psw_user_bits ||
+		    (((data^psw_user_bits) & ~PSW_MASK_USER) ||
+		     (((data^psw_user_bits) & PSW_MASK_ASC) &&
+		      ((data|psw_user_bits) & PSW_MASK_ASC) == PSW_MASK_ASC) ||
 		     ((data & PSW_MASK_EA) && !(data & PSW_MASK_BA))))
 			/* Invalid psw mask. */
 			return -EINVAL;
@@ -655,7 +657,10 @@ static int __poke_user_compat(struct task_struct *child,
 		 */
 		if (addr == (addr_t) &dummy32->regs.psw.mask) {
 			/* Build a 64 bit psw mask from 31 bit mask. */
-			if ((tmp & ~PSW32_MASK_USER) != psw32_user_bits)
+			if (((tmp^psw32_user_bits) & ~PSW32_MASK_USER) ||
+			    (((tmp^psw32_user_bits) & PSW32_MASK_ASC) &&
+			     ((tmp|psw32_user_bits) & PSW32_MASK_ASC)
+			     == PSW32_MASK_ASC))
 				/* Invalid psw mask. */
 				return -EINVAL;
 			regs->psw.mask = (regs->psw.mask & ~PSW_MASK_USER) |
-- 
1.9.1

