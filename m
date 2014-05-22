Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaEVUmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:42:46 -0400
Received: from mout.gmx.net ([212.227.17.20]:54518 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaEVUmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:42:44 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: agk@redhat.com
Cc: snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] md: Use time_in_range()
Date: Thu, 22 May 2014 22:42:37 +0200
Message-Id: <1400791357-21047-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:AIx6ulCAum8r1998GfWZHM8ArUjmb0Oh+zQb+wCV/txs4A2CIc3
 BjLdGudUFtyIBLbRwm5DBOiNjVt/N4NsO5DZKScBbc3tWKVTVtbukFo6oW0nwyQ0O6ZWxlg
 cpZMaJgQYL9MP8F5aZaDR9yUNu0XjogKP/tp1qHmMN9dYBwpPXXcF+zYHAusvKWj83G8Am1
 89+NsBWarXH8/dzQB9lhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_in_range() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/md/dm-cache-target.c       |    5 +++--
 drivers/md/dm-log-userspace-base.c |    4 ++--
 drivers/md/dm-thin.c               |    5 +++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 9380be7..4378d1d 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1429,8 +1429,9 @@ static void process_bio(struct cache *cache, struct prealloc *structs,
 
 static int need_commit_due_to_time(struct cache *cache)
 {
-	return jiffies < cache->last_commit_jiffies ||
-	       jiffies > cache->last_commit_jiffies + COMMIT_PERIOD;
+	return !time_in_range(jiffies,
+	      cache->last_commit_jiffies,
+	      cache->last_commit_jiffies + COMMIT_PERIOD);
 }
 
 static int commit_if_needed(struct cache *cache)
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index b953db6..cd9b171 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -829,7 +829,7 @@ static int userspace_is_remote_recovering(struct dm_dirty_log *log,
 	int r;
 	uint64_t region64 = region;
 	struct log_c *lc = log->context;
-	static unsigned long long limit;
+	static unsigned long limit;
 	struct {
 		int64_t is_recovering;
 		uint64_t in_sync_hint;
@@ -845,7 +845,7 @@ static int userspace_is_remote_recovering(struct dm_dirty_log *log,
 	 */
 	if (region < lc->in_sync_hint)
 		return 0;
-	else if (jiffies < limit)
+	else if (time_after(limit, jiffies))
 		return 1;
 
 	limit = jiffies + (HZ / 4);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2e71de8..c83b363 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1375,8 +1375,9 @@ static void process_bio_fail(struct thin_c *tc, struct bio *bio)
  */
 static int need_commit_due_to_time(struct pool *pool)
 {
-	return jiffies < pool->last_commit_jiffies ||
-	       jiffies > pool->last_commit_jiffies + COMMIT_PERIOD;
+	return !time_in_range(jiffies,
+	      pool->last_commit_jiffies,
+	      pool->last_commit_jiffies + COMMIT_PERIOD);
 }
 
 #define thin_pbd(node) rb_entry((node), struct dm_thin_endio_hook, rb_node)
-- 
1.7.10.4

