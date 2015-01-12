Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbbALTT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:19:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbbALSFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>,
        "Sebastiaan L. Zoutendijk" <baszoutendijk@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 006/216] btrfs: don't go readonly on existing qgroup items
Date: Mon, 12 Jan 2015 18:02:03 +0000
Message-Id: <1421085933-32536-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Fasheh <mfasheh@suse.de>

commit 0b4699dcb65c2cff793210b07f40b98c2d423a43 upstream.

btrfs_drop_snapshot() leaves subvolume qgroup items on disk after
completion. This can cause problems with snapshot creation. If a new
snapshot tries to claim the deleted subvolumes id, btrfs will get -EEXIST
from add_qgroup_item() and go read-only. The following commands will
reproduce this problem (assume btrfs is on /dev/sda and is mounted at
/btrfs)

mkfs.btrfs -f /dev/sda
mount -t btrfs /dev/sda /btrfs/
btrfs quota enable /btrfs/
btrfs su sna /btrfs/ /btrfs/snap
btrfs su de /btrfs/snap
sleep 45
umount /btrfs/
mount -t btrfs /dev/sda /btrfs/

We can fix this by catching -EEXIST in add_qgroup_item() and
initializing the existing items. We have the problem of orphaned
relation items being on disk from an old snapshot but that is outside
the scope of this patch.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: Sebastiaan L. Zoutendijk <baszoutendijk@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/qgroup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3eec914710b2..0e32f21e0868 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -551,9 +551,15 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_QGROUP_INFO_KEY;
 	key.offset = qgroupid;
 
+	/*
+	 * Avoid a transaction abort by catching -EEXIST here. In that
+	 * case, we proceed by re-initializing the existing structure
+	 * on disk.
+	 */
+
 	ret = btrfs_insert_empty_item(trans, quota_root, path, &key,
 				      sizeof(*qgroup_info));
-	if (ret)
+	if (ret && ret != -EEXIST)
 		goto out;
 
 	leaf = path->nodes[0];
@@ -572,7 +578,7 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_QGROUP_LIMIT_KEY;
 	ret = btrfs_insert_empty_item(trans, quota_root, path, &key,
 				      sizeof(*qgroup_limit));
-	if (ret)
+	if (ret && ret != -EEXIST)
 		goto out;
 
 	leaf = path->nodes[0];
-- 
2.1.4

