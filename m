Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaG1Mat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:30:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4603 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaG1Maq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:30:46 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>, Pei Feiyue <peifeiyue@huawei.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <wangnan0@huawei.com>
Subject: [PATCH] kprobes/x86: opt: free optinsn cache when range check fails
Date: Mon, 28 Jul 2014 20:20:19 +0800
Message-ID: <1406550019-70935-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch frees optinsn slot when range check error to prevent memory
leaks. Before this patch, cache entry in kprobe_insn_cache won't be
freed if kprobe optimizing fails due to range check failure.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/x86/kernel/kprobes/opt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index f304773..f1314d0 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -338,8 +338,10 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 	 * a relative jump.
 	 */
 	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
-	if (abs(rel) > 0x7fffffff)
+	if (abs(rel) > 0x7fffffff) {
+		__arch_remove_optimized_kprobe(op, 0);
 		return -ERANGE;
+	}
 
 	buf = (u8 *)op->optinsn.insn;
 
-- 
1.8.4

