Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab3JJQJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:09:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3JJPov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:44:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 057/104] dm snapshot: workaround for a false positive lockdep warning
Date: Thu, 10 Oct 2013 08:41:45 -0700
Message-Id: <1381419752-29733-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5ea330a75bd86b2b2a01d7b85c516983238306fb upstream.

The kernel reports a lockdep warning if a snapshot is invalidated because
it runs out of space.

The lockdep warning was triggered by commit 0976dfc1d0cd80a4e9dfaf87bd87
("workqueue: Catch more locking problems with flush_work()") in v3.5.

The warning is false positive.  The real cause for the warning is that
the lockdep engine treats different instances of md->lock as a single
lock.

This patch is a workaround - we use flush_workqueue instead of flush_work.
This code path is not performance sensitive (it is called only on
initialization or invalidation), thus it doesn't matter that we flush the
whole workqueue.

The real fix for the problem would be to teach the lockdep engine to treat
different instances of md->lock as separate locks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-snap-persistent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 3ac4156..4caa8e6 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -256,7 +256,7 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw,
 	 */
 	INIT_WORK_ONSTACK(&req.work, do_metadata);
 	queue_work(ps->metadata_wq, &req.work);
-	flush_work(&req.work);
+	flush_workqueue(ps->metadata_wq);
 
 	return req.result;
 }
-- 
1.8.1.2

