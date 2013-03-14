Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab3CNKhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51910 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab3CNKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 44/88] fuse: don't WARN when nlink is zero
Date: Thu, 14 Mar 2013 10:35:37 +0000
Message-Id: <1363257381-15900-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit dfca7cebc2679f3d129f8e680a8f199a7ad16e38 upstream.

drop_nlink() warns if nlink is already zero.  This is triggerable by a buggy
userspace filesystem.  The cure, I think, is worse than the disease so disable
the warning.

Reported-by: Tero Roponen <tero.roponen@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/fuse/dir.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 334e0b1..f6e4bc8 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -645,7 +645,14 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 		spin_lock(&fc->lock);
 		fi->attr_version = ++fc->attr_version;
-		drop_nlink(inode);
+		/*
+		 * If i_nlink == 0 then unlink doesn't make sense, yet this can
+		 * happen if userspace filesystem is careless.  It would be
+		 * difficult to enforce correct nlink usage so just ignore this
+		 * condition here
+		 */
+		if (inode->i_nlink > 0)
+			drop_nlink(inode);
 		spin_unlock(&fc->lock);
 		fuse_invalidate_attr(inode);
 		fuse_invalidate_attr(dir);
-- 
1.8.1.2

