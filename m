Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3CAT7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:59:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3CATqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tero Roponen <tero.roponen@gmail.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 31/46] fuse: dont WARN when nlink is zero
Date: Fri,  1 Mar 2013 11:45:19 -0800
Message-Id: <20130301194435.523293252@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -645,7 +645,14 @@ static int fuse_unlink(struct inode *dir
 
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


