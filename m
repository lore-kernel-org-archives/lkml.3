Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbaF1SAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:00:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbaF1RxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert White <rwhite@pobox.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.15 124/139] Btrfs: send, dont error in the presence of subvols/snapshots
Date: Sat, 28 Jun 2014 10:48:05 -0700
Message-Id: <20140628174611.066720196@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1628,6 +1628,10 @@ static int lookup_dir_item_inode(struct
 		goto out;
 	}
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
+	if (key.type == BTRFS_ROOT_ITEM_KEY) {
+		ret = -ENOENT;
+		goto out;
+	}
 	*found_inode = key.objectid;
 	*found_type = btrfs_dir_type(path->nodes[0], di);
 


