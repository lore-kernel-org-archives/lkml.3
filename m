Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbaHHW1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:27:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbaHHUoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:44:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 164/259] s390/ptrace: fix PSW mask check
Date: Fri,  8 Aug 2014 13:39:47 -0700
Message-Id: <1407530482-4483-165-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kernel/ptrace.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index e65c91c..c5ff2f03 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -326,9 +326,14 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
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
@@ -664,9 +669,12 @@ static int __poke_user_compat(struct task_struct *child,
 
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
-- 
1.9.1

