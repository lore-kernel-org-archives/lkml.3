Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3KMHuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 02:50:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50634 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab3KMHuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 02:50:05 -0500
Date: Wed, 13 Nov 2013 10:49:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] aio: checking for NULL instead of IS_ERR
Message-ID: <20131113074940.GG25541@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_anon_inode() returns an ERR_PTR(), it doesn't return NULL.

Fixes: 71ad7490c1f3 ('rework aio migrate pages to use aio fs')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/aio.c b/fs/aio.c
index bf8d080..699f53e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -164,8 +164,8 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 	struct file *file;
 	struct path path;
 	struct inode *inode = alloc_anon_inode(aio_mnt->mnt_sb);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
 	inode->i_mapping->a_ops = &aio_ctx_aops;
 	inode->i_mapping->private_data = ctx;
