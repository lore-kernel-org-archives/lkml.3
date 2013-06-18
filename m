Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab3FRMD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:03:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab3FRLoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "wang, biao" <biao.wang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 30/93] klist: del waiter from klist_remove_waiters before wakeup waitting process
Date: Tue, 18 Jun 2013 12:42:38 +0100
Message-Id: <1371555821-12820-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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

