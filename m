Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaDQIRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:17:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40779 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbaDQIRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:17:34 -0400
Subject: [PATCH -tip v9 07/26] [BUGFIX] x86: Prohibit probing on thunk
 functions and restore
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Apr 2014 17:17:26 +0900
Message-ID: <20140417081726.26341.3872.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thunk/restore functions are also used for tracing irqoff etc.
and those are involved in kprobe's exception handling.
Prohibit probing on them to avoid kernel crash.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/lib/thunk_32.S |    3 ++-
 arch/x86/lib/thunk_64.S |    3 +++
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


