Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3CATp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3CATpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tero Roponen <tero.roponen@gmail.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 59/77] fuse: dont WARN when nlink is zero
Date: Fri,  1 Mar 2013 11:44:44 -0800
Message-Id: <20130301194358.183293958@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit dfca7cebc2679f3d129f8e680a8f199a7ad16e38 upstream.

drop_nlink() warns if nlink is already zero.  This is triggerable by a buggy
userspace filesystem.  The cure, I think, is worse than the disease so disable
the warning.

Reported-by: Tero Roponen <tero.roponen@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -682,7 +682,14 @@ static int fuse_unlink(struct inode *dir
 
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


