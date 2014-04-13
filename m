Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaDMRqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:46:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbaDMRqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:46:04 -0400
Date: Sun, 13 Apr 2014 19:45:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/15] uprobes/x86: Introduce sizeof_long(), cleanup
	adjust_ret_addr() and arch_uretprobe_hijack_return_addr()
Message-ID: <20140413174556.GA11878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413174508.GA11811@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Add the trivial sizeof_long() helper and change other callers of
   is_ia32_task() to use it.

   TODO: is_ia32_task() is not what we actually want, TS_COMPAT does
   not necessarily mean 32bit. Fortunately syscall-like insns can't be
   probed so it actually works, but it would be better to rename and
   use is_ia32_frame().

2. As Jim pointed out "ncopied" in arch_uretprobe_hijack_return_addr()
   and adjust_ret_addr() should be named "nleft". And in fact only the
   last copy_to_user() in arch_uretprobe_hijack_return_addr() actually
   needs to inspect the non-zero error code.

TODO: adjust_ret_addr() should die. We can always calculate the value
we need to write into *regs->sp, just UPROBE_FIX_CALL should record
insn->length.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/x86/kernel/uprobes.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 1ea7e1a..ef59ef9 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -408,6 +408,11 @@ struct uprobe_xol_ops {
 	int	(*post_xol)(struct arch_uprobe *, struct pt_regs *);
 };
 
+static inline int sizeof_long(void)
+{
+	return is_ia32_task() ? 4 : 8;
+}
+
 static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	pre_xol_rip_insn(auprobe, regs, &current->utask->autask);
@@ -419,21 +424,14 @@ static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
  */
 static int adjust_ret_addr(unsigned long sp, long correction)
 {
-	int rasize, ncopied;
-	long ra = 0;
-
-	if (is_ia32_task())
-		rasize = 4;
-	else
-		rasize = 8;
+	int rasize = sizeof_long();
+	long ra;
 
-	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
-	if (unlikely(ncopied))
+	if (copy_from_user(&ra, (void __user *)sp, rasize))
 		return -EFAULT;
 
 	ra += correction;
-	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
-	if (unlikely(ncopied))
+	if (copy_to_user((void __user *)sp, &ra, rasize))
 		return -EFAULT;
 
 	return 0;
@@ -450,10 +448,7 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 
 	if (auprobe->fixups & UPROBE_FIX_CALL) {
 		if (adjust_ret_addr(regs->sp, correction)) {
-			if (is_ia32_task())
-				regs->sp += 4;
-			else
-				regs->sp += 8;
+			regs->sp += sizeof_long();
 			return -ERESTART;
 		}
 	}
@@ -716,23 +711,21 @@ if (ret) pr_crit("EMULATE: %lx -> %lx\n", ip, regs->ip);
 unsigned long
 arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
 {
-	int rasize, ncopied;
+	int rasize = sizeof_long(), nleft;
 	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
 
-	rasize = is_ia32_task() ? 4 : 8;
-	ncopied = copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize);
-	if (unlikely(ncopied))
+	if (copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize))
 		return -1;
 
 	/* check whether address has been already hijacked */
 	if (orig_ret_vaddr == trampoline_vaddr)
 		return orig_ret_vaddr;
 
-	ncopied = copy_to_user((void __user *)regs->sp, &trampoline_vaddr, rasize);
-	if (likely(!ncopied))
+	nleft = copy_to_user((void __user *)regs->sp, &trampoline_vaddr, rasize);
+	if (likely(!nleft))
 		return orig_ret_vaddr;
 
-	if (ncopied != rasize) {
+	if (nleft != rasize) {
 		pr_err("uprobe: return address clobbered: pid=%d, %%sp=%#lx, "
 			"%%ip=%#lx\n", current->pid, regs->sp, regs->ip);
 
-- 
1.5.5.1

