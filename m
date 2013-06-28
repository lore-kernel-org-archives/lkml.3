Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab3F1TMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:12:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3F1SzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "wang, biao" <biao.wang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 032/105] klist: del waiter from klist_remove_waiters before wakeup waitting process
Date: Fri, 28 Jun 2013 11:50:54 -0700
Message-Id: <1372445527-24414-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "wang, biao" <biao.wang@intel.com>

commit ac5a2962b02f57dea76d314ef2521a2170b28ab6 upstream.

There is a race between klist_remove and klist_release. klist_remove
uses a local var waiter saved on stack. When klist_release calls
wake_up_process(waiter->process) to wake up the waiter, waiter might run
immediately and reuse the stack. Then, klist_release calls
list_del(&waiter->list) to change previous
wait data and cause prior waiter thread corrupt.

The patch fixes it against kernel 3.9.

Signed-off-by: wang, biao <biao.wang@intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 lib/klist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
1.8.1.2

