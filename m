Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbaGXK2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:28:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54598 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbaGXJqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/128] Btrfs: send, don't error in the presence of subvols/snapshots
Date: Thu, 24 Jul 2014 10:44:19 +0100
Message-Id: <1406195177-8656-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@gmail.com>

commit 1af56070e3ef9477dbc7eba3b9ad7446979c7974 upstream.

If we are doing an incremental send and the base snapshot has a
directory with name X that doesn't exist anymore in the second
snapshot and a new subvolume/snapshot exists in the second snapshot
that has the same name as the directory (name X), the incremental
send would fail with -ENOENT error. This is because it attempts
to lookup for an inode with a number matching the objectid of a
root, which doesn't exist.

Steps to reproduce:

    mkfs.btrfs -f /dev/sdd
    mount /dev/sdd /mnt

    mkdir /mnt/testdir
    btrfs subvolume snapshot -r /mnt /mnt/mysnap1

    rmdir /mnt/testdir
    btrfs subvolume create /mnt/testdir
    btrfs subvolume snapshot -r /mnt /mnt/mysnap2

    btrfs send -p /mnt/mysnap1 /mnt/mysnap2 -f /tmp/send.data

A test case for xfstests follows.

Reported-by: Robert White <rwhite@pobox.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/send.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d4c34c8471a4..4bde74798d2b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1547,6 +1547,10 @@ static int lookup_dir_item_inode(struct btrfs_root *root,
 		goto out;
 	}
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
+	if (key.type == BTRFS_ROOT_ITEM_KEY) {
+		ret = -ENOENT;
+		goto out;
+	}
 	*found_inode = key.objectid;
 	*found_type = btrfs_dir_type(path->nodes[0], di);
 
-- 
1.9.1

