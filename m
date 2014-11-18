Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaKRLis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:38:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45083 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbaKRLir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:38:47 -0500
X-AuditID: 85900ec0-bf2f4b9000002d32-a7-546b2fb3657c
Subject: [PATCH] kprobes: Pass the original kprobe for preparing optimized
 kprobe
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, lizefan@huawei.com, linux@arm.linux.org.uk,
        taras.kondratiuk@linaro.org, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, rabin@rab.in, ben.dooks@codethink.co.uk,
        dave.long@linaro.org, cl@linux.com, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 18 Nov 2014 14:34:39 -0500
Message-ID: <20141118193439.19447.783.stgit@localhost.localdomain>
In-Reply-To: <1416292359-75893-1-git-send-email-wangnan0@huawei.com>
References: <1416292359-75893-1-git-send-email-wangnan0@huawei.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the original kprobe for preparing an optimized kprobe arch-dep
part, since for some architecture (e.g. ARM32) requires the information
in original kprobe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Wang Nan <wangnan0@huawei.com>
---
 arch/x86/kernel/kprobes/opt.c |    3 ++-
 include/linux/kprobes.h       |    3 ++-
 kernel/kprobes.c              |    4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 7c523bb..0dd8d08 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -322,7 +322,8 @@ void arch_remove_optimized_kprobe(struct optimized_kprobe *op)
  * Target instructions MUST be relocatable (checked inside)
  * This is called when new aggr(opt)probe is allocated or reused.
  */
-int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
+int arch_prepare_optimized_kprobe(struct optimized_kprobe *op,
+				  struct kprobe *__unused)
 {
 	u8 *buf;
 	int ret;
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index f7296e5..7ab2c93 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -308,7 +308,8 @@ struct optimized_kprobe {
 /* Architecture dependent functions for direct jump optimization */
 extern int arch_prepared_optinsn(struct arch_optimized_insn *optinsn);
 extern int arch_check_optimized_kprobe(struct optimized_kprobe *op);
-extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op);
+extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op,
+					 struct kprobe *orig);
 extern void arch_remove_optimized_kprobe(struct optimized_kprobe *op);
 extern void arch_optimize_kprobes(struct list_head *oplist);
 extern void arch_unoptimize_kprobes(struct list_head *oplist,
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3995f54..9f28aa7 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -717,7 +717,7 @@ static void prepare_optimized_kprobe(struct kprobe *p)
 	struct optimized_kprobe *op;
 
 	op = container_of(p, struct optimized_kprobe, kp);
-	arch_prepare_optimized_kprobe(op);
+	arch_prepare_optimized_kprobe(op, p);
 }
 
 /* Allocate new optimized_kprobe and try to prepare optimized instructions */
@@ -731,7 +731,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 
 	INIT_LIST_HEAD(&op->list);
 	op->kp.addr = p->addr;
-	arch_prepare_optimized_kprobe(op);
+	arch_prepare_optimized_kprobe(op, p);
 
 	return &op->kp;
 }

