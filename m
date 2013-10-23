Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3JWJe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:34:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:64115 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3JWJbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:31:36 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v6][PATCH 1/5] powerpc/book3e: initialize crit/mc/dbg kernel stack pointers
Date: Wed, 23 Oct 2013 17:31:21 +0800
Message-ID: <1382520685-11609-2-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382520685-11609-1-git-send-email-tiejun.chen@windriver.com>
References: <1382520685-11609-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already allocated critical/machine/debug check exceptions, but
we also should initialize those associated kernel stack pointers
for use by special exceptions in the PACA.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/setup_64.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 278ca93..5c96d92 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -526,14 +526,20 @@ static void __init exc_lvl_early_init(void)
 	extern unsigned int exc_debug_debug_book3e;
 
 	unsigned int i;
+	unsigned long sp;
 
 	for_each_possible_cpu(i) {
-		critirq_ctx[i] = (struct thread_info *)
-			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
-		dbgirq_ctx[i] = (struct thread_info *)
-			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
-		mcheckirq_ctx[i] = (struct thread_info *)
-			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
+		sp = memblock_alloc(THREAD_SIZE, THREAD_SIZE);
+		critirq_ctx[i] = (struct thread_info *)__va(sp);
+		paca[i].crit_kstack = __va(sp + THREAD_SIZE);
+
+		sp = memblock_alloc(THREAD_SIZE, THREAD_SIZE);
+		dbgirq_ctx[i] = (struct thread_info *)__va(sp);
+		paca[i].dbg_kstack = __va(sp + THREAD_SIZE);
+
+		sp = memblock_alloc(THREAD_SIZE, THREAD_SIZE);
+		mcheckirq_ctx[i] = (struct thread_info *)__va(sp);
+		paca[i].mc_kstack = __va(sp + THREAD_SIZE);
 	}
 
 	if (cpu_has_feature(CPU_FTR_DEBUG_LVL_EXC))
-- 
1.7.9.5

