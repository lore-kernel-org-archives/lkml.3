Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaDXLAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:00:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52960 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaDXLAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:00:45 -0400
Date: Thu, 24 Apr 2014 04:00:11 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-9c54b6164eeb292a0eac86c6913bd8daaff35e62@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, oleg@redhat.com, tglx@linutronix.de,
        bp@suse.de, fengguang.wu@intel.com, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com,
        fengguang.wu@intel.com, bp@suse.de, paul.gortmaker@windriver.com
In-Reply-To: <20140417081807.26341.73219.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081807.26341.73219.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/kprobes] kprobes, x86: Allow kprobes on text_poke/
 hw_breakpoint
Git-Commit-ID: 9c54b6164eeb292a0eac86c6913bd8daaff35e62
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

Commit-ID:  9c54b6164eeb292a0eac86c6913bd8daaff35e62
Gitweb:     http://git.kernel.org/tip/9c54b6164eeb292a0eac86c6913bd8daaff35e62
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Apr 2014 17:18:07 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 10:03:02 +0200

kprobes, x86: Allow kprobes on text_poke/hw_breakpoint

Allow kprobes on text_poke/hw_breakpoint because
those are not related to the critical int3-debug
recursive path of kprobes at this moment.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Link: http://lkml.kernel.org/r/20140417081807.26341.73219.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/alternative.c   | 3 +--
 arch/x86/kernel/hw_breakpoint.c | 5 ++---
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
