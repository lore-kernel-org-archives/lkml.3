Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3JUJOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:14:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39608 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846Ab3JUIvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mikulas Patocka" <mpatocka@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.994662760@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 082/149] dm-snapshot: fix performance degradation due
 to small hash size
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-snap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -721,17 +721,16 @@ static int calc_max_buckets(void)
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

