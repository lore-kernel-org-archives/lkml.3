Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaE1N0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:26:41 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:50469 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaE1N0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:26:40 -0400
X-Greylist: delayed 4006 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2014 09:26:39 EDT
From: Philipp Kern <pkern@google.com>
To: hpa@linux.intel.com
Cc: Philipp Kern <pkern@google.com>, linux-kernel@vger.kernel.org,
        "H. J. Lu" <hjl.tools@gmail.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH] x32: Mask away the x32 syscall bit in the ptrace codepath
Date: Wed, 28 May 2014 14:19:43 +0200
Message-Id: <1401279583-1027-1-git-send-email-pkern@google.com>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_filter_syscall uses the syscall number to reference into a
bitmask (e->rule.mask[word]). Not removing the x32 bit before passing
the number to this architecture independent codepath will fail to
lookup the proper audit bit. Furthermore it will cause an invalid memory
access in the kernel if the out of bound location is not mapped:

  BUG: unable to handle kernel paging request at ffff8800e5446630
  IP: [<ffffffff810fcdd0>] audit_filter_syscall+0x90/0xf0

Together with the entrypoint in entry_64.S this change causes x32
programs to pass in both AUDIT_ARCH_X86_64 and AUDIT_ARCH_I386 depending
on the syscall path.

Cc: linux-kernel@vger.kernel.org
Cc: H. J. Lu <hjl.tools@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Philipp Kern <pkern@google.com>
---
 arch/x86/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 678c0ad..166a3c7 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1489,7 +1489,7 @@ long syscall_trace_enter(struct pt_regs *regs)
 
 	if (IS_IA32)
 		audit_syscall_entry(AUDIT_ARCH_I386,
-				    regs->orig_ax,
+				    regs->orig_ax & __SYSCALL_MASK,
 				    regs->bx, regs->cx,
 				    regs->dx, regs->si);
 #ifdef CONFIG_X86_64
-- 
1.9.1.423.g4596e3a

