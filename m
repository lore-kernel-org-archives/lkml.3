Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbaDBU1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:27:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42820 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758845AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jeff Layton <jlayton@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 18/40] NFS: Fix races in nfs_revalidate_mapping
Date: Wed,  2 Apr 2014 22:13:04 +0200
Message-Id: <30a6227bc449b6ad48dbec72bc0f57ef73f3a5a2.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 17dfeb9113397a6119091a491ef7182649f0c5a9 upstream.

Commit d529ef83c355f97027ff85298a9709fe06216a66 (NFS: fix the handling
of NFS_INO_INVALID_DATA flag in nfs_revalidate_mapping) introduces
a potential race, since it doesn't test the value of nfsi->cache_validity
and set the bitlock in nfsi->flags atomically.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/inode.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 9b6c90a8a311..12c0fa8ae004 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1048,24 +1048,24 @@ int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping)
 				  nfs_wait_bit_killable, TASK_KILLABLE);
 		if (ret)
 			goto out;
-		if (!(nfsi->cache_validity & NFS_INO_INVALID_DATA))
-			goto out;
-		if (!test_and_set_bit_lock(NFS_INO_INVALIDATING, bitlock))
+		spin_lock(&inode->i_lock);
+		if (test_bit(NFS_INO_INVALIDATING, bitlock)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+		if (nfsi->cache_validity & NFS_INO_INVALID_DATA)
 			break;
-	}
-
-	spin_lock(&inode->i_lock);
-	if (nfsi->cache_validity & NFS_INO_INVALID_DATA) {
-		nfsi->cache_validity &= ~NFS_INO_INVALID_DATA;
-		spin_unlock(&inode->i_lock);
-		trace_nfs_invalidate_mapping_enter(inode);
-		ret = nfs_invalidate_mapping(inode, mapping);
-		trace_nfs_invalidate_mapping_exit(inode, ret);
-	} else {
-		/* something raced in and cleared the flag */
 		spin_unlock(&inode->i_lock);
+		goto out;
 	}
 
+	set_bit(NFS_INO_INVALIDATING, bitlock);
+	nfsi->cache_validity &= ~NFS_INO_INVALID_DATA;
+	spin_unlock(&inode->i_lock);
+	trace_nfs_invalidate_mapping_enter(inode);
+	ret = nfs_invalidate_mapping(inode, mapping);
+	trace_nfs_invalidate_mapping_exit(inode, ret);
+
 	clear_bit_unlock(NFS_INO_INVALIDATING, bitlock);
 	smp_mb__after_clear_bit();
 	wake_up_bit(bitlock, NFS_INO_INVALIDATING);
-- 
1.9.1

