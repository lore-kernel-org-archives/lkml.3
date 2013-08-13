Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3HMGdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab3HMGdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [ 47/60] ext4: flush the extent status cache during EXT4_IOC_SWAP_BOOT
Date: Mon, 12 Aug 2013 23:34:14 -0700
Message-Id: <20130813063338.102801651@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit cde2d7a796f7e895e25b43471ed658079345636d upstream.

Previously we weren't swapping only some of the extent_status LRU
fields during the processing of the EXT4_IOC_SWAP_BOOT ioctl.  The
much safer thing to do is to just completely flush the extent status
tree when doing the swap.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -77,8 +77,10 @@ static void swap_inode_data(struct inode
 	memswap(ei1->i_data, ei2->i_data, sizeof(ei1->i_data));
 	memswap(&ei1->i_flags, &ei2->i_flags, sizeof(ei1->i_flags));
 	memswap(&ei1->i_disksize, &ei2->i_disksize, sizeof(ei1->i_disksize));
-	memswap(&ei1->i_es_tree, &ei2->i_es_tree, sizeof(ei1->i_es_tree));
-	memswap(&ei1->i_es_lru_nr, &ei2->i_es_lru_nr, sizeof(ei1->i_es_lru_nr));
+	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
+	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);
+	ext4_es_lru_del(inode1);
+	ext4_es_lru_del(inode2);
 
 	isize = i_size_read(inode1);
 	i_size_write(inode1, i_size_read(inode2));


