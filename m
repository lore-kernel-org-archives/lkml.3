Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab3HSJOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:14:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3HSJOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:14:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/5] GFS2: Check for glock already held in gfs2_getxattr
Date: Mon, 19 Aug 2013 09:48:07 +0100
Message-Id: <1376902087-7783-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
References: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the introduction of atomic_open, gfs2_getxattr can be
called with the glock already held, so we need to allow for
this.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: David Teigland <teigland@redhat.com>
Tested-by: David Teigland <teigland@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index a01b8fd..64915ee 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1750,6 +1750,10 @@ static ssize_t gfs2_getxattr(struct dentry *dentry, const char *name,
 	struct gfs2_holder gh;
 	int ret;
 
+	/* For selinux during lookup */
+	if (gfs2_glock_is_locked_by_me(ip->i_gl))
+		return generic_getxattr(dentry, name, data, size);
+
 	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
 	ret = gfs2_glock_nq(&gh);
 	if (ret == 0) {
-- 
1.7.4

