Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3LRVQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:16:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3LRVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.12 112/118] Btrfs: take ordered root lock when removing ordered operations inode
Date: Wed, 18 Dec 2013 13:12:29 -0800
Message-Id: <20131218211222.630268381@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 93858769172c4e3678917810e9d5de360eb991cc upstream.

A user reported a list corruption warning from btrfs_remove_ordered_extent, it
is because we aren't taking the ordered_root_lock when we remove the inode from
the ordered operations list.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ordered-data.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -537,7 +537,9 @@ void btrfs_remove_ordered_extent(struct
 	 */
 	if (RB_EMPTY_ROOT(&tree->tree) &&
 	    !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
+		spin_lock(&root->fs_info->ordered_root_lock);
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
+		spin_unlock(&root->fs_info->ordered_root_lock);
 	}
 
 	if (!root->nr_ordered_extents) {


