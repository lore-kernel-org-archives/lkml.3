Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3LRVTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:19:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3LRVOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.12 106/118] Btrfs: do a full search everytime in btrfs_search_old_slot
Date: Wed, 18 Dec 2013 13:12:23 -0800
Message-Id: <20131218211222.458116379@linuxfoundation.org>
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

commit d4b4087c43cc00a196c5be57fac41f41309f1d56 upstream.

While running some snashot aware defrag tests I noticed I was panicing every
once and a while in key_search.  This is because of the optimization that says
if we find a key at slot 0 it will be at slot 0 all the way down the rest of the
tree.  This isn't the case for btrfs_search_old_slot since it will likely replay
changes to a buffer if something has changed since we took our sequence number.
So short circuit this optimization by setting prev_cmp to -1 every time we call
key_search so we will do our normal binary search.  With this patch I am no
longer seeing the panics I was seeing before.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2758,7 +2758,7 @@ int btrfs_search_old_slot(struct btrfs_r
 	int level;
 	int lowest_unlock = 1;
 	u8 lowest_level = 0;
-	int prev_cmp;
+	int prev_cmp = -1;
 
 	lowest_level = p->lowest_level;
 	WARN_ON(p->nodes[0] != NULL);
@@ -2769,7 +2769,6 @@ int btrfs_search_old_slot(struct btrfs_r
 	}
 
 again:
-	prev_cmp = -1;
 	b = get_old_root(root, time_seq);
 	level = btrfs_header_level(b);
 	p->locks[level] = BTRFS_READ_LOCK;
@@ -2787,6 +2786,11 @@ again:
 		 */
 		btrfs_unlock_up_safe(p, level + 1);
 
+		/*
+		 * Since we can unwind eb's we want to do a real search every
+		 * time.
+		 */
+		prev_cmp = -1;
 		ret = key_search(b, key, level, &prev_cmp, &slot);
 
 		if (level != 0) {


