Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3ANR0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:26:43 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:40852 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab3ANR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:26:42 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Michael Neuling <mikey@neuling.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] powerpc: kernel/kgdb.c: fix memory leakage
Date: Mon, 14 Jan 2013 17:26:32 +0000
Message-Id: <1358184395-31418-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable backup_current_thread_info isn't freed before existing the
function.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/powerpc/kernel/kgdb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 8747447..5ca82cd 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -154,12 +154,12 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 static int kgdb_singlestep(struct pt_regs *regs)
 {
 	struct thread_info *thread_info, *exception_thread_info;
-	struct thread_info *backup_current_thread_info = \
-		(struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
+	struct thread_info *backup_current_thread_info;
 
 	if (user_mode(regs))
 		return 0;
 
+	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
 	/*
 	 * On Book E and perhaps other processors, singlestep is handled on
 	 * the critical exception stack.  This causes current_thread_info()
@@ -185,6 +185,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
 		/* Restore current_thread_info lastly. */
 		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
 
+	kfree(backup_current_thread_info);
 	return 1;
 }
 
-- 
1.7.9.5

