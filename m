Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaICJ5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:57:23 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57397 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932206AbaICJ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 53/56] x86_64/vsyscall: Fix warn_bad_vsyscall log output
Date: Wed,  3 Sep 2014 11:27:12 +0200
Message-Id: <c5c26d99320cd5ee2b9544e2eb89b8109d2d65de.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/vsyscall_64.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 1f96f9347ed9..09ce23ae370c 100644
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
2.1.0

