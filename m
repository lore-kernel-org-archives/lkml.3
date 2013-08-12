Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab3HLQPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:15:47 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:58855 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3HLQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:15:46 -0400
Message-ID: <201308121615.r7CGFiif024699@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Aug 2013 11:22:43 -0400
Subject: [PATCH] tile: don't call show_regs_print_info() with corrupt current
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the validate_current() API to make sure that "current" seems
plausible before using it.  With the new show_regs_print_info()
API, we want to check that current is OK before calling it, since
otherwise we will end up in a recursive panic.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/process.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 663289b..44cdc4a 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -226,19 +226,20 @@ int get_unalign_ctl(struct task_struct *tsk, unsigned long adr)
 			(unsigned int __user *)adr);
 }
 
+static struct task_struct corrupt_current = { .comm = "<corrupt>" };
+
 /*
  * Return "current" if it looks plausible, or else a pointer to a dummy.
  * This can be helpful if we are just trying to emit a clean panic.
  */
 struct task_struct *validate_current(void)
 {
-	static struct task_struct corrupt = { .comm = "<corrupt>" };
 	struct task_struct *tsk = current;
 	if (unlikely((unsigned long)tsk < PAGE_OFFSET ||
 		     (high_memory && (void *)tsk > high_memory) ||
 		     ((unsigned long)tsk & (__alignof__(*tsk) - 1)) != 0)) {
 		pr_err("Corrupt 'current' %p (sp %#lx)\n", tsk, stack_pointer);
-		tsk = &corrupt;
+		tsk = &corrupt_current;
 	}
 	return tsk;
 }
@@ -589,7 +590,8 @@ void show_regs(struct pt_regs *regs)
 	int i;
 
 	pr_err("\n");
-	show_regs_print_info(KERN_ERR);
+	if (tsk != &corrupt_current)
+		show_regs_print_info(KERN_ERR);
 #ifdef __tilegx__
 	for (i = 0; i < 17; i++)
 		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
-- 
1.8.3.1

