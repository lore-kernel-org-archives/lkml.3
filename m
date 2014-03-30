Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaCaAJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:09:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271AbaC3Xmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Joe Thornber" <ejt@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.725047487@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 027/200] dm space map common: make sure new space is
 used during extend
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 12c91a5c2d2a8e8cc40a9552313e1e7b0a2d9ee3 upstream.

When extending a low level space map we should update nr_blocks at
the start so the new space is used for the index entries.

Otherwise extend can fail, e.g.: sm_metadata_extend call sequence
that fails:
 -> sm_ll_extend
    -> dm_tm_new_block -> dm_sm_new_block -> sm_bootstrap_new_block
    => returns -ENOSPC because smm->begin == smm->ll.nr_blocks

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/persistent-data/dm-space-map-common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -244,6 +244,10 @@ int sm_ll_extend(struct ll_disk *ll, dm_
 		return -EINVAL;
 	}
 
+	/*
+	 * We need to set this before the dm_tm_new_block() call below.
+	 */
+	ll->nr_blocks = nr_blocks;
 	for (i = old_blocks; i < blocks; i++) {
 		struct dm_block *b;
 		struct disk_index_entry idx;
@@ -251,6 +255,7 @@ int sm_ll_extend(struct ll_disk *ll, dm_
 		r = dm_tm_new_block(ll->tm, &dm_sm_bitmap_validator, &b);
 		if (r < 0)
 			return r;
+
 		idx.blocknr = cpu_to_le64(dm_block_location(b));
 
 		r = dm_tm_unlock(ll->tm, b);
@@ -265,7 +270,6 @@ int sm_ll_extend(struct ll_disk *ll, dm_
 			return r;
 	}
 
-	ll->nr_blocks = nr_blocks;
 	return 0;
 }
 

