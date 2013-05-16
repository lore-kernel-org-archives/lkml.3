Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3EPBzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:55:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:26588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab3EPBzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="338039079"
Subject: [PATCH] klist: del waiter from klist_remove_waiters before wakeup
 waitting process
From: wangbiao <biao.wang@intel.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, mingo@redhat.com,
        yanmin.zhang@intel.com, biao.wang@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 May 2013 09:50:13 +0800
Message-ID: <1368669013.23403.7.camel@wangbiao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "wang, biao" <biao.wang@intel.com>
Date: Fri, 3 May 2013 14:18:34 +0800
Subject: [PATCH] klist: del waiter from klist_remove_waiters before wakeup
 waitting process

There is a race between klist_remove and klist_release. klist_remove
uses a local var waiter saved on stack. When klist_release calls
wake_up_process(waiter->process) to wake up the waiter, waiter might run
immediately and reuse the stack. Then, klist_release calls
list_del(&waiter->list) to change previous
wait data and cause prior waiter thread corrupt.

The patch fixes it against kernel 3.9.

Signed-off-by: wang, biao <biao.wang@intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
---
 lib/klist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/klist.c b/lib/klist.c
index 0874e41..358a368 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -193,10 +193,10 @@ static void klist_release(struct kref *kref)
 		if (waiter->node != n)
 			continue;
 
+		list_del(&waiter->list);
 		waiter->woken = 1;
 		mb();
 		wake_up_process(waiter->process);
-		list_del(&waiter->list);
 	}
 	spin_unlock(&klist_remove_lock);
 	knode_set_klist(n, NULL);
-- 
1.7.6



