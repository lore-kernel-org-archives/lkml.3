Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaF3MKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:10:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51992 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/181] Btrfs: don't delete ordered roots from list during cleanup
Date: Mon, 30 Jun 2014 13:50:48 +0200
Message-Id: <445d1c3ae946d89d8978fee5985ad42e05e3dfb4.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jbacik@fusionio.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1de2cfde93c20a0357ff1dffed901598470facf3 upstream.

During transaction cleanup after an abort we are just removing roots from the
ordered roots list which is incorrect.  We have a BUG_ON() to make sure that the
root is still part of the ordered roots list when we put our ordered extent
which we were tripping in this case.  So do like we do everywhere else and just
move it to the tail of the ordered roots list and allow the normal cleanup to
take care of stuff.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 409dcbd234dc..5bdf8ce5be20 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3809,7 +3809,8 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 	while (!list_empty(&splice)) {
 		root = list_first_entry(&splice, struct btrfs_root,
 					ordered_root);
-		list_del_init(&root->ordered_root);
+		list_move_tail(&root->ordered_root,
+			       &fs_info->ordered_roots);
 
 		btrfs_destroy_ordered_extents(root);
 
-- 
2.0.0

