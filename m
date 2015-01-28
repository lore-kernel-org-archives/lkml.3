Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188AbbA1EZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:25:13 -0500
Received: from mail.kernel.org ([198.145.29.136]:40952 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934539AbbA1EZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:09 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 144/177] dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks
Date: Wed, 28 Jan 2015 12:10:02 +0800
Message-Id: <1422418236-12852-235-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 9d28eb12447ee08bb5d1e8bb3195cf20e1ecd1c0 upstream.

The shrinker uses gfp flags to indicate what kind of operation can the
driver wait for. If __GFP_IO flag is present, the driver can wait for
block I/O operations, if __GFP_FS flag is present, the driver can wait on
operations involving the filesystem.

dm-bufio tested for __GFP_IO. However, dm-bufio can run on a loop block
device that makes calls into the filesystem. If __GFP_IO is present and
__GFP_FS isn't, dm-bufio could still block on filesystem operations if it
runs on a loop block device.

The change from __GFP_IO to __GFP_FS supposedly fixes one observed (though
unreproducible) deadlock involving dm-bufio and loop device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[lizf: Backported to 3.4:
 - drop changes to dm_bufio_shrink_scan() and dm_bufio_shrink_count()
 - change __GFP_IO to __GFP_FS in shrink()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/md/dm-bufio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 5abc8d6..535b09c 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1379,9 +1379,9 @@ static void drop_buffers(struct dm_bufio_client *c)
 
 /*
  * Test if the buffer is unused and too old, and commit it.
- * At if noio is set, we must not do any I/O because we hold
- * dm_bufio_clients_lock and we would risk deadlock if the I/O gets rerouted to
- * different bufio client.
+ * And if GFP_NOFS is used, we must not do any I/O because we hold
+ * dm_bufio_clients_lock and we would risk deadlock if the I/O gets
+ * rerouted to different bufio client.
  */
 static int __cleanup_old_buffer(struct dm_buffer *b, gfp_t gfp,
 				unsigned long max_jiffies)
@@ -1389,7 +1389,7 @@ static int __cleanup_old_buffer(struct dm_buffer *b, gfp_t gfp,
 	if (jiffies - b->last_accessed < max_jiffies)
 		return 1;
 
-	if (!(gfp & __GFP_IO)) {
+	if (!(gfp & __GFP_FS)) {
 		if (test_bit(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
@@ -1428,7 +1428,7 @@ static int shrink(struct shrinker *shrinker, struct shrink_control *sc)
 	unsigned long r;
 	unsigned long nr_to_scan = sc->nr_to_scan;
 
-	if (sc->gfp_mask & __GFP_IO)
+	if (sc->gfp_mask & __GFP_FS)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
 		return !nr_to_scan ? 0 : -1;
-- 
1.9.1

