Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966587AbaCUAZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:25:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966021AbaCUAJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.10 63/85] dm cache: fix truncation bug when copying a block to/from >2TB fast device
Date: Thu, 20 Mar 2014 17:10:06 -0700
Message-Id: <20140321000607.651422265@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -861,12 +861,13 @@ static void issue_copy_real(struct dm_ca
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


