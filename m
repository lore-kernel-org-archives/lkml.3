Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3IRXa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:30:28 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35017 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab3IRXa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:30:26 -0400
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v3 RFT 1/2] init/do_mounts.c: ignore final \n in name_to_dev_t
Date: Wed, 18 Sep 2013 16:29:01 -0700
Message-Id: <1379546942-22344-2-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379546942-22344-1-git-send-email-sebastian.capella@linaro.org>
References: <1379546942-22344-1-git-send-email-sebastian.capella@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance name_to_dev_t to handle trailing newline characters
on device paths.  Some inputs to name_to_dev_t may come from
userspace where oftentimes a '\n' is appended to the path.
Added const to the name buffer in both the function
declaration and the prototype to reflect input buffer
handling.

By handling trailing newlines in name_to_dev_t, userspace
buffers may be directly passed to name_to_dev_t without
modification.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/mount.h |    2 +-
 init/do_mounts.c      |   25 +++++++++++++++++++------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/mount.h b/include/linux/mount.h
index 73005f9..b024d5c 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -76,6 +76,6 @@ extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
-extern dev_t name_to_dev_t(char *name);
+extern dev_t name_to_dev_t(const char *name);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 816014c..5a031de 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -143,6 +143,13 @@ static dev_t devt_from_partuuid(const char *uuid_str)
 		clear_root_wait = true;
 		goto done;
 	}
+	if (uuid_str[cmp.len - 1] == '\n') {
+		cmp.len--;
+		if (!cmp.len) {
+			clear_root_wait = true;
+			goto done;
+		}
+	}
 
 	dev = class_find_device(&block_class, NULL, &cmp,
 				&match_dev_by_uuid);
@@ -202,12 +209,13 @@ done:
  *	bangs.
  */
 
-dev_t name_to_dev_t(char *name)
+dev_t name_to_dev_t(const char *name)
 {
 	char s[32];
 	char *p;
 	dev_t res = 0;
 	int part;
+	int n;
 
 #ifdef CONFIG_BLOCK
 	if (strncmp(name, "PARTUUID=", 9) == 0) {
@@ -228,7 +236,7 @@ dev_t name_to_dev_t(char *name)
 				goto fail;
 		} else {
 			res = new_decode_dev(simple_strtoul(name, &p, 16));
-			if (*p)
+			if (*p && *p != '\n')
 				goto fail;
 		}
 		goto done;
@@ -236,15 +244,20 @@ dev_t name_to_dev_t(char *name)
 
 	name += 5;
 	res = Root_NFS;
-	if (strcmp(name, "nfs") == 0)
+	if (strncmp(name, "nfs", 3) == 0)
 		goto done;
 	res = Root_RAM0;
-	if (strcmp(name, "ram") == 0)
+	if (strncmp(name, "ram", 3) == 0)
 		goto done;
 
-	if (strlen(name) > 31)
+	n = strlen(name);
+	if (n != 0 && name[n - 1] == '\n')
+		n--;
+	if (n > 31)
 		goto fail;
-	strcpy(s, name);
+	strncpy(s, name, n);
+	s[n] = '\0';
+
 	for (p = s; *p; p++)
 		if (*p == '/')
 			*p = '!';
-- 
1.7.9.5

