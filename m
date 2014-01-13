Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaAMRLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:11:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52825 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbaAMQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu Bo <bo.li.liu@oracle.com>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 009/208] Btrfs: fix memory leak of chunks' extent map
Date: Mon, 13 Jan 2014 15:57:30 +0000
Message-Id: <1389628849-1614-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 7d3d1744f8a7d62e4875bd69cc2192a939813880 upstream.

As we're hold a ref on looking up the extent map, we need to drop the ref
before returning to callers.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78b8717..feb93fc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4203,6 +4203,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 		btrfs_emerg(fs_info, "Invalid mapping for %Lu-%Lu, got "
 			    "%Lu-%Lu\n", logical, logical+len, em->start,
 			    em->start + em->len);
+		free_extent_map(em);
 		return 1;
 	}
 
@@ -4384,6 +4385,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		btrfs_crit(fs_info, "found a bad mapping, wanted %Lu, "
 			   "found %Lu-%Lu\n", logical, em->start,
 			   em->start + em->len);
+		free_extent_map(em);
 		return -EINVAL;
 	}
 
-- 
1.8.3.2

