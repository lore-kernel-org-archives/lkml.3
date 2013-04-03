Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763305Ab3DCTQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:16:47 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:35163 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763293Ab3DCTQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:16:42 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org
Cc: rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/7] arc, print-fatal-signals: reduce duplicated information
Date: Wed,  3 Apr 2013 12:14:57 -0700
Message-Id: <1365016497-32033-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365016497-32033-1-git-send-email-tj@kernel.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

After the recent generic debug info on dump_stack() and friends, arc
is printing duplicate information on debug dumps.

 [ARCLinux]$ ./crash
 crash/50: potentially unexpected fatal signal 11.	<-- [1]
 /sbin/crash, TGID 50					<-- [2]
 Pid: 50, comm: crash Not tainted 3.9.0-rc4+ #132 	<-- [3]
 ...

Remove them.

tj: Updated patch desc.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/arc/kernel/troubleshoot.c | 2 +-
 kernel/signal.c                | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
index 158bbeb..39bbf58 100644
--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -75,7 +75,7 @@ void print_task_path_n_nm(struct task_struct *tsk, char *buf)
 	}
 
 done:
-	pr_info("%s, TGID %u\n", path_nm, tsk->tgid);
+	pr_info("Path: %s\n", path_nm);
 }
 EXPORT_SYMBOL(print_task_path_n_nm);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index bb7ca79..92139dc 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1163,8 +1163,7 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
-	printk(KERN_INFO "%s/%d: potentially unexpected fatal signal %d.\n",
-		current->comm, task_pid_nr(current), signr);
+	printk(KERN_INFO "potentially unexpected fatal signal %d.\n", signr);
 
 #if defined(__i386__) && !defined(__arch_um__)
 	printk(KERN_INFO "code at %08lx: ", regs->ip);
-- 
1.8.1.4

