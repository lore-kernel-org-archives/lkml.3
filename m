Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaEZL7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:59:37 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34889 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaEZL7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:59:36 -0400
X-Greylist: delayed 1179 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2014 07:59:36 EDT
From: Philipp Kern <pkern@google.com>
To: hpa@linux.intel.com
Cc: Philipp Kern <pkern@google.com>, linux-kernel@vger.kernel.org,
        "H. J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH] x32: Mask the syscall number before passing it to audit
Date: Mon, 26 May 2014 13:31:38 +0200
Message-Id: <1401103898-29554-1-git-send-email-pkern@google.com>
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

Cc: linux-kernel@vger.kernel.org
Cc: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: Philipp Kern <pkern@google.com>
---
 arch/x86/kernel/entry_64.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..c9aaf60 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -699,6 +699,9 @@ auditsys:
 	movq %rsi,%rcx			/* 4th arg: 2nd syscall arg */
 	movq %rdi,%rdx			/* 3rd arg: 1st syscall arg */
 	movq %rax,%rsi			/* 2nd arg: syscall number */
+#if __SYSCALL_MASK != ~0
+	andl $__SYSCALL_MASK,%esi
+#endif
 	movl $AUDIT_ARCH_X86_64,%edi	/* 1st arg: audit arch */
 	call __audit_syscall_entry
 	LOAD_ARGS 0		/* reload call-clobbered registers */
-- 
1.9.1.423.g4596e3a

