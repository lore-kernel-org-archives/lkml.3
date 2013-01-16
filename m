Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab3APHF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:05:29 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34057 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3APHF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:05:28 -0500
Date: Wed, 16 Jan 2013 15:04:25 +0800
From: yanyg <yanyg02@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: sysfs_update_group always fails and generates a
 WARNING CALL-trace
Message-ID: <20130116070425.GA3972@yvit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@sysfs_update_group@ always fails and borns a WARNING CALL-trace
if the group exists. BUT still now, no *reference* of this routine at all.

>From fe40df7d716658a1fbdab79768628c81d4363428 Mon Sep 17 00:00:00 2001
From: yanyg <yanyg02@gmail.com>
Date: Wed, 16 Jan 2013 11:25:15 +0800
Subject: [PATCH] sysfs-fixes:

@sysfs_update_group@ always fail and generates WARNING CALL trace.
fix @internal_create_group@ to avoid it.
---
 fs/sysfs/group.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 2df555c..51fcf62 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -60,7 +60,7 @@ static int internal_create_group(struct kobject *kobj, int update,
 				 const struct attribute_group *grp)
 {
 	struct sysfs_dirent *sd;
-	int error;
+	int error, do_put = 0;
 
 	BUG_ON(!kobj || (!update && !kobj->sd));
 
@@ -73,9 +73,14 @@ static int internal_create_group(struct kobject *kobj, int update,
 		return -EINVAL;
 	}
 	if (grp->name) {
-		error = sysfs_create_subdir(kobj, grp->name, &sd);
-		if (error)
-			return error;
+		sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
+		if (sd) {
+			do_put = 1;
+		} else {
+			error = sysfs_create_subdir(kobj, grp->name, &sd);
+			if (error)
+				return error;
+		}
 	} else
 		sd = kobj->sd;
 	sysfs_get(sd);
@@ -85,6 +90,7 @@ static int internal_create_group(struct kobject *kobj, int update,
 			sysfs_remove_subdir(sd);
 	}
 	sysfs_put(sd);
+	if (do_put) sysfs_put(sd);
 	return error;
 }
 
-- 
1.7.2.5

