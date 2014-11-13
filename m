Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276AbaKMTaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:30:24 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:54238 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933997AbaKMTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:17 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org (open list:OVERLAYFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 05/16] overlayfs: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:11 -0500
Message-Id: <1415906662-4576-6-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 fs/overlayfs/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 08b704c..b0f050e 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -84,12 +84,10 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 
 static struct dentry *ovl_upperdentry_dereference(struct ovl_entry *oe)
 {
-	struct dentry *upperdentry = ACCESS_ONCE(oe->__upperdentry);
 	/*
 	 * Make sure to order reads to upperdentry wrt ovl_dentry_update()
 	 */
-	smp_read_barrier_depends();
-	return upperdentry;
+	return lockless_dereference(oe->__upperdentry);
 }
 
 void ovl_path_upper(struct dentry *dentry, struct path *path)
-- 
1.9.1

