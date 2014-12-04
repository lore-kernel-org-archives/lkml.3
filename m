Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaLDFjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 00:39:32 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:45620 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaLDFj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 00:39:29 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v12 6/7] kprobes: Pass the original kprobe for preparing optimized kprobe
Date: Thu, 4 Dec 2014 13:35:50 +0800
Message-ID: <1417671350-53346-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.547FF38F.01A8,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 9c245e5fc8cdaa824d9d8615f819397d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Pass the original kprobe for preparing an optimized kprobe arch-dep
part, since for some architecture (e.g. ARM32) requires the information
in original kprobe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Wang Nan <wangnan0@huawei.com>
---
 arch/x86/kernel/kprobes/opt.c | 3 ++-
 include/linux/kprobes.h       | 3 ++-
 kernel/kprobes.c              | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index f1314d0..7028296 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -320,7 +320,8 @@ void arch_remove_optimized_kprobe(struct optimized_kprobe *op)
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
-- 
1.8.4

