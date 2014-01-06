Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaAFJYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:24:35 -0500
Received: from relay.parallels.com ([195.214.232.42]:44080 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaAFJYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:24:33 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <viro@zeniv.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH RESEND] fs: fix WARN on alloc_super() fail path
Date: Mon, 6 Jan 2014 13:24:31 +0400
Message-ID: <1389000271-31757-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.24.128]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On fail path alloc_super() calls destroy_super(), which issues a warning
if the sb's s_mounts list is not empty, in particular if it has not been
initialized. That said s_mounts must be initialized in alloc_super()
before any possible failure, but currently it is initialized close to
the end of the function leading to a useless warning dumped to log if
either percpu_counter_init() or list_lru_init() fails. Let's fix this.

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

