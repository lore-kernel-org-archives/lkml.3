Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3LBTgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:36:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3LBTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.12 175/212] GFS2: Fix ref count bug relating to atomic_open
Date: Mon,  2 Dec 2013 11:16:06 -0800
Message-Id: <20131202191307.752864365@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit ea0341e071527d5cec350917b01ab901af09d758 upstream.

In the case that atomic_open calls finish_no_open() with
the dentry that was supplied to gfs2_atomic_open() an
extra reference count is required. This patch fixes that
issue preventing a bug trap triggering at umount time.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1168,8 +1168,11 @@ static int gfs2_atomic_open(struct inode
 	if (d != NULL)
 		dentry = d;
 	if (dentry->d_inode) {
-		if (!(*opened & FILE_OPENED))
+		if (!(*opened & FILE_OPENED)) {
+			if (d == NULL)
+				dget(dentry);
 			return finish_no_open(file, dentry);
+		}
 		dput(d);
 		return 0;
 	}


