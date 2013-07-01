Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3GAKAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:00:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab3GAKAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:00:00 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/12] GFS2: fix regression in dir_double_exhash
Date: Mon,  1 Jul 2013 10:33:11 +0100
Message-Id: <1372671195-3472-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Recent commit e8830d8 introduced a bug in function dir_double_exhash;
it was failing to set h in the fall-back case. This patch corrects it.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index f0c7052..147fcc5 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1125,13 +1125,14 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 	if (IS_ERR(hc))
 		return PTR_ERR(hc);
 
-	h = hc2 = kmalloc(hsize_bytes * 2, GFP_NOFS | __GFP_NOWARN);
+	hc2 = kmalloc(hsize_bytes * 2, GFP_NOFS | __GFP_NOWARN);
 	if (hc2 == NULL)
 		hc2 = __vmalloc(hsize_bytes * 2, GFP_NOFS, PAGE_KERNEL);
 
 	if (!hc2)
 		return -ENOMEM;
 
+	h = hc2;
 	error = gfs2_meta_inode_buffer(dip, &dibh);
 	if (error)
 		goto out_kfree;
-- 
1.7.4

