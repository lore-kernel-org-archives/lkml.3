Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaG3COO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:14:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbaG3BtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.4 08/10] s390/ptrace: fix PSW mask check
Date: Tue, 29 Jul 2014 18:48:39 -0700
Message-Id: <20140730014807.962378939@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014807.477761030@linuxfoundation.org>
References: <20140730014807.477761030@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit dab6cf55f81a6e16b8147aed9a843e1691dcd318 upstream.

The PSW mask check of the PTRACE_POKEUSR_AREA command is incorrect.
The PSW_MASK_USER define contains the PSW_MASK_ASC bits, the ptrace
interface accepts all combinations for the address-space-control
bits. To protect the kernel space the PSW mask check in ptrace needs
to reject the address-space-control bit combination for home space.

Fixes CVE-2014-3534

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/ptrace.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -292,7 +292,9 @@ static int __poke_user(struct task_struc
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
@@ -595,7 +597,10 @@ static int __poke_user_compat(struct tas
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


