Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaL3HwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 02:52:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:34758 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaL3HwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 02:52:07 -0500
From: <zhe.he@windriver.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <jason.wessel@windriver.com>,
        <paul.gortmaker@windriver.com>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 1/1] x86, kgdb: correct kgdb_arch_remove_breakpoint
Date: Tue, 30 Dec 2014 15:50:07 +0800
Message-ID: <1419925807-31808-1-git-send-email-zhe.he@windriver.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

On 3.19-rc2, kgdbts boot time test fails with default parameter V1F100
"KGDB: BP remove failed: ffffffff81049070"
Then system is hanged.

When CONFIG_DEBUG_RODATA is on, kgdb_arch_set_breakpoint firstly tries
probe_kernel_write to set breakpoints and mark their type as BP_BREAKPOINT. If
fails it would use text_poke and mark their type as BP_POKE_BREAKPOINT.

On the other hand, kgdb_arch_remove_breakpoint uses probe_kernel_write to delete
breakpoints if they are BP_BREAKPOINT, or uses text_poke if they are
BP_POKE_BREAKPOINT.

The kgdbts' boot time test case loops for do_fork and/or sys_open may run
through initialization. During this procedure, the read only area is created. If
a breakpoint is marked as BP_BREAKPOINT before creating read only area and then
its address is put into that area, it would fail to be deleted due to
kgdb_arch_remove_breakpoint would use wrong function.

This patch:
 - Make kgdb_arch_remove_breakpoint work like kgdb_arch_set_breakpoint, trying
probe_kernel_write first then trying text_poke if fails.
 - Remove BP_POKE_BREAKPOINT as it is only used in these two functions.

Signed-off-by: He Zhe <zhe.he@windriver.com>
---
 arch/x86/kernel/kgdb.c | 25 +++++++++++++------------
 include/linux/kgdb.h   |  1 -
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 7ec1d5f..f5f7772 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -749,7 +749,6 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 	char opc[BREAK_INSTR_SIZE];
 #endif /* CONFIG_DEBUG_RODATA */
 
-	bpt->type = BP_BREAKPOINT;
 	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
 				BREAK_INSTR_SIZE);
 	if (err)
@@ -772,34 +771,36 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 		return err;
 	if (memcmp(opc, arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE))
 		return -EINVAL;
-	bpt->type = BP_POKE_BREAKPOINT;
 #endif /* CONFIG_DEBUG_RODATA */
 	return err;
 }
 
 int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 {
-#ifdef CONFIG_DEBUG_RODATA
 	int err;
+#ifdef CONFIG_DEBUG_RODATA
 	char opc[BREAK_INSTR_SIZE];
+#endif /* CONFIG_DEBUG_RODATA */
 
-	if (bpt->type != BP_POKE_BREAKPOINT)
-		goto knl_write;
+	err = probe_kernel_write((char *)bpt->bpt_addr,
+				 (char *)bpt->saved_instr, BREAK_INSTR_SIZE);
+#ifdef CONFIG_DEBUG_RODATA
+	if (!err)
+		return err;
 	/*
 	 * It is safe to call text_poke() because normal kernel execution
 	 * is stopped on all cores, so long as the text_mutex is not locked.
 	 */
 	if (mutex_is_locked(&text_mutex))
-		goto knl_write;
+		return -EBUSY;
 	text_poke((void *)bpt->bpt_addr, bpt->saved_instr, BREAK_INSTR_SIZE);
 	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
-	if (err || memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
-		goto knl_write;
-	return err;
-knl_write:
+	if (err)
+		return err;
+	if (memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
+		return -EINVAL;
 #endif /* CONFIG_DEBUG_RODATA */
-	return probe_kernel_write((char *)bpt->bpt_addr,
-				  (char *)bpt->saved_instr, BREAK_INSTR_SIZE);
+	return err;
 }
 
 struct kgdb_arch arch_kgdb_ops = {
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index fc513db..cded3c75 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -63,7 +63,6 @@ enum kgdb_bptype {
 	BP_WRITE_WATCHPOINT,
 	BP_READ_WATCHPOINT,
 	BP_ACCESS_WATCHPOINT,
-	BP_POKE_BREAKPOINT,
 };
 
 enum kgdb_bpstate {
-- 
1.8.3.1

