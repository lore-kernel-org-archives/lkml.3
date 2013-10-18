Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3JRO1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:27:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab3JRO1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:27:30 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 2/6] x86: allow to call text_poke_bp during boot
Date: Fri, 18 Oct 2013 16:27:21 +0200
Message-Id: <1382106445-31468-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to use text_poke_bp in ftrace. It might be called also during
boot when the interupts are disabled. We need to enable them for syncing
the cores on each CPU. Otherwise, there might be a deadlock, see the
warning in "smp_call_function_many", kernel/smp.c:371.

This change is taken from the current code in arch/x86/kernel/ftrace.c.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/alternative.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f714316..13cae15 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -629,6 +629,20 @@ static void do_sync_core(void *info)
 	sync_core();
 }
 
+static void run_sync(void)
+{
+	int enable_irqs = irqs_disabled();
+
+	/* We may be called with interrupts disbled (on bootup). */
+	if (enable_irqs)
+		local_irq_enable();
+
+	on_each_cpu(do_sync_core, NULL, 1);
+
+	if (enable_irqs)
+		local_irq_disable();
+}
+
 static bool bp_patching_in_progress;
 static void *bp_int3_handler, *bp_int3_addr;
 
@@ -688,7 +702,7 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 
 	text_poke_part(addr, &int3, sizeof(int3));
 
-	on_each_cpu(do_sync_core, NULL, 1);
+	run_sync();
 
 	if (len - sizeof(int3) > 0) {
 		/* patch all but the first byte */
@@ -700,13 +714,13 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 		 * not necessary and we'd be safe even without it. But
 		 * better safe than sorry (plus there's not only Intel).
 		 */
-		on_each_cpu(do_sync_core, NULL, 1);
+		run_sync();
 	}
 
 	/* patch the first byte */
 	text_poke_part(addr, opcode, sizeof(int3));
 
-	on_each_cpu(do_sync_core, NULL, 1);
+	run_sync();
 
 	bp_patching_in_progress = false;
 	smp_wmb();
-- 
1.8.4

