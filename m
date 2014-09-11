Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaIKMgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:36:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51700 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472AbaIKMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.374878570@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 112/131] sparc64: Don't bark so loudly about 32-bit
 tasks  generating 64-bit fault addresses.
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit e5c460f46ae7ee94831cb55cb980f942aa9e5a85 ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/mm/fault_64.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 6ac702f..2c0b966 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -282,18 +282,6 @@ static void noinline __kprobes bogus_32bit_fault_tpc(struct pt_regs *regs)
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
@@ -321,10 +309,8 @@ asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
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

