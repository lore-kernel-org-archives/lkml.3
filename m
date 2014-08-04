Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaHDRKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:10:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56508 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbaHDQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.485720857@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 66/94] s390/ptrace: fix PSW mask check
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---

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

