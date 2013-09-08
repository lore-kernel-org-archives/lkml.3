Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3IHPWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:22:47 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:45906 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3IHPWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:22:42 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Wang YanQing <udknight@gmail.com>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        liguang <lig.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/3] SMP: simpilify function generic_smp_call_function_single_interrupt()
Date: Sun,  8 Sep 2013 23:22:24 +0800
Message-Id: <1378653745-8343-2-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378653745-8343-1-git-send-email-liuj97@gmail.com>
References: <1378653745-8343-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Now the call_single_data data structure is always locked by invoking
csd_lock() before inserting it into corresponding call_single_queue
list, so no need to save and check csd->flags in function
generic_smp_call_function_single_interrupt().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wang YanQing <udknight@gmail.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: liguang <lig.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/smp.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index a034712..baa2a65 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -181,25 +181,11 @@ void generic_smp_call_function_single_interrupt(void)
 
 	while (!list_empty(&list)) {
 		struct call_single_data *csd;
-		unsigned int csd_flags;
 
 		csd = list_entry(list.next, struct call_single_data, list);
 		list_del(&csd->list);
-
-		/*
-		 * 'csd' can be invalid after this call if flags == 0
-		 * (when called through generic_exec_single()),
-		 * so save them away before making the call:
-		 */
-		csd_flags = csd->flags;
-
 		csd->func(csd->info);
-
-		/*
-		 * Unlocked CSDs are valid through generic_exec_single():
-		 */
-		if (csd_flags & CSD_FLAG_LOCK)
-			csd_unlock(csd);
+		csd_unlock(csd);
 	}
 }
 
-- 
1.8.1.2

