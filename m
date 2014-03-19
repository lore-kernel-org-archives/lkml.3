Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaCSVaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:30:35 -0400
Received: from s15279694.onlinehome-server.info ([87.106.27.49]:42690 "EHLO
	bender.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaCSVad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:30:33 -0400
Subject: [PATCH 2/2] fs/namespace: use RCU list functions for mnt_hash
To: viro@zeniv.linux.org.uk
From: Max Kellermann <mk@cm4all.com>
Cc: max@duempel.org, linux-kernel@vger.kernel.org
Date: Wed, 19 Mar 2014 22:22:32 +0100
Message-ID: <20140319212232.25520.67165.stgit@rabbit.intern.cm-ag>
In-Reply-To: <20140319212226.25520.98808.stgit@rabbit.intern.cm-ag>
References: <20140319212226.25520.98808.stgit@rabbit.intern.cm-ag>
User-Agent: StGit/0.16-39-g0831
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mount.mnt_hash is RCU-protected, and therefore we must use the RCU
variants to manipulate the list.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---
 fs/namespace.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2aa0a14..295a0c0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -22,6 +22,7 @@
 #include <linux/fsnotify.h>	/* fsnotify_vfsmount_delete */
 #include <linux/uaccess.h>
 #include <linux/proc_ns.h>
+#include <linux/rculist.h>
 #include <linux/magic.h>
 #include "pnode.h"
 #include "internal.h"
@@ -739,8 +740,8 @@ static void attach_mnt(struct mount *mnt,
 			struct mountpoint *mp)
 {
 	mnt_set_mountpoint(parent, mp, mnt);
-	list_add_tail(&mnt->mnt_hash, mount_hashtable +
-			hash(&parent->mnt, mp->m_dentry));
+	list_add_tail_rcu(&mnt->mnt_hash, mount_hashtable +
+			  hash(&parent->mnt, mp->m_dentry));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
 }
 
@@ -762,8 +763,8 @@ static void commit_tree(struct mount *mnt)
 
 	list_splice(&head, n->list.prev);
 
-	list_add_tail(&mnt->mnt_hash, mount_hashtable +
-				hash(&parent->mnt, mnt->mnt_mountpoint));
+	list_add_tail_rcu(&mnt->mnt_hash, mount_hashtable +
+			  hash(&parent->mnt, mnt->mnt_mountpoint));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
 	touch_mnt_namespace(n);
 }

