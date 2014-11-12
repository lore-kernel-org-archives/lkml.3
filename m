Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaKLS6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:58:25 -0500
Received: from mx02.posteo.de ([89.146.194.165]:51376 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbaKLS6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:58:24 -0500
From: Martin Kepplinger <martink@posteo.de>
To: giedriuswork@gmail.com
Cc: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
        thierry.reding@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] fuse: Don't check for file->private_data on open(). It is set by the core.
Date: Wed, 12 Nov 2014 19:56:21 +0100
Message-Id: <1415818581-27476-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <5463979C.6090600@gmail.com>
References: <5463979C.6090600@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The miscdevice core now sets file->private_data to the struct miscdevice
so don't fail when this is not NULL.

Reported-by: Giedrius Statkevicius <giedriuswork@gmail.com>
Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
sorry, I can't read ;) Is this a fix for your problem (instead of the first
patch)?

in case of fuse_ctl_add_conn(fc) failing things should proceed as before.

 fs/fuse/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 03246cd..a97a475 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1092,9 +1092,6 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	mutex_lock(&fuse_mutex);
-	err = -EINVAL;
-	if (file->private_data)
-		goto err_unlock;
 
 	err = fuse_ctl_add_conn(fc);
 	if (err)
@@ -1117,6 +1114,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	return 0;
 
  err_unlock:
+	file->private_data = NULL;
 	mutex_unlock(&fuse_mutex);
  err_free_init_req:
 	fuse_request_free(init_req);
-- 
1.7.10.4

