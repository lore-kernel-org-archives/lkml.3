Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaGYXg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:36:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47162 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaGYXg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:36:56 -0400
Date: Fri, 25 Jul 2014 16:36:44 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-53b884ac3745353de220d92ef792515c3ae692f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <03eac1f24110bbe496ecc12a4df467e0d88466d4.1406330947.git.luto@amacapital.net>
References: <03eac1f24110bbe496ecc12a4df467e0d88466d4.1406330947.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64/vsyscall: Fix warn_bad_vsyscall log output
Git-Commit-ID: 53b884ac3745353de220d92ef792515c3ae692f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53b884ac3745353de220d92ef792515c3ae692f0
Gitweb:     http://git.kernel.org/tip/53b884ac3745353de220d92ef792515c3ae692f0
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 25 Jul 2014 16:30:27 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 25 Jul 2014 16:34:15 -0700

x86_64/vsyscall: Fix warn_bad_vsyscall log output

This commit in Linux 3.6:

    commit c767a54ba0657e52e6edaa97cbe0b0a8bf1c1655
    Author: Joe Perches <joe@perches.com>
    Date:   Mon May 21 19:50:07 2012 -0700

        x86/debug: Add KERN_<LEVEL> to bare printks, convert printks to pr_<level>

caused warn_bad_vsyscall to output garbage in the middle of the
line.  Revert the bad part of it.

The printk in question isn't actually bare; the level is "%s".

The bug this fixes is purely cosmetic; backports are optional.

Cc: <stable@vger.kernel.org> # v3.6+
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/03eac1f24110bbe496ecc12a4df467e0d88466d4.1406330947.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
