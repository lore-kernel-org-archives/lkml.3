Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbaHHUly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:41:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495AbaHHUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 140/259] dm thin metadata: do not allow the data block size to change
Date: Fri,  8 Aug 2014 13:39:23 -0700
Message-Id: <1407530482-4483-141-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-thin-metadata.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 07a6ea3..b63095c 100644
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
1.9.1

