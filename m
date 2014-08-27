Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935668AbaH0SnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:43:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830AbaH0SnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:43:07 -0400
Date: Wed, 27 Aug 2014 11:36:38 -0700
From: tip-bot for Wang Nan <tipbot@zytor.com>
Message-ID: <tip-256aae5eac6d328067d1a986a7c5df6f19bdc8b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, peifeiyue@huawei.com,
        wangnan0@huawei.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, peifeiyue@huawei.com,
        tglx@linutronix.de, wangnan0@huawei.com
In-Reply-To: <1406550019-70935-1-git-send-email-wangnan0@huawei.com>
References: <1406550019-70935-1-git-send-email-wangnan0@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes/x86: Free 'optinsn'
  cache when range check fails
Git-Commit-ID: 256aae5eac6d328067d1a986a7c5df6f19bdc8b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  256aae5eac6d328067d1a986a7c5df6f19bdc8b4
Gitweb:     http://git.kernel.org/tip/256aae5eac6d328067d1a986a7c5df6f19bdc8b4
Author:     Wang Nan <wangnan0@huawei.com>
AuthorDate: Mon, 28 Jul 2014 20:20:19 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Aug 2014 20:24:32 +0200

kprobes/x86: Free 'optinsn' cache when range check fails

This patch frees the 'optinsn' slot when we get a range check error,
to prevent memory leaks.

Before this patch, cache entry in kprobe_insn_cache() won't be freed
if kprobe optimizing fails due to range check failure.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Pei Feiyue <peifeiyue@huawei.com>
Link: http://lkml.kernel.org/r/1406550019-70935-1-git-send-email-wangnan0@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
