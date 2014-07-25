Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaGYXae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:30:34 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39341 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaGYXac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:30:32 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: [PATCH] x86_64,vsyscall: Fix warn_bad_vsyscall log output
Date: Fri, 25 Jul 2014 16:30:27 -0700
Message-Id: <03eac1f24110bbe496ecc12a4df467e0d88466d4.1406330947.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit in Linux 3.6:

    commit c767a54ba0657e52e6edaa97cbe0b0a8bf1c1655
    Author: Joe Perches <joe@perches.com>
    Date:   Mon May 21 19:50:07 2012 -0700

        x86/debug: Add KERN_<LEVEL> to bare printks, convert printks to pr_<level>

caused warn_bad_vsyscall to output garbage in the middle of the
line.  Revert the bad part of it.

The printk in question isn't actually bare; the level is "%s".

The bug this fixes is purely cosmetic; backports are optional.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/vsyscall_64.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index ea5b570..e1e1e80 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -81,10 +81,10 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 	if (!show_unhandled_signals)
 		return;
 
-	pr_notice_ratelimited("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
-			      level, current->comm, task_pid_nr(current),
-			      message, regs->ip, regs->cs,
-			      regs->sp, regs->ax, regs->si, regs->di);
+	printk_ratelimited("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+			   level, current->comm, task_pid_nr(current),
+			   message, regs->ip, regs->cs,
+			   regs->sp, regs->ax, regs->si, regs->di);
 }
 
 static int addr_to_vsyscall_nr(unsigned long addr)
-- 
1.9.3

