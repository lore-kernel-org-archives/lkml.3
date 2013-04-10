Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937051Ab3DJQNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:13:24 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41581 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937018Ab3DJQNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:13:22 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] driver core: devtmpfs: fix compile failure
Date: Thu, 11 Apr 2013 00:12:56 +0800
Message-Id: <1365610376-2266-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_UIDGID_STRICT_TYPE_CHECKS is enalbed, the below compile
failure will be triggered:

	drivers/base/devtmpfs.c: In function 'handle_create':
	drivers/base/devtmpfs.c:214:19: error: incompatible types when assigning to type 'kuid_t' from type 'uid_t'
	drivers/base/devtmpfs.c:215:19: error: incompatible types when assigning to type 'kgid_t' from type 'gid_t'
	make[2]: *** [drivers/base/devtmpfs.o] Error 1

This patch fixes the compile failure.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/devtmpfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index fda5256..e268fc5 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -211,8 +211,8 @@ static int handle_create(const char *nodename, umode_t mode, uid_t uid,
 		struct iattr newattrs;
 
 		newattrs.ia_mode = mode;
-		newattrs.ia_uid = uid;
-		newattrs.ia_gid = gid;
+		newattrs.ia_uid = KUIDT_INIT(uid);
+		newattrs.ia_gid = KGIDT_INIT(gid);
 		newattrs.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID;
 		mutex_lock(&dentry->d_inode->i_mutex);
 		notify_change(dentry, &newattrs);
-- 
1.7.9.5

