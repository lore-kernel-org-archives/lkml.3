Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbaG3CDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:03:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbaG3Btt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.14 10/29] s390/ptrace: fix PSW mask check
Date: Tue, 29 Jul 2014 18:48:45 -0700
Message-Id: <20140730014809.756830943@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/ptrace.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -323,9 +323,14 @@ static int __poke_user(struct task_struc
 			unsigned long mask = PSW_MASK_USER;
 
 			mask |= is_ri_task(child) ? PSW_MASK_RI : 0;
-			if ((data & ~mask) != PSW_USER_BITS)
+			if ((data ^ PSW_USER_BITS) & ~mask)
+				/* Invalid psw mask. */
+				return -EINVAL;
+			if ((data & PSW_MASK_ASC) == PSW_ASC_HOME)
+				/* Invalid address-space-control bits */
 				return -EINVAL;
 			if ((data & PSW_MASK_EA) && !(data & PSW_MASK_BA))
+				/* Invalid addressing mode bits */
 				return -EINVAL;
 		}
 		*(addr_t *)((addr_t) &task_pt_regs(child)->psw + addr) = data;
@@ -661,9 +666,12 @@ static int __poke_user_compat(struct tas
 
 			mask |= is_ri_task(child) ? PSW32_MASK_RI : 0;
 			/* Build a 64 bit psw mask from 31 bit mask. */
-			if ((tmp & ~mask) != PSW32_USER_BITS)
+			if ((tmp ^ PSW32_USER_BITS) & ~mask)
 				/* Invalid psw mask. */
 				return -EINVAL;
+			if ((data & PSW32_MASK_ASC) == PSW32_ASC_HOME)
+				/* Invalid address-space-control bits */
+				return -EINVAL;
 			regs->psw.mask = (regs->psw.mask & ~PSW_MASK_USER) |
 				(regs->psw.mask & PSW_MASK_BA) |
 				(__u64)(tmp & mask) << 32;


