Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaIOJdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:33:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbaIOJdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:33:11 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Coddington <bcodding@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/6] GFS2: Hash the negative dentry during inode lookup
Date: Mon, 15 Sep 2014 10:32:46 +0100
Message-Id: <1410773568-1573-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
References: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

Fix a regression introduced by:
6d4ade986f9c8df31e68 GFS2: Add atomic_open support
where an early return misses d_splice_alias() which had been
adding the negative dentry.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e62e594..9317ddc 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -840,8 +840,10 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
 	int error;
 
 	inode = gfs2_lookupi(dir, &dentry->d_name, 0);
-	if (!inode)
+	if (inode == NULL) {
+		d_add(dentry, NULL);
 		return NULL;
+	}
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
-- 
1.8.3.1

