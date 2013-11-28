Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab3K1UBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:01:24 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:53923 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab3K1TzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:15 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/34] sysfs, kernfs: introduce kernfs_notify()
Date: Thu, 28 Nov 2013 14:54:27 -0500
Message-Id: <1385668487-10181-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kernfs interface to wake up poll(2) which takes and returns
sysfs_dirents.

sysfs_notify_dirent() is renamed to kernfs_notify() and sysfs_notify()
is updated so that it doesn't directly grab sysfs_mutex but acquires
the target sysfs_dirents using sysfs_get_dirent().
sysfs_notify_dirent() is reimplemented as a dumb inline wrapper around
kernfs_notify().

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c        | 33 ++++++++++++++++++++++-----------
 include/linux/kernfs.h |  3 +++
 include/linux/sysfs.h  |  9 +++++----
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 74e3478..a68cbef 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -851,7 +851,13 @@ static unsigned int kernfs_file_poll(struct file *filp, poll_table *wait)
 	return DEFAULT_POLLMASK|POLLERR|POLLPRI;
 }
 
-void sysfs_notify_dirent(struct sysfs_dirent *sd)
+/**
+ * kernfs_notify - notify a kernfs file
+ * @sd: file to notify
+ *
+ * Notify @sd such that poll(2) on @sd wakes up.
+ */
+void kernfs_notify(struct sysfs_dirent *sd)
 {
 	struct sysfs_open_dirent *od;
 	unsigned long flags;
@@ -868,22 +874,27 @@ void sysfs_notify_dirent(struct sysfs_dirent *sd)
 
 	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
 }
-EXPORT_SYMBOL_GPL(sysfs_notify_dirent);
+EXPORT_SYMBOL_GPL(kernfs_notify);
 
 void sysfs_notify(struct kobject *k, const char *dir, const char *attr)
 {
-	struct sysfs_dirent *sd = k->sd;
-
-	mutex_lock(&sysfs_mutex);
+	struct sysfs_dirent *sd = k->sd, *tmp;
 
 	if (sd && dir)
-		sd = sysfs_find_dirent(sd, dir, NULL);
-	if (sd && attr)
-		sd = sysfs_find_dirent(sd, attr, NULL);
-	if (sd)
-		sysfs_notify_dirent(sd);
+		sd = sysfs_get_dirent(sd, dir);
+	else
+		sysfs_get(sd);
 
-	mutex_unlock(&sysfs_mutex);
+	if (sd && attr) {
+		tmp = sysfs_get_dirent(sd, attr);
+		sysfs_put(sd);
+		sd = tmp;
+	}
+
+	if (sd) {
+		kernfs_notify(sd);
+		sysfs_put(sd);
+	}
 }
 EXPORT_SYMBOL_GPL(sysfs_notify);
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index ba993eb..f20796e 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -84,6 +84,7 @@ int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 		     const char *new_name, const void *new_ns);
 void kernfs_enable_ns(struct sysfs_dirent *sd);
 int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr);
+void kernfs_notify(struct sysfs_dirent *sd);
 
 #else	/* CONFIG_SYSFS */
 
@@ -120,6 +121,8 @@ static inline int kernfs_setattr(struct sysfs_dirent *sd,
 				 const struct iattr *iattr)
 { return -ENOSYS; }
 
+static inline void kernfs_notify(struct sysfs_dirent *sd) { }
+
 #endif	/* CONFIG_SYSFS */
 
 static inline struct sysfs_dirent *
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2bc735d..0ab2b02 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -243,7 +243,6 @@ void sysfs_remove_link_from_group(struct kobject *kobj, const char *group_name,
 				  const char *link_name);
 
 void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
-void sysfs_notify_dirent(struct sysfs_dirent *sd);
 struct sysfs_dirent *sysfs_get_dirent_ns(struct sysfs_dirent *parent_sd,
 					 const unsigned char *name,
 					 const void *ns);
@@ -418,9 +417,6 @@ static inline void sysfs_notify(struct kobject *kobj, const char *dir,
 				const char *attr)
 {
 }
-static inline void sysfs_notify_dirent(struct sysfs_dirent *sd)
-{
-}
 static inline struct sysfs_dirent *
 sysfs_get_dirent_ns(struct sysfs_dirent *parent_sd, const unsigned char *name,
 		    const void *ns)
@@ -466,4 +462,9 @@ sysfs_get_dirent(struct sysfs_dirent *parent_sd, const unsigned char *name)
 	return sysfs_get_dirent_ns(parent_sd, name, NULL);
 }
 
+static inline void sysfs_notify_dirent(struct sysfs_dirent *sd)
+{
+	kernfs_notify(sd);
+}
+
 #endif /* _SYSFS_H_ */
-- 
1.8.4.2

