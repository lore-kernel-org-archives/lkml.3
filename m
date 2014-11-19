Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbaKSV5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:57:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933471AbaKSVEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 053/122] dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks
Date: Wed, 19 Nov 2014 12:51:43 -0800
Message-Id: <20141119205210.562146736@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-bufio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1448,9 +1448,9 @@ static void drop_buffers(struct dm_bufio
 
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
@@ -1458,7 +1458,7 @@ static int __cleanup_old_buffer(struct d
 	if (jiffies - b->last_accessed < max_jiffies)
 		return 0;
 
-	if (!(gfp & __GFP_IO)) {
+	if (!(gfp & __GFP_FS)) {
 		if (test_bit(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
@@ -1500,7 +1500,7 @@ dm_bufio_shrink_scan(struct shrinker *sh
 	unsigned long freed;
 
 	c = container_of(shrink, struct dm_bufio_client, shrinker);
-	if (sc->gfp_mask & __GFP_IO)
+	if (sc->gfp_mask & __GFP_FS)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
 		return SHRINK_STOP;
@@ -1517,7 +1517,7 @@ dm_bufio_shrink_count(struct shrinker *s
 	unsigned long count;
 
 	c = container_of(shrink, struct dm_bufio_client, shrinker);
-	if (sc->gfp_mask & __GFP_IO)
+	if (sc->gfp_mask & __GFP_FS)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
 		return 0;


