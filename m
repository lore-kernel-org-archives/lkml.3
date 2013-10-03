Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3JCEPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:15:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab3JCEPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:15:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [ 39/52] dm-snapshot: fix performance degradation due to small hash size
Date: Wed,  2 Oct 2013 21:05:57 -0700
Message-Id: <20131003040524.905762980@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-snap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -725,17 +725,16 @@ static int calc_max_buckets(void)
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


