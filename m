Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935601Ab3IEJoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:44:55 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:57360 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934900Ab3IEJov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:51 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 01/11] vfs: restructure d_genocide()
Date: Thu,  5 Sep 2013 11:44:34 +0200
Message-Id: <1378374284-1484-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

It shouldn't matter when we decrement the refcount during the walk as long
as we do it exactly once.

Restructure d_genocide() to do the killing on entering the dentry instead
of when leaving it.  This helps creating a common helper for tree walking.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index b949af8..0c25394 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2928,6 +2928,10 @@ resume:
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
+		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
+			dentry->d_flags |= DCACHE_GENOCIDE;
+			dentry->d_lockref.count--;
+		}
 		if (!list_empty(&dentry->d_subdirs)) {
 			spin_unlock(&this_parent->d_lock);
 			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
@@ -2935,18 +2939,10 @@ resume:
 			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
-		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
-			dentry->d_flags |= DCACHE_GENOCIDE;
-			dentry->d_lockref.count--;
-		}
 		spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent != root) {
 		struct dentry *child = this_parent;
-		if (!(this_parent->d_flags & DCACHE_GENOCIDE)) {
-			this_parent->d_flags |= DCACHE_GENOCIDE;
-			this_parent->d_lockref.count--;
-		}
 		this_parent = try_to_ascend(this_parent, locked, seq);
 		if (!this_parent)
 			goto rename_retry;
-- 
1.8.1.4

