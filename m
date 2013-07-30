Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3G3DHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:07:55 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:31262 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3G3DHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:07:54 -0400
Message-ID: <51F72DA1.7010401@huawei.com>
Date: Tue, 30 Jul 2013 11:06:09 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2] generic-ipi: kill unnecessary variable - csd_flags
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit:8969a5ede0f9e17da4b943712429aef2c9bcd82b
"generic-ipi: remove kmalloc()", wait = 0 can be guaranteed.

And all callsites of generic_exec_single() do an unconditional
csd_lock() now.

So csd_flags is unnecessary now. Remote it.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://patchwork.kernel.org/patch/2834744/
---
 kernel/smp.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index fe9f773..7332697 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -186,25 +186,13 @@ void generic_smp_call_function_single_interrupt(void)

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

-		/*
-		 * Unlocked CSDs are valid through generic_exec_single():
-		 */
-		if (csd_flags & CSD_FLAG_LOCK)
-			csd_unlock(csd);
+		csd_unlock(csd);
 	}
 }

-- 
1.8.2.1


