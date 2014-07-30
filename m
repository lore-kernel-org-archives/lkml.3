Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaG3M0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:26:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36754 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 68/94] dm thin metadata: do not allow the data block size to change
Date: Wed, 30 Jul 2014 14:14:57 +0200
Message-Id: <c355b2e35e910d4aa740c4009d5cd62b0698c6c2.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9aec8629ec829fc9403788cd959e05dd87988bd1 upstream.

The block size for the thin-pool's data device must remained fixed for
the life of the thin-pool.  Disallow any attempt to change the
thin-pool's data block size.

It should be noted that attempting to change the data block size via
thin-pool table reload will be ignored as a side-effect of the thin-pool
handover that the thin-pool target does during thin-pool table reload.

Here is an example outcome of attempting to load a thin-pool table that
reduced the thin-pool's data block size from 1024K to 512K.

Before:
kernel: device-mapper: thin: 253:4: growing the data device from 204800 to 409600 blocks

After:
kernel: device-mapper: thin metadata: changing the data block size (from 2048 to 1024) is not supported
kernel: device-mapper: table: 253:4: thin-pool: Error creating metadata object
kernel: device-mapper: ioctl: error adding target to table

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-thin-metadata.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 07a6ea3a9820..b63095c73b5f 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -613,6 +613,15 @@ static int __open_metadata(struct dm_pool_metadata *pmd)
 
 	disk_super = dm_block_data(sblock);
 
+	/* Verify the data block size hasn't changed */
+	if (le32_to_cpu(disk_super->data_block_size) != pmd->data_block_size) {
+		DMERR("changing the data block size (from %u to %llu) is not supported",
+		      le32_to_cpu(disk_super->data_block_size),
+		      (unsigned long long)pmd->data_block_size);
+		r = -EINVAL;
+		goto bad_unlock_sblock;
+	}
+
 	r = __check_incompat_features(disk_super, pmd);
 	if (r < 0)
 		goto bad_unlock_sblock;
-- 
2.0.1

