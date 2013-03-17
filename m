Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3CQMuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 08:50:32 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:65390 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3CQMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 08:50:31 -0400
From: Huacai Chen <chenhc@lemote.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 02/02] MIPS: Init new mmu_context for each possible CPU to avoid memory corruption
Date: Sun, 17 Mar 2013 20:50:14 +0800
Message-Id: <1363524614-3823-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, init_new_context() only for each online CPU, this may cause
memory corruption when CPU hotplug and fork() happens at the same time.
To avoid this, we make init_new_context() cover each possible CPU.

Scenario:
1, CPU#1 is being offline;
2, On CPU#0, do_fork() call dup_mm() and copy a mm_struct to the child;
3, On CPU#0, dup_mm() call init_new_context(), since CPU#1 is offline
   and init_new_context() only covers the online CPUs, child has the
   same asid as its parent on CPU#1 (however, child's asid should be 0);
4, CPU#1 is being online;
5, Now, if both parent and child run on CPU#1, memory corruption (e.g.
   segfault, bus error, etc.) will occur.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/include/asm/mmu_context.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/mmu_context.h b/arch/mips/include/asm/mmu_context.h
index e81d719..49d220c 100644
--- a/arch/mips/include/asm/mmu_context.h
+++ b/arch/mips/include/asm/mmu_context.h
@@ -133,7 +133,7 @@ init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 {
 	int i;
 
-	for_each_online_cpu(i)
+	for_each_possible_cpu(i)
 		cpu_context(i, mm) = 0;
 
 	return 0;
-- 
1.7.7.3

