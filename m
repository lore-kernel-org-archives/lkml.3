Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab3CLXPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:15:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933501Ab3CLWc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 024/100] dm: fix limits initialization when there are no data devices
Date: Tue, 12 Mar 2013 15:31:09 -0700
Message-Id: <20130312223125.629783989@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 87eb5b21d92a92ac2da3163039d62df88c2b8422 upstream.

dm_calculate_queue_limits will first reset the provided limits to
defaults using blk_set_stacking_limits; whereby defeating the purpose of
retaining the original live table's limits -- as was intended via commit
3ae706561637331aa578e52bb89ecbba5edcb7a9 ("dm: retain table limits when
swapping to new table with no devices").

Fix this improper limits initialization (in the no data devices case) by
avoiding the call to dm_calculate_queue_limits.

[patch header revised by Mike Snitzer]

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2433,7 +2433,7 @@ static void dm_queue_flush(struct mapped
  */
 struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 {
-	struct dm_table *live_map, *map = ERR_PTR(-EINVAL);
+	struct dm_table *live_map = NULL, *map = ERR_PTR(-EINVAL);
 	struct queue_limits limits;
 	int r;
 
@@ -2456,10 +2456,12 @@ struct dm_table *dm_swap_table(struct ma
 		dm_table_put(live_map);
 	}
 
-	r = dm_calculate_queue_limits(table, &limits);
-	if (r) {
-		map = ERR_PTR(r);
-		goto out;
+	if (!live_map) {
+		r = dm_calculate_queue_limits(table, &limits);
+		if (r) {
+			map = ERR_PTR(r);
+			goto out;
+		}
 	}
 
 	map = __bind(md, table, &limits);


