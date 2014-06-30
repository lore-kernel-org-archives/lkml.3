Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbaF3MM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:12:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51989 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 024/181] Btrfs: don't leak block group on error
Date: Mon, 30 Jun 2014 13:50:45 +0200
Message-Id: <596075a2050e50aba69d903c59cbdc71ec954a50.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe David Borba Manana <fdmanana@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e84cc14213e2c81ae5a2da341a9da0d58a1dbfad upstream.

In extent-tree.c:btrfs_write_dirty_block_groups(), if the call to
write_one_cache_group() failed, we would return without putting
the block group first.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/extent-tree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b256ddc1cb53..63ee604efa6c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3318,10 +3318,9 @@ again:
 		last = cache->key.objectid + cache->key.offset;
 
 		err = write_one_cache_group(trans, root, path, cache);
+		btrfs_put_block_group(cache);
 		if (err) /* File system offline */
 			goto out;
-
-		btrfs_put_block_group(cache);
 	}
 
 	while (1) {
-- 
2.0.0

