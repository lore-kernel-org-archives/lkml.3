Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304Ab3LIK4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:56:38 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58217 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab3LIKxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:53:15 -0500
Subject: [PATCH -tip v5 05/18] [BUGFIX] x86: Prohibit probing on thunk
 functions and restore
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Dec 2013 10:47:30 +0000
Message-ID: <20131209104730.13397.70208.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
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


