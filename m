Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaJ1IGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:06:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaJ1DgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.17 002/146] btrfs: dont go readonly on existing qgroup items
Date: Tue, 28 Oct 2014 11:32:24 +0800
Message-Id: <20141028033343.549838507@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/qgroup.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -551,9 +551,15 @@ static int add_qgroup_item(struct btrfs_
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
@@ -572,7 +578,7 @@ static int add_qgroup_item(struct btrfs_
 	key.type = BTRFS_QGROUP_LIMIT_KEY;
 	ret = btrfs_insert_empty_item(trans, quota_root, path, &key,
 				      sizeof(*qgroup_limit));
-	if (ret)
+	if (ret && ret != -EEXIST)
 		goto out;
 
 	leaf = path->nodes[0];


