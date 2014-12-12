Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbaLLGZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:25:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52100 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759393AbaLLGRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:00 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mike Snitzer" <snitzer@redhat.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.4578734@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 063/164] dm bufio: change __GFP_IO to __GFP_FS in
 shrinker callbacks
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - There's only one shrinker callback
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-bufio.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1324,9 +1324,9 @@ static void drop_buffers(struct dm_bufio
 
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
@@ -1334,7 +1334,7 @@ static int __cleanup_old_buffer(struct d
 	if (jiffies - b->last_accessed < max_jiffies)
 		return 1;
 
-	if (!(gfp & __GFP_IO)) {
+	if (!(gfp & __GFP_FS)) {
 		if (test_bit(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
@@ -1373,7 +1373,7 @@ static int shrink(struct shrinker *shrin
 	unsigned long r;
 	unsigned long nr_to_scan = sc->nr_to_scan;
 
-	if (sc->gfp_mask & __GFP_IO)
+	if (sc->gfp_mask & __GFP_FS)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
 		return !nr_to_scan ? 0 : -1;

