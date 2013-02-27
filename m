Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028Ab3B0DJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:09:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:44511 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760010Ab3B0DJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:09:48 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [v3][PATCH 6/6] powerpc/kgdb: remove copying the thread_info
Date: Wed, 27 Feb 2013 11:09:28 +0800
Message-ID: <1361934568-31989-7-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361934568-31989-1-git-send-email-tiejun.chen@windriver.com>
References: <1361934568-31989-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently BookE and Book3E always copy the thread_info from
the kernel stack when we enter the debug exception, so we can
remove these action here to avoid copying again.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/kgdb.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 1a57307..e954888 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -153,39 +153,11 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 
 static int kgdb_singlestep(struct pt_regs *regs)
 {
-	struct thread_info *thread_info, *exception_thread_info;
-	struct thread_info *backup_current_thread_info;
-
 	if (user_mode(regs))
 		return 0;
 
-	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
-	/*
-	 * On Book E and perhaps other processors, singlestep is handled on
-	 * the critical exception stack.  This causes current_thread_info()
-	 * to fail, since it it locates the thread_info by masking off
-	 * the low bits of the current stack pointer.  We work around
-	 * this issue by copying the thread_info from the kernel stack
-	 * before calling kgdb_handle_exception, and copying it back
-	 * afterwards.  On most processors the copy is avoided since
-	 * exception_thread_info == thread_info.
-	 */
-	thread_info = (struct thread_info *)(regs->gpr[1] & ~(THREAD_SIZE-1));
-	exception_thread_info = current_thread_info();
-
-	if (thread_info != exception_thread_info) {
-		/* Save the original current_thread_info. */
-		memcpy(backup_current_thread_info, exception_thread_info, sizeof *thread_info);
-		memcpy(exception_thread_info, thread_info, sizeof *thread_info);
-	}
-
 	kgdb_handle_exception(0, SIGTRAP, 0, regs);
 
-	if (thread_info != exception_thread_info)
-		/* Restore current_thread_info lastly. */
-		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
-
-	kfree(backup_current_thread_info);
 	return 1;
 }
 
-- 
1.7.9.5

