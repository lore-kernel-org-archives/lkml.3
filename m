Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaLUQfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 11:35:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:52604 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbaLUQff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 11:35:35 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6/6] f2fs: avoid double lock for cp_rwsem
Date: Sun, 21 Dec 2014 08:35:23 -0800
Message-Id: <1419179723-3234-6-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
References: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __f2fs_add_link is covered by cp_rwsem all the time.
This calls init_inode_metadata, which conducts some acl operations including
memory allocation with GFP_KERNEL previously.
But, under memory pressure, f2fs_write_data_page can be called, which also
grabs cp_mutex too.
Basically, it's safe since down_read was used in both of cases, but it'd
better avoid this situation in advance.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/acl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 1ccb26b..7f12d28 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -62,7 +62,7 @@ static struct posix_acl *f2fs_acl_from_disk(const char *value, size_t size)
 	if (count == 0)
 		return NULL;
 
-	acl = posix_acl_alloc(count, GFP_KERNEL);
+	acl = posix_acl_alloc(count, GFP_NOFS);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
 
@@ -116,7 +116,7 @@ static void *f2fs_acl_to_disk(const struct posix_acl *acl, size_t *size)
 	int i;
 
 	f2fs_acl = kmalloc(sizeof(struct f2fs_acl_header) + acl->a_count *
-			sizeof(struct f2fs_acl_entry), GFP_KERNEL);
+			sizeof(struct f2fs_acl_entry), GFP_NOFS);
 	if (!f2fs_acl)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.1.1

