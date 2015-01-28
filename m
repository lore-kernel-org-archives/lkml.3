Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934604AbbA1EZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:25:47 -0500
Received: from mail.kernel.org ([198.145.29.136]:41183 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934587AbbA1EZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:43 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Paul Moore <pmoore@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 157/177] audit: keep inode pinned
Date: Wed, 28 Jan 2015 12:10:15 +0800
Message-Id: <1422418236-12852-248-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 799b601451b21ebe7af0e6e8f6e2ccd4683c5064 upstream.

Audit rules disappear when an inode they watch is evicted from the cache.
This is likely not what we want.

The guilty commit is "fsnotify: allow marks to not pin inodes in core",
which didn't take into account that audit_tree adds watches with a zero
mask.

Adding any mask should fix this.

Fixes: 90b1e7a57880 ("fsnotify: allow marks to not pin inodes in core")
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/audit_tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 0caf1f8..8a14284 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -154,6 +154,7 @@ static struct audit_chunk *alloc_chunk(int count)
 		chunk->owners[i].index = i;
 	}
 	fsnotify_init_mark(&chunk->mark, audit_tree_destroy_watch);
+	chunk->mark.mask = FS_IN_IGNORED;
 	return chunk;
 }
 
-- 
1.9.1

