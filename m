Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaBGMIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:08:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbaBGLv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 178/233] vfs: Is mounted should be testing mnt_ns for NULL or error.
Date: Fri,  7 Feb 2014 11:46:37 +0000
Message-Id: <1391773652-25214-179-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 260a459d2e39761fbd39803497205ce1690bc7b1 upstream.

A bug was introduced with the is_mounted helper function in
commit f7a99c5b7c8bd3d3f533c8b38274e33f3da9096e
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Jun 9 00:59:08 2012 -0400

    get rid of ->mnt_longterm

    it's enough to set ->mnt_ns of internal vfsmounts to something
    distinct from all struct mnt_namespace out there; then we can
    just use the check for ->mnt_ns != NULL in the fast path of
    mntput_no_expire()

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

The intent was to test if the real_mount(vfsmount)->mnt_ns was
NULL_OR_ERR but the code is actually testing real_mount(vfsmount)
and always returning true.

The result is d_absolute_path returning paths it should be hiding.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/mount.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/mount.h b/fs/mount.h
index 64a8581..68d80bd 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -73,7 +73,7 @@ static inline int mnt_has_parent(struct mount *mnt)
 static inline int is_mounted(struct vfsmount *mnt)
 {
 	/* neither detached nor internal? */
-	return !IS_ERR_OR_NULL(real_mount(mnt));
+	return !IS_ERR_OR_NULL(real_mount(mnt)->mnt_ns);
 }
 
 extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
-- 
1.8.3.2

