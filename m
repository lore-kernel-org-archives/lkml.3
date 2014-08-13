Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaHMTQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:16:07 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:46987 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHMTQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:16:05 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH] dcache: use read_seqlock_excl() in d_set_mounted()
Date: Wed, 13 Aug 2014 15:15:50 -0400
Message-Id: <1407957350-37783-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The d_set_mounted() doesn't change anything in the filesystem other
than setting the DCACHE_MOUNTED flag in the mount point's dentry
which is protected by d_lock anyway. So we can safely replace
write_seqlock/write_sequnlock by read_seqlock_excl/read_sequnlock_excl.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 06f6585..bfdd8af 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1207,7 +1207,7 @@ int d_set_mounted(struct dentry *dentry)
 {
 	struct dentry *p;
 	int ret = -ENOENT;
-	write_seqlock(&rename_lock);
+	read_seqlock_excl(&rename_lock);
 	for (p = dentry->d_parent; !IS_ROOT(p); p = p->d_parent) {
 		/* Need exclusion wrt. check_submounts_and_drop() */
 		spin_lock(&p->d_lock);
@@ -1224,7 +1224,7 @@ int d_set_mounted(struct dentry *dentry)
 	}
  	spin_unlock(&dentry->d_lock);
 out:
-	write_sequnlock(&rename_lock);
+	read_sequnlock_excl(&rename_lock);
 	return ret;
 }
 
-- 
1.7.1

