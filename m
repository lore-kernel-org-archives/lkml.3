Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935206AbaBDV36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:29:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628AbaBDVMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.13 103/140] vfs: Is mounted should be testing mnt_ns for NULL or error.
Date: Tue,  4 Feb 2014 13:11:30 -0800
Message-Id: <20140204211039.914893806@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/mount.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/mount.h
+++ b/fs/mount.h
@@ -74,7 +74,7 @@ static inline int mnt_has_parent(struct
 static inline int is_mounted(struct vfsmount *mnt)
 {
 	/* neither detached nor internal? */
-	return !IS_ERR_OR_NULL(real_mount(mnt));
+	return !IS_ERR_OR_NULL(real_mount(mnt)->mnt_ns);
 }
 
 extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *);


