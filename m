Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbaHHWDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:03:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbaHHVgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 16/24] sparc64: Dont bark so loudly about 32-bit tasks generating 64-bit fault addresses.
Date: Fri,  8 Aug 2014 14:35:09 -0700
Message-Id: <20140808213336.086275592@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213335.421758947@linuxfoundation.org>
References: <20140808213335.421758947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/fault_64.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -280,18 +280,6 @@ static void noinline __kprobes bogus_32b
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
@@ -320,10 +308,8 @@ asmlinkage void __kprobes do_sparc64_fau
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


