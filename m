Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3EGOSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:18:11 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:59326 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752641Ab3EGOSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:18:00 -0400
X-Greylist: delayed 16638 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 10:17:59 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/15] hfs: avoid crash in hfs_bnode_create
Date: Tue,  7 May 2013 16:18:15 +0200
Message-Id: <1367936303-13386-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

Commit 634725a92938b0f282b17cec0b007dca77adebd2 removed the BUG_ON in
hfs_bnode_create in hfsplus. This patch removes it from the hfs
version and avoids an fsfuzzer crash.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/hfs/bnode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index f3b1a15..6d435c2 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -415,7 +415,11 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
 	spin_lock(&tree->hash_lock);
 	node = hfs_bnode_findhash(tree, num);
 	spin_unlock(&tree->hash_lock);
-	BUG_ON(node);
+	if (node) {
+		printk(KERN_CRIT "new node %u already hashed?\n", num);
+		WARN_ON(1);
+		return node;
+	}
 	node = __hfs_bnode_create(tree, num);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
-- 
1.8.2.1

