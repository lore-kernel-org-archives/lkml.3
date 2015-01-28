Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbbA2BWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:22:54 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33850 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbbA2BWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:22:14 -0500
From: Dan Ehrenberg <dehrenberg@chromium.org>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
Cc: gwendal@chromium.org, grundler@chromium.org, drewry@chromium.org,
        Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH 1/2] init: Stricter checking of major:minor root= values
Date: Wed, 28 Jan 2015 14:45:56 -0800
Message-Id: <1422485157-33423-1-git-send-email-dehrenberg@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kernel command-line, previously, root=1:2jakshflaksjdhfa would
be accepted and interpreted just like root=1:2. This patch adds
stricter checking so that additional characters after major:minor are
rejected by root=.

The patch also makes name_to_dev_t take a const char * rather than a
char * for improved possibilities for checking const correctness.

The goal of this patch is to help in unifying dm's interpretation of
its block device argument with the interpretation in other parts of
the kernel. dm rejects malformed major:minor pairs, and it seems
reasonable that root= should reject them as well.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 include/linux/mount.h | 2 +-
 init/do_mounts.c      | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/mount.h b/include/linux/mount.h
index c2c561d..bca086d 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -92,6 +92,6 @@ extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
-extern dev_t name_to_dev_t(char *name);
+extern dev_t name_to_dev_t(const char *name);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index eb41008..7e06620 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -207,7 +207,7 @@ done:
  *	bangs.
  */
 
-dev_t name_to_dev_t(char *name)
+dev_t name_to_dev_t(const char *name)
 {
 	char s[32];
 	char *p;
@@ -226,8 +226,9 @@ dev_t name_to_dev_t(char *name)
 
 	if (strncmp(name, "/dev/", 5) != 0) {
 		unsigned maj, min;
+		char dummy;
 
-		if (sscanf(name, "%u:%u", &maj, &min) == 2) {
+		if (sscanf(name, "%u:%u%c", &maj, &min, &dummy) == 2) {
 			res = MKDEV(maj, min);
 			if (maj != MAJOR(res) || min != MINOR(res))
 				goto fail;
-- 
2.2.0.rc0.207.ga3a616c

