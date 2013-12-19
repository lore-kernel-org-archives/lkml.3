Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3LSLzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:55:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44351 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3LSLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 001/208] GFS2: Fix ref count bug relating to atomic_open
Date: Thu, 19 Dec 2013 11:51:39 +0000
Message-Id: <1387454106-19326-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit ea0341e071527d5cec350917b01ab901af09d758 upstream.

In the case that atomic_open calls finish_no_open() with
the dentry that was supplied to gfs2_atomic_open() an
extra reference count is required. This patch fixes that
issue preventing a bug trap triggering at umount time.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/gfs2/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index cd58611..e4bd52f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1166,8 +1166,11 @@ static int gfs2_atomic_open(struct inode *dir, struct dentry *dentry,
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
-- 
1.8.3.2

