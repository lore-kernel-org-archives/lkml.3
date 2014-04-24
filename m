Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaDXK7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:59:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbaDXK7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:59:10 -0400
Date: Thu, 24 Apr 2014 03:58:53 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-98def1dedd00f42ded8423c418c971751f46aad2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <20140417081726.26341.3872.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081726.26341.3872.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/kprobes] kprobes, x86:
  Prohibit probing on thunk functions and restore
Git-Commit-ID: 98def1dedd00f42ded8423c418c971751f46aad2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98def1dedd00f42ded8423c418c971751f46aad2
Gitweb:     http://git.kernel.org/tip/98def1dedd00f42ded8423c418c971751f46aad2
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Apr 2014 17:17:26 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 10:02:58 +0200

kprobes, x86: Prohibit probing on thunk functions and restore

thunk/restore functions are also used for tracing irqoff etc.
and those are involved in kprobe's exception handling.
Prohibit probing on them to avoid kernel crash.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140417081726.26341.3872.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/lib/thunk_32.S | 3 ++-
 arch/x86/lib/thunk_64.S | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
index 2930ae0..28f85c91 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -4,8 +4,8 @@
  *  (inspired by Andi Kleen's thunk_64.S)
  * Subject to the GNU public license, v.2. No warranty of any kind.
  */
-
 	#include <linux/linkage.h>
+	#include <asm/asm.h>
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in eax (arg1) */
@@ -22,6 +22,7 @@
 	popl %ecx
 	popl %eax
 	ret
+	_ASM_NOKPROBE(\name)
 	.endm
 
 	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index a63efd6..92d9fea 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -8,6 +8,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/calling.h>
+#include <asm/asm.h>
 
 	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
 	.macro THUNK name, func, put_ret_addr_in_rdi=0
@@ -25,6 +26,7 @@
 	call \func
 	jmp  restore
 	CFI_ENDPROC
+	_ASM_NOKPROBE(\name)
 	.endm
 
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -43,3 +45,4 @@ restore:
 	RESTORE_ARGS
 	ret
 	CFI_ENDPROC
+	_ASM_NOKPROBE(restore)
