Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3LDIjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:39:11 -0500
Received: from relay.parallels.com ([195.214.232.42]:32779 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3LDIjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:39:09 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: <devel@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] fs: fix WARN on alloc_super() fail path
Date: Wed, 4 Dec 2013 12:39:04 +0400
Message-ID: <1386146344-17185-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On fail path alloc_super() calls destroy_super(), which issues a warning
if list_empty() returns false on the s_mounts field. That said s_mounts
should be initialized in alloc_super() before any possible failure.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index e5f6c2c..cecd780 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -166,6 +166,8 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	if (!s)
 		return NULL;
 
+	INIT_LIST_HEAD(&s->s_mounts);
+
 	if (security_sb_alloc(s))
 		goto fail;
 
@@ -188,7 +190,6 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	if (list_lru_init(&s->s_inode_lru))
 		goto fail;
 
-	INIT_LIST_HEAD(&s->s_mounts);
 	init_rwsem(&s->s_umount);
 	lockdep_set_class(&s->s_umount, &type->s_umount_key);
 	/*
-- 
1.7.10.4

