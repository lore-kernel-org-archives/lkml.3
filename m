Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533Ab3BSTHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:07:55 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:30360 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427Ab3BSSwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:25 -0500
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] dcache: don't need to take d_lock in prepend_path()
Date: Tue, 19 Feb 2013 13:50:59 -0500
Message-Id: <1361299859-27056-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
References: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
To: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The d_lock was used in prepend_path() to protect dentry->d_name from
being changed under the hood. As the caller of prepend_path() has
to take the rename_lock before calling into it, there is no chance
that d_name will be changed. The d_lock lock is only needed when the
rename_lock is not taken.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index b1487e2..0e911fc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2547,6 +2547,7 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * @buflen: pointer to buffer length
  *
  * Caller holds the rename_lock.
+ * There is no need to lock the dentry as its name cannot be changed.
  */
 static int prepend_path(const struct path *path,
 			const struct path *root,
@@ -2573,9 +2574,7 @@ static int prepend_path(const struct path *path,
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
 		error = prepend_name(buffer, buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
 		if (!error)
 			error = prepend(buffer, buflen, "/", 1);
 		if (error)
-- 
1.7.1

