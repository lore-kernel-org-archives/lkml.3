Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3KGHlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:41:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35878 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3KGHlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:41:18 -0500
Date: Thu, 7 Nov 2013 10:41:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] fat: double unlock on error path
Message-ID: <20131107074108.GB21844@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a stray unlock here which was not intended.  I have removed it.

Fixes: 3f9f3dfb5755 ('fat: add fat_fallocate operation')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 03f716f..befedee 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -257,10 +257,8 @@ static long fat_fallocate(struct file *file, int mode,
 		goto error;
 
 	err = inode_newsize_ok(inode, (len + offset));
-	if (err) {
-		mutex_unlock(&inode->i_mutex);
+	if (err)
 		goto error;
-	}
 
 	if (mode & FALLOC_FL_KEEP_SIZE) {
 		/* First compute the number of clusters to be allocated */
