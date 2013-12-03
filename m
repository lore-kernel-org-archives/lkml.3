Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3LCNWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:22:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab3LCNWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:22:40 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v5 2/8] x86: allow to call text_poke_bp during boot
Date: Tue,  3 Dec 2013 14:21:21 +0100
Message-Id: <1386076887-2655-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
References: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to use text_poke_bp in ftrace. It might be called also during
boot when there is only one CPU and we do not need to sync the others.

The check is must to have because there are also disabled interrupts during
the boot. Then the call would cause a deadlock, see the warning in
"smp_call_function_many", kernel/smp.c:371.

The change is inspired by the code in arch/x86/kernel/ftrace.c.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/kernel/alternative.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 10a7ec0c66f9..2e47107b9055 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -602,6 +602,17 @@ static void do_sync_core(void *info)
 	sync_core();
 }
 
+static void run_sync(void)
+{
+	/*
+	 * We do not need to sync other cores during boot when there is only one
+	 * CPU enabled. In fact, we must not because there are also disabled
+	 * interrupts. The call would fail because of a potential deadlock.
+	 */
+	if (num_online_cpus() != 1)
+		on_each_cpu(do_sync_core, NULL, 1);
+}
+
 static bool bp_patching_in_progress;
 static void *bp_int3_handler, *bp_int3_addr;
 
@@ -664,7 +675,7 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	if (unlikely(ret))
 		goto fail;
 
-	on_each_cpu(do_sync_core, NULL, 1);
+	run_sync();
 
 	if (len - sizeof(int3) > 0) {
 		/* patch all but the first byte */
@@ -677,14 +688,14 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 		 * not necessary and we'd be safe even without it. But
 		 * better safe than sorry (plus there's not only Intel).
 		 */
-		on_each_cpu(do_sync_core, NULL, 1);
+		run_sync();
 	}
 
 	/* patch the first byte */
 	ret = text_poke(addr, opcode, sizeof(int3));
 	BUG_ON(ret);
 
-	on_each_cpu(do_sync_core, NULL, 1);
+	run_sync();
 
 fail:
 	bp_patching_in_progress = false;
-- 
1.8.4

