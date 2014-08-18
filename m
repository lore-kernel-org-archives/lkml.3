Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaHRJmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:42:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43100 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaHRJgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 120/137] sparc64: Don't bark so loudly about 32-bit tasks generating 64-bit fault addresses.
Date: Mon, 18 Aug 2014 10:33:01 +0100
Message-Id: <1408354398-10226-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit e5c460f46ae7ee94831cb55cb980f942aa9e5a85 upstream.

This was found using Dave Jone's trinity tool.

When a user process which is 32-bit performs a load or a store, the
cpu chops off the top 32-bits of the effective address before
translating it.

This is because we run 32-bit tasks with the PSTATE_AM (address
masking) bit set.

We can't run the kernel with that bit set, so when the kernel accesses
userspace no address masking occurs.

Since a 32-bit process will have no mappings in that region we will
properly fault, so we don't try to handle this using access_ok(),
which can safely just be a NOP on sparc64.

Real faults from 32-bit processes should never generate such addresses
so a bug check was added long ago, and it barks in the logs if this
happens.

But it also barks when a kernel user access causes this condition, and
that _can_ happen.  For example, if a pointer passed into a system call
is "0xfffffffc" and the kernel access 4 bytes offset from that pointer.

Just handle such faults normally via the exception entries.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/mm/fault_64.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 1992fa04095f..ea83f82464da 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -280,18 +280,6 @@ static void noinline __kprobes bogus_32bit_fault_tpc(struct pt_regs *regs)
 	show_regs(regs);
 }
 
-static void noinline __kprobes bogus_32bit_fault_address(struct pt_regs *regs,
-							 unsigned long addr)
-{
-	static int times;
-
-	if (times++ < 10)
-		printk(KERN_ERR "FAULT[%s:%d]: 32-bit process "
-		       "reports 64-bit fault address [%lx]\n",
-		       current->comm, current->pid, addr);
-	show_regs(regs);
-}
-
 asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
 {
 	struct mm_struct *mm = current->mm;
@@ -320,10 +308,8 @@ asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
 				goto intr_or_no_mm;
 			}
 		}
-		if (unlikely((address >> 32) != 0)) {
-			bogus_32bit_fault_address(regs, address);
+		if (unlikely((address >> 32) != 0))
 			goto intr_or_no_mm;
-		}
 	}
 
 	if (regs->tstate & TSTATE_PRIV) {
-- 
1.9.1

