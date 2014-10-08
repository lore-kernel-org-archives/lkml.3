Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaJHWrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:47:23 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:12404 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaJHWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:47:18 -0400
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: akpm@linux-foundation.org, jeffrey.t.kirsher@intel.com,
        kenhelias@firemail.de
Cc: linux-kernel@vger.kernel.org, tmak@hp.com,
        Jerry Hoemann <jerry.hoemann@hp.com>
Subject: [RFC 1/1] fsnotify: next_i is freed during fsnotify_unmount_inodes.
Date: Wed,  8 Oct 2014 16:47:14 -0600
Message-Id: <1412808434-36030-2-git-send-email-jerry.hoemann@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1412808434-36030-1-git-send-email-jerry.hoemann@hp.com>
References: <y>
 <1412808434-36030-1-git-send-email-jerry.hoemann@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During list_for_each_entry_safe, next_i is becoming free causing
the loop to never terminate.  Advance next_i in those cases where
__iget is not done.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
---
 fs/notify/inode_mark.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 9ce0622..e849714 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -288,20 +288,25 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		spin_unlock(&inode->i_lock);
 
 		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) &&
-		    atomic_read(&next_i->i_count)) {
+		while (&next_i->i_sb_list != list) {
 			spin_lock(&next_i->i_lock);
-			if (!(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
+			if (!(next_i->i_state & (I_FREEING | I_WILL_FREE)) &&
+						atomic_read(&next_i->i_count)) {
 				__iget(next_i);
 				need_iput = next_i;
+				spin_unlock(&next_i->i_lock);
+				break;
 			}
 			spin_unlock(&next_i->i_lock);
+			next_i = list_entry(next_i->i_sb_list.next,
+						struct inode, i_sb_list);
 		}
 
 		/*
-		 * We can safely drop inode_sb_list_lock here because we hold
-		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.
+		 * We can safely drop inode_sb_list_lock here because either
+		 * we actually hold references on both inode and next_i or
+		 * end of list.  Also no new inodes will be added since the
+		 * umount has begun.
 		 */
 		spin_unlock(&inode_sb_list_lock);
 
-- 
1.7.11.3

