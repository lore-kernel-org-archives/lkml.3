Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaEEN0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:26:48 -0400
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:59591 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932272AbaEEN0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:26:47 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 May 2014 09:26:47 EDT
From: Robert ABEL <rabel@cit-ec.uni-bielefeld.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Robert ABEL <rabel@cit-ec.uni-bielefeld.de>
Subject: [PATCH RESEND] sysfs: fix attribute_group bin file path on removal
Date: Mon,  5 May 2014 15:17:20 +0200
Message-Id: <1399295840-3714-1-git-send-email-rabel@cit-ec.uni-bielefeld.de>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cody Schafer already fixed binary file creation for attribute groups, see [1].
This patch makes the appropriate changes for binary file removal
of attribute groups.
[1]: http://lkml.org/lkml/2014/2/27/832

Signed-off-by: Robert ABEL <rabel@cit-ec.uni-bielefeld.de>
---
 fs/sysfs/group.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index aa04068..7d2a860 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -18,7 +18,7 @@
 #include "sysfs.h"
 
 
-static void remove_files(struct kernfs_node *parent, struct kobject *kobj,
+static void remove_files(struct kernfs_node *parent,
 			 const struct attribute_group *grp)
 {
 	struct attribute *const *attr;
@@ -29,7 +29,7 @@ static void remove_files(struct kernfs_node *parent, struct kobject *kobj,
 			kernfs_remove_by_name(parent, (*attr)->name);
 	if (grp->bin_attrs)
 		for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++)
-			sysfs_remove_bin_file(kobj, *bin_attr);
+			kernfs_remove_by_name(parent, (*bin_attr)->attr.name);
 }
 
 static int create_files(struct kernfs_node *parent, struct kobject *kobj,
@@ -62,7 +62,7 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
 				break;
 		}
 		if (error) {
-			remove_files(parent, kobj, grp);
+			remove_files(parent, grp);
 			goto exit;
 		}
 	}
@@ -79,7 +79,7 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
 				break;
 		}
 		if (error)
-			remove_files(parent, kobj, grp);
+			remove_files(parent, grp);
 	}
 exit:
 	return error;
@@ -224,7 +224,7 @@ void sysfs_remove_group(struct kobject *kobj,
 		kernfs_get(kn);
 	}
 
-	remove_files(kn, kobj, grp);
+	remove_files(kn, grp);
 	if (grp->name)
 		kernfs_remove(kn);
 
-- 
1.9.2

