Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3CKLDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:03:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54856 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3CKLDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:03:05 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v4][PATCH 6/7] powerpc/kgdb: use DEFINE_PER_CPU to allocate kgdb's thread_info
Date: Mon, 11 Mar 2013 19:02:45 +0800
Message-ID: <1362999766-20897-7-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362999766-20897-1-git-send-email-tiejun.chen@windriver.com>
References: <1362999766-20897-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DEFINE_PER_CPU to allocate thread_info statically instead of kmalloc().
This can avoid introducing more memory check codes.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/kgdb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 1a57307..cde7818 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -151,15 +151,15 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 	return 1;
 }
 
+static DEFINE_PER_CPU(struct thread_info, kgdb_thread_info);
 static int kgdb_singlestep(struct pt_regs *regs)
 {
 	struct thread_info *thread_info, *exception_thread_info;
-	struct thread_info *backup_current_thread_info;
+	struct thread_info *backup_current_thread_info = &__get_cpu_var(kgdb_thread_info);
 
 	if (user_mode(regs))
 		return 0;
 
-	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
 	/*
 	 * On Book E and perhaps other processors, singlestep is handled on
 	 * the critical exception stack.  This causes current_thread_info()
@@ -185,7 +185,6 @@ static int kgdb_singlestep(struct pt_regs *regs)
 		/* Restore current_thread_info lastly. */
 		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
 
-	kfree(backup_current_thread_info);
 	return 1;
 }
 
-- 
1.7.9.5

