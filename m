Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaLWGW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 01:22:56 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34655 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaLWGWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 01:22:55 -0500
From: root <chenggang.qin@gmail.com>
X-Google-Original-From: root <chenggang.qcg>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qcg@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: [PATCH] perf core: Use KSTK_ESP() instead of pt_regs->sp while output user regs
Date: Tue, 23 Dec 2014 14:22:25 +0800
Message-Id: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qcg@taobao.com>

For x86_64, the exact value of user stack's esp should be got by KSTK_ESP(current).
current->thread.usersp is copied from PDA while enter ring0. 
Now, we output the value of sp from pt_regs. But pt_regs->sp has changed before
it was pushed into kernel stack.

So, we cannot get the correct callchain while unwind some user stacks.
For example, if the stack contains __lll_unlock_wake()/__lll_lock_wait(), the
callchain will break some times with the latest version of libunwind.
The root cause is the sp that is used by libunwind may be wrong.

If we use KSTK_ESP(current), the correct callchain can be got everytime.
Other architectures also have KSTK_ESP() macro.

Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>

---
 arch/x86/kernel/perf_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
index e309cc5..5da8df8 100644
--- a/arch/x86/kernel/perf_regs.c
+++ b/arch/x86/kernel/perf_regs.c
@@ -60,6 +60,9 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
 	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(pt_regs_offset)))
 		return 0;
 
+	if (idx == PERF_REG_X86_SP)
+		return KSTK_ESP(current);
+
 	return regs_get_register(regs, pt_regs_offset[idx]);
 }
 
-- 
1.9.1

