Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbbAPV3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 16:29:40 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:64423 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbbAPV3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 16:29:38 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@savoirfairelinux.com
Subject: [PATCH] sysfs: group: allow is_visible to drop permissions
Date: Fri, 16 Jan 2015 16:29:10 -0500
Message-Id: <1421443750-12935-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the optional is_visible function, it is actually possible to
either hide an attribute, or add a new permission, but not remove one.

This commit uses all the UGO bits returned by is_visible instead of
OR'ing them with the default attribute mode.

Concretely, this allows a driver to use macros like DEVICE_ATTR_RW to
set the attribute show and store functions and remove the S_IWUSR
permission in is_visible if the implementation doesn't provide a setter.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 fs/sysfs/group.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 7d2a860..a8cfe03 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -41,7 +41,7 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
 
 	if (grp->attrs) {
 		for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
-			umode_t mode = 0;
+			umode_t mode = (*attr)->mode;
 
 			/*
 			 * In update mode, we're changing the permissions or
@@ -51,13 +51,15 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
 			if (update)
 				kernfs_remove_by_name(parent, (*attr)->name);
 			if (grp->is_visible) {
-				mode = grp->is_visible(kobj, *attr, i);
-				if (!mode)
+				umode_t ugo = grp->is_visible(kobj, *attr, i);
+
+				if (!(ugo & S_IRWXUGO))
 					continue;
+
+				mode = (mode & ~S_IRWXUGO) | (ugo & S_IRWXUGO);
 			}
 			error = sysfs_add_file_mode_ns(parent, *attr, false,
-						       (*attr)->mode | mode,
-						       NULL);
+						       mode, NULL);
 			if (unlikely(error))
 				break;
 		}
-- 
2.2.2

