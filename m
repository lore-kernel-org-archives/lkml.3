Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaDUKFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:05:11 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:56292 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaDUKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:05:07 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Mon, 21 Apr 2014 13:05:03 +0300
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Subject: [PATCH] xfs: Fix wrong error codes being returned
Date: Mon, 21 Apr 2014 13:04:47 +0300
Message-Id: <1398074687-26548-1-git-send-email-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xfs_{compat_,}attrmulti_by_handle could return an errno with incorrect
sign in some cases. While at it, make sure ENOMEM is returned instead of
E2BIG if kmalloc fails.

Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
---
Compile tested only. For the ERANGE case, I also wonder if it should
be assigning to ops[i].am_error instead of error, and/or have a break.

 fs/xfs/xfs_ioctl.c   |    5 +++--
 fs/xfs/xfs_ioctl32.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0b18776..2d8f4fd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -543,10 +543,11 @@ xfs_attrmulti_by_handle(
 
 	ops = memdup_user(am_hreq.ops, size);
 	if (IS_ERR(ops)) {
-		error = PTR_ERR(ops);
+		error = -PTR_ERR(ops);
 		goto out_dput;
 	}
 
+	error = ENOMEM;
 	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
 	if (!attr_name)
 		goto out_kfree_ops;
@@ -556,7 +557,7 @@ xfs_attrmulti_by_handle(
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
 				ops[i].am_attrname, MAXNAMELEN);
 		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
-			error = -ERANGE;
+			error = ERANGE;
 		if (ops[i].am_error < 0)
 			break;
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index a7992f8..944d5ba 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -424,10 +424,11 @@ xfs_compat_attrmulti_by_handle(
 
 	ops = memdup_user(compat_ptr(am_hreq.ops), size);
 	if (IS_ERR(ops)) {
-		error = PTR_ERR(ops);
+		error = -PTR_ERR(ops);
 		goto out_dput;
 	}
 
+	error = ENOMEM;
 	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
 	if (!attr_name)
 		goto out_kfree_ops;
@@ -438,7 +439,7 @@ xfs_compat_attrmulti_by_handle(
 				compat_ptr(ops[i].am_attrname),
 				MAXNAMELEN);
 		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
-			error = -ERANGE;
+			error = ERANGE;
 		if (ops[i].am_error < 0)
 			break;
 
-- 
1.7.9.5

