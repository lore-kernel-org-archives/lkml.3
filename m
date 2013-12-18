Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3LRDMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:12:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34610 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3LRDMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:12:18 -0500
From: Vaughan Cao <vaughan.cao@oracle.com>
To: tj@kernel.org
Cc: vaughan.cao@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] async: fix insert entry in ascending list
Date: Wed, 18 Dec 2013 11:15:23 +0800
Message-Id: <1387336523-13756-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I suppose there is a fault in the patch of https://lkml.org/lkml/2013/1/16/546.
I know you made a new patch for latest kernel which don't move the entry
between pending and running list that remove the code I mentioned, but our
kernel is based on v3.8.13 that has the code.

In my understanding, both pending and running list are sorted ascendingly by
cookie value. To find the correct postion to insert the entry into running
list, we traverse reversely to the head. When a node with a smaller cookie is
found, we break out and add the new entry after it. But the origin code tries 
to find a larger cookie and insert itself before that node, it won't result in
a sorted list in any direction...

I don't know if my understanding about the async mechanism is right, so here 
to have a check with you. Thanks.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 kernel/async.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 6f34904..596c5e7 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -135,9 +135,9 @@ static void async_run_entry_fn(struct work_struct *work)
 	/* 1) move self to the running queue, make sure it stays sorted */
 	spin_lock_irqsave(&async_lock, flags);
 	list_for_each_entry_reverse(pos, &running->domain, list)
-		if (entry->cookie < pos->cookie)
+		if (entry->cookie > pos->cookie)
 			break;
-	list_move_tail(&entry->list, &pos->list);
+	list_move(&entry->list, &pos->list);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 2) run (and print duration) */
-- 
1.8.3.1

