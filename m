Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3JJPo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:44:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab3JJPo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:44:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 058/104] dm-snapshot: fix performance degradation due to small hash size
Date: Thu, 10 Oct 2013 08:41:46 -0700
Message-Id: <1381419752-29733-59-git-send-email-kamal@canonical.com>
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

commit 60e356f381954d79088d0455e357db48cfdd6857 upstream.

LVM2, since version 2.02.96, creates origin with zero size, then loads
the snapshot driver and then loads the origin.  Consequently, the
snapshot driver sees the origin size zero and sets the hash size to the
lower bound 64.  Such small hash table causes performance degradation.

This patch changes it so that the hash size is determined by the size of
snapshot volume, not minimum of origin and snapshot size.  It doesn't
make sense to set the snapshot size significantly larger than the origin
size, so we do not need to take origin size into account when
calculating the hash size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-snap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 900eb23..8b36c52 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -723,17 +723,16 @@ static int calc_max_buckets(void)
  */
 static int init_hash_tables(struct dm_snapshot *s)
 {
-	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
+	sector_t hash_size, cow_dev_size, max_buckets;
 
 	/*
 	 * Calculate based on the size of the original volume or
 	 * the COW volume...
 	 */
 	cow_dev_size = get_dev_size(s->cow->bdev);
-	origin_dev_size = get_dev_size(s->origin->bdev);
 	max_buckets = calc_max_buckets();
 
-	hash_size = min(origin_dev_size, cow_dev_size) >> s->store->chunk_shift;
+	hash_size = cow_dev_size >> s->store->chunk_shift;
 	hash_size = min(hash_size, max_buckets);
 
 	if (hash_size < 64)
-- 
1.8.1.2

