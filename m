Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3EMFWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:22:48 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43397 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3EMFWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:22:03 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        michael@ellerman.id.au, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 3/5] powerpc: Exit user context on notify resume
Date: Mon, 13 May 2013 13:21:31 +0800
Message-Id: <1368422493-9831-4-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051305-9264-0000-0000-000003BBE0EC
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
index cf12eae..d63b502 100644
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
@@ -159,6 +160,8 @@ static int do_signal(struct pt_regs *regs)
 
 void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 {
+	user_exit();
+
 	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
 
@@ -169,4 +172,6 @@ void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 	}
+
+	user_enter();
 }
-- 
1.7.9.5

