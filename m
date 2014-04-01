Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaDALpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:45:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaDALSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 092/144] dm cache: fix truncation bug when copying a block to/from >2TB fast device
Date: Tue,  1 Apr 2014 12:14:56 +0100
Message-Id: <1396350948-29910-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heinz Mauelshagen <heinzm@redhat.com>

commit 8b9d96666529a979acf4825391efcc7c8a3e9f12 upstream.

During demotion or promotion to a cache's >2TB fast device we must not
truncate the cache block's associated sector to 32bits.  The 32bit
temporary result of from_cblock() caused a 32bit multiplication when
calculating the sector of the fast device in issue_copy_real().

Use an intermediate 64bit type to store the 32bit from_cblock() to allow
for proper 64bit multiplication.

Here is an example of how this bug manifests on an ext4 filesystem:

 EXT4-fs error (device dm-0): ext4_mb_generate_buddy:756: group 17136, 32768 clusters in bitmap, 30688 in gd; block bitmap corrupt.
 JBD2: Spotted dirty metadata buffer (dev = dm-0, blocknr = 0). There's a risk of filesystem corruption in case of system crash.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-cache-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index d8dbc2f..e36beca 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -865,12 +865,13 @@ static void issue_copy_real(struct dm_cache_migration *mg)
 	int r;
 	struct dm_io_region o_region, c_region;
 	struct cache *cache = mg->cache;
+	sector_t cblock = from_cblock(mg->cblock);
 
 	o_region.bdev = cache->origin_dev->bdev;
 	o_region.count = cache->sectors_per_block;
 
 	c_region.bdev = cache->cache_dev->bdev;
-	c_region.sector = from_cblock(mg->cblock) * cache->sectors_per_block;
+	c_region.sector = cblock * cache->sectors_per_block;
 	c_region.count = cache->sectors_per_block;
 
 	if (mg->writeback || mg->demote) {
-- 
1.9.1

