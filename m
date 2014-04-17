Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161000AbaDQIST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:18:19 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33440 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaDQISP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:18:15 -0400
Subject: [PATCH -tip v9 13/26] x86: Allow kprobes on text_poke/hw_breakpoint
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Apr 2014 17:18:07 +0900
Message-ID: <20140417081807.26341.73219.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow kprobes on text_poke/hw_breakpoint because
those are not related to the critical int3-debug
recursive path of kprobes at this moment.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/alternative.c   |    3 +--
 arch/x86/kernel/hw_breakpoint.c |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df94598..703130f 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -5,7 +5,6 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/stringify.h>
-#include <linux/kprobes.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
@@ -551,7 +550,7 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
  *
  * Note: Must be called under text_mutex.
  */
-void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
+void *text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
 	char *vaddr;
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index a67b47c..5f9cf20 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -32,7 +32,6 @@
 #include <linux/irqflags.h>
 #include <linux/notifier.h>
 #include <linux/kallsyms.h>
-#include <linux/kprobes.h>
 #include <linux/percpu.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
@@ -424,7 +423,7 @@ EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
  * NOTIFY_STOP returned for all other cases
  *
  */
-static int __kprobes hw_breakpoint_handler(struct die_args *args)
+static int hw_breakpoint_handler(struct die_args *args)
 {
 	int i, cpu, rc = NOTIFY_STOP;
 	struct perf_event *bp;
@@ -511,7 +510,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 /*
  * Handle debug exception notifications.
  */
-int __kprobes hw_breakpoint_exceptions_notify(
+int hw_breakpoint_exceptions_notify(
 		struct notifier_block *unused, unsigned long val, void *data)
 {
 	if (val != DIE_DEBUG)


