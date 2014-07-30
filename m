Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaG3M3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:29:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36760 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 69/94] dm cache metadata: do not allow the data block size to change
Date: Wed, 30 Jul 2014 14:14:58 +0200
Message-Id: <e0779220de345bf4cd25873367ee61021ffa1d7e.1406722270.git.jslaby@suse.cz>
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

commit 048e5a07f282c57815b3901d4a68a77fa131ce0a upstream.

The block size for the dm-cache's data device must remained fixed for
the life of the cache.  Disallow any attempt to change the cache's data
block size.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-cache-metadata.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 1d38019bb022..b564c0610259 100644
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
2.0.1

