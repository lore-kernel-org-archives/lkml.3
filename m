Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaDVOsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:48:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946AbaDVOr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:47:57 -0400
Date: Tue, 22 Apr 2014 16:47:39 +0200
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
Subject: [PATCH 1/5] uprobes/x86: Don't change the task's state if
	->pre_xol() fails
Message-ID: <20140422144739.GA8038@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422144719.GA7456@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this doesn't matter, the only ->pre_xol() hook can't fail,
but we need to fix arch_uprobe_pre_xol() anyway. If ->pre_xol() fails
we should not change regs->ip/flags, we should just return the error
to make restart actually possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 4bbeb60..9690c65 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -676,6 +676,12 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
 
+	if (auprobe->ops->pre_xol) {
+		int err = auprobe->ops->pre_xol(auprobe, regs);
+		if (err)
+			return err;
+	}
+
 	regs->ip = utask->xol_vaddr;
 	utask->autask.saved_trap_nr = current->thread.trap_nr;
 	current->thread.trap_nr = UPROBE_TRAP_NR;
@@ -685,8 +691,6 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	if (test_tsk_thread_flag(current, TIF_BLOCKSTEP))
 		set_task_blockstep(current, false);
 
-	if (auprobe->ops->pre_xol)
-		return auprobe->ops->pre_xol(auprobe, regs);
 	return 0;
 }
 
-- 
1.5.5.1

