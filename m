Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaHTLoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:44:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58859 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 001/104] s390/ptrace: fix PSW mask check
Date: Wed, 20 Aug 2014 13:42:24 +0200
Message-Id: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dab6cf55f81a6e16b8147aed9a843e1691dcd318 upstream.

The PSW mask check of the PTRACE_POKEUSR_AREA command is incorrect.
The PSW_MASK_USER define contains the PSW_MASK_ASC bits, the ptrace
interface accepts all combinations for the address-space-control
bits. To protect the kernel space the PSW mask check in ptrace needs
to reject the address-space-control bit combination for home space.

Fixes CVE-2014-3534

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/s390/kernel/ptrace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 9556905bd3ce..d4c5e6ba8410 100644
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
2.0.4

