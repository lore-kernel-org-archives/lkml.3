Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3BAK2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:28:12 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49197 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3BAK2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:28:05 -0500
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH 3/5] powerpc: Exit user context on notify resume
Date: Fri,  1 Feb 2013 18:27:43 +0800
Message-Id: <1359714465-6297-4-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359714465-6297-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1359714465-6297-1-git-send-email-zhong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020110-9574-0000-0000-0000066D67D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows RCU usage in do_notify_resume, e.g. signal handling.
It corresponds to
[PATCH] x86: Exit RCU extended QS on notify resume
  commit edf55fda35c7dc7f2d9241c3abaddaf759b457c6

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/signal.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 3b99711..c1eaea2 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -13,6 +13,7 @@
 #include <linux/signal.h>
 #include <linux/uprobes.h>
 #include <linux/key.h>
+#include <linux/context_tracking.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -158,6 +159,8 @@ static int do_signal(struct pt_regs *regs)
 
 void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 {
+	user_exit();
+
 	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
 
@@ -168,6 +171,8 @@ void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 	}
+
+	user_enter();
 }
 
 long sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
-- 
1.7.9.5

