Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3G2CaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:30:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34736 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3G2CaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:30:09 -0400
Message-ID: <51F5D399.3050609@huawei.com>
Date: Mon, 29 Jul 2013 10:29:45 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Hanjun Guo <guohanjun@huawei.com>, Li Zefan <lizefan@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] smp: kill unnecessary variable - csd_flags
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used csd_flags formerly because we allocated csd_data by
kmalloc when "wait == 0". When fail to allocation, we will
fall back to on-stack allocation. "csd_data" might be invalid
after generic_exec_single return.

But now we use per cpu data for single cpu ipi calls, and
csd_data can't fall back to on-stack allocation when "wait == 0".

So csd_flags is unnecessary now. Remove it.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 kernel/smp.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 4dba0f7..cac2b6e 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -186,25 +186,16 @@ void generic_smp_call_function_single_interrupt(void)

 	while (!list_empty(&list)) {
 		struct call_single_data *csd;
-		unsigned int csd_flags;

 		csd = list_entry(list.next, struct call_single_data, list);
 		list_del(&csd->list);

-		/*
-		 * 'csd' can be invalid after this call if flags == 0
-		 * (when called through generic_exec_single()),
-		 * so save them away before making the call:
-		 */
-		csd_flags = csd->flags;
-
 		csd->func(csd->info);

 		/*
 		 * Unlocked CSDs are valid through generic_exec_single():
 		 */
-		if (csd_flags & CSD_FLAG_LOCK)
-			csd_unlock(csd);
+		csd_unlock(csd);
 	}
 }

-- 
1.6.0.2

