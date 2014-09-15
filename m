Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbaIOXPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:15:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50563 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbaIOWLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 102/187] x86_64/vsyscall: Fix warn_bad_vsyscall log output
Date: Mon, 15 Sep 2014 15:08:32 -0700
Message-Id: <1410818997-9432-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 53b884ac3745353de220d92ef792515c3ae692f0 upstream.

This commit in Linux 3.6:

    commit c767a54ba0657e52e6edaa97cbe0b0a8bf1c1655
    Author: Joe Perches <joe@perches.com>
    Date:   Mon May 21 19:50:07 2012 -0700

        x86/debug: Add KERN_<LEVEL> to bare printks, convert printks to pr_<level>

caused warn_bad_vsyscall to output garbage in the middle of the
line.  Revert the bad part of it.

The printk in question isn't actually bare; the level is "%s".

The bug this fixes is purely cosmetic; backports are optional.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/03eac1f24110bbe496ecc12a4df467e0d88466d4.1406330947.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/vsyscall_64.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 1f96f93..09ce23a 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -125,10 +125,10 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
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
1.9.1

