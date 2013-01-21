Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3AUHpC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:45:02 -0500
Received: from mail.windriver.com ([147.11.1.11]:60907 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3AUHoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:44:34 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <jason.wessel@windriver.com>
Subject: [v2][PATCH 3/6] book3e/kgdb: update thread's dbcr0
Date: Mon, 21 Jan 2013 15:44:12 +0800
Message-ID: <1358754255-31484-4-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358754255-31484-1-git-send-email-tiejun.chen@windriver.com>
References: <1358754255-31484-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gdb always need to generate a single step properly to invoke
a kgdb state. But with lazy interrupt, book3e can't always
trigger a debug exception with a single step since the current
is blocked for handling those pending exception, then we miss
that expected dbcr configuration at last to generate a debug
exception.

So here we also update thread's dbcr0 to make sure the current
can go back with that missed dbcr0 configuration.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/kgdb.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 8747447..eb30a40 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -409,7 +409,7 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 			       struct pt_regs *linux_regs)
 {
 	char *ptr = &remcom_in_buffer[1];
-	unsigned long addr;
+	unsigned long addr, dbcr0;
 
 	switch (remcom_in_buffer[0]) {
 		/*
@@ -426,8 +426,15 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 		/* set the trace bit if we're stepping */
 		if (remcom_in_buffer[0] == 's') {
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-			mtspr(SPRN_DBCR0,
-			      mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM);
+			dbcr0 = mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM;
+			mtspr(SPRN_DBCR0, dbcr0);
+#ifdef CONFIG_PPC_BOOK3E_64
+			/* With lazy interrut we have to update thread dbcr0 here
+			 * to make sure we can set debug properly at last to invoke
+			 * kgdb again to work well.
+			 */
+			current->thread.dbcr0 = dbcr0;
+#endif
 			linux_regs->msr |= MSR_DE;
 #else
 			linux_regs->msr |= MSR_SE;
-- 
1.7.9.5

