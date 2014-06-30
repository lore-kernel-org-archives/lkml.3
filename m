Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaF3Ma3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbaF3Ma2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Filipe Manana <fdmanana@gmail.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 170/181] Btrfs: send, don't error in the presence of subvols/snapshots
Date: Mon, 30 Jun 2014 13:53:11 +0200
Message-Id: <97510df64aa96c9db04dd5a4f3dde1c3584a4284.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe Manana <fdmanana@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/send.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 741c839fa46a..76736b57de5e 100644
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
2.0.0

