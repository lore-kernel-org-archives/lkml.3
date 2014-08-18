Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaHRKFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:05:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaHRJdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 021/137] dm cache metadata: do not allow the data block size to change
Date: Mon, 18 Aug 2014 10:31:22 +0100
Message-Id: <1408354398-10226-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 048e5a07f282c57815b3901d4a68a77fa131ce0a upstream.

The block size for the dm-cache's data device must remained fixed for
the life of the cache.  Disallow any attempt to change the cache's data
block size.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-cache-metadata.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 1c53495960f2..24d96fa91a26 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -407,6 +407,15 @@ static int __open_metadata(struct dm_cache_metadata *cmd)
 
 	disk_super = dm_block_data(sblock);
 
+	/* Verify the data block size hasn't changed */
+	if (le32_to_cpu(disk_super->data_block_size) != cmd->data_block_size) {
+		DMERR("changing the data block size (from %u to %llu) is not supported",
+		      le32_to_cpu(disk_super->data_block_size),
+		      (unsigned long long)cmd->data_block_size);
+		r = -EINVAL;
+		goto bad;
+	}
+
 	r = __check_incompat_features(disk_super, cmd);
 	if (r < 0)
 		goto bad;
-- 
1.9.1

