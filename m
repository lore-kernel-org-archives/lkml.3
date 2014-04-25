Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaDYRsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaDYRrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:47:48 -0400
Date: Fri, 25 Apr 2014 19:47:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] uprobes/x86: Introduce push_ret_address()
Message-ID: <20140425174724.GA7969@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425174704.GA7898@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the "push return address" code from branch_emulate_op() into
the new simple helper, push_ret_address(). It will have more users.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 37e73b6..48d2623 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -407,6 +407,17 @@ static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	return 0;
 }
 
+static int push_ret_address(struct pt_regs *regs, unsigned long ip)
+{
+	unsigned long new_sp = regs->sp - sizeof_long();
+
+	if (copy_to_user((void __user *)new_sp, &ip, sizeof_long()))
+		return -EFAULT;
+
+	regs->sp = new_sp;
+	return 0;
+}
+
 /*
  * Adjust the return address pushed by a call insn executed out of line.
  */
@@ -517,7 +528,6 @@ static bool branch_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	unsigned long offs = (long)auprobe->branch.offs;
 
 	if (branch_is_call(auprobe)) {
-		unsigned long new_sp = regs->sp - sizeof_long();
 		/*
 		 * If it fails we execute this (mangled, see the comment in
 		 * branch_clear_offset) insn out-of-line. In the likely case
@@ -527,9 +537,8 @@ static bool branch_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		 *
 		 * But there is corner case, see the comment in ->post_xol().
 		 */
-		if (copy_to_user((void __user *)new_sp, &new_ip, sizeof_long()))
+		if (push_ret_address(regs, new_ip))
 			return false;
-		regs->sp = new_sp;
 	} else if (!check_jmp_cond(auprobe, regs)) {
 		offs = 0;
 	}
-- 
1.5.5.1

