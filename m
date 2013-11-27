Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3K0B1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:27:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662Ab3K0A6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Murphy <lists@colorremedies.com>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.12 007/116] Btrfs: relocate csums properly with prealloc extents
Date: Tue, 26 Nov 2013 16:56:20 -0800
Message-Id: <20131127005737.427879660@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 4577b014d1bc3db386da3246f625888fc48083a9 upstream.

A user reported a problem where they were getting csum errors when running a
balance and running systemd's journal.  This is because systemd is awesome and
fallocate()'s its log space and writes into it.  Unfortunately we assume that
when we read in all the csums for an extent that they are sequential starting at
the bytenr we care about.  This obviously isn't the case for prealloc extents,
where we could have written to the middle of the prealloc extent only, which
means the csum would be for the bytenr in the middle of our range and not the
front of our range.  Fix this by offsetting the new bytenr we are logging to
based on the original bytenr the csum was for.  With this patch I no longer see
the csum errors I was seeing.  Thanks,

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4481,6 +4481,7 @@ int btrfs_reloc_clone_csums(struct inode
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 	u64 disk_bytenr;
+	u64 new_bytenr;
 	LIST_HEAD(list);
 
 	ordered = btrfs_lookup_ordered_extent(inode, file_pos);
@@ -4492,13 +4493,24 @@ int btrfs_reloc_clone_csums(struct inode
 	if (ret)
 		goto out;
 
-	disk_bytenr = ordered->start;
 	while (!list_empty(&list)) {
 		sums = list_entry(list.next, struct btrfs_ordered_sum, list);
 		list_del_init(&sums->list);
 
-		sums->bytenr = disk_bytenr;
-		disk_bytenr += sums->len;
+		/*
+		 * We need to offset the new_bytenr based on where the csum is.
+		 * We need to do this because we will read in entire prealloc
+		 * extents but we may have written to say the middle of the
+		 * prealloc extent, so we need to make sure the csum goes with
+		 * the right disk offset.
+		 *
+		 * We can do this because the data reloc inode refers strictly
+		 * to the on disk bytes, so we don't have to worry about
+		 * disk_len vs real len like with real inodes since it's all
+		 * disk length.
+		 */
+		new_bytenr = ordered->start + (sums->bytenr - disk_bytenr);
+		sums->bytenr = new_bytenr;
 
 		btrfs_add_ordered_sum(inode, ordered, sums);
 	}


