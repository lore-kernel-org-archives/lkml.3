Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab3FEVTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:19:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564Ab3FEVNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:13:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "wang, biao" <biao.wang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [ 21/44] klist: del waiter from klist_remove_waiters before wakeup waitting process
Date: Wed,  5 Jun 2013 14:12:19 -0700
Message-Id: <20130605211224.082345886@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 lib/klist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/klist.c
+++ b/lib/klist.c
@@ -193,10 +193,10 @@ static void klist_release(struct kref *k
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


