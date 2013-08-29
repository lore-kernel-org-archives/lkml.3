Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3H2EJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 00:09:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:58176 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab3H2EJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 00:09:26 -0400
X-Spam-Score: -101.0
Message-ID: <521EC935.90200@asianux.com>
Date: Thu, 29 Aug 2013 12:08:21 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300: kernel: ptrace: remove redundancy default user_disable_single_step()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platform h8300h and h8s, user_disable_single_step() is already
defined, it is conflict with the default one in h8300.

The public header already defined the default implementation, so in
h8300, need not define the default one.

The related error (defconfig for h8300h):

    LD      vmlinux.o
  arch/h8300/platform/h8300h/built-in.o: In function `user_disable_single_step':
  arch/h8300/platform/h8300h/ptrace_h8300h.c:65: multiple definition of `user_disable_single_step'
  arch/h8300/kernel/built-in.o: arch/h8300/kernel/ptrace.c:39: first defined here
  /usr/local/bin/h8300-gchen-elf-ld: Warning: size of symbol `_user_disable_single_step' changed from 2 in arch/h8300/kernel/built-in.o to 30 in arch/h8300/platform/h8300h/built-in.o


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/include/asm/ptrace.h |    2 ++
 arch/h8300/kernel/ptrace.c      |    5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/h8300/include/asm/ptrace.h b/arch/h8300/include/asm/ptrace.h
index c1826b9..dd887e9 100644
--- a/arch/h8300/include/asm/ptrace.h
+++ b/arch/h8300/include/asm/ptrace.h
@@ -20,7 +20,9 @@
 /* Find the stack offset for a register, relative to thread.esp0. */
 #define PT_REG(reg)	((long)&((struct pt_regs *)0)->reg)
 
+#if defined(__H8300H__) || defined(__H8300S__)
 #define arch_has_single_step()	(1)
+#endif
 
 #define user_mode(regs) (!((regs)->ccr & PS_S))
 #define instruction_pointer(regs) ((regs)->pc)
diff --git a/arch/h8300/kernel/ptrace.c b/arch/h8300/kernel/ptrace.c
index 748cf65..82ec3b6 100644
--- a/arch/h8300/kernel/ptrace.c
+++ b/arch/h8300/kernel/ptrace.c
@@ -34,11 +34,6 @@
 extern long h8300_get_reg(struct task_struct *task, int regno);
 extern int  h8300_put_reg(struct task_struct *task, int regno, unsigned long data);
 
-
-void user_disable_single_step(struct task_struct *child)
-{
-}
-
 /*
  * does not yet catch signals sent when the child dies.
  * in exit.c or in signal.c.
-- 
1.7.7.6
