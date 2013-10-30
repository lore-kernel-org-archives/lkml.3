Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3J3UXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:23:30 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:61852 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3J3UW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:22:27 -0400
Message-Id: <20131030202221.465984061@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 Oct 2013 23:59:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 5/6] fsnotify: Use sequential fdinfo engine
References: <20131030195951.201688764@openvz.org>
Content-Disposition: inline; filename=0005-procfs-notify
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/notify/fanotify/fanotify_user.c |    4 -
 fs/notify/fdinfo.c                 |  121 +++++++++++++++++++++++++------------
 fs/notify/fdinfo.h                 |   12 ---
 fs/notify/inotify/inotify_user.c   |    4 -
 4 files changed, 94 insertions(+), 47 deletions(-)

Index: linux-2.6.git/fs/notify/fanotify/fanotify_user.c
===================================================================
--- linux-2.6.git.orig/fs/notify/fanotify/fanotify_user.c
+++ linux-2.6.git/fs/notify/fanotify/fanotify_user.c
@@ -432,7 +432,9 @@ static long fanotify_ioctl(struct file *
 }
 
 static const struct file_operations fanotify_fops = {
-	.show_fdinfo	= fanotify_show_fdinfo,
+#ifdef CONFIG_PROC_FS
+	.fdinfo_ops	= &fanotify_fdinfo_ops,
+#endif
 	.poll		= fanotify_poll,
 	.read		= fanotify_read,
 	.write		= fanotify_write,
Index: linux-2.6.git/fs/notify/fdinfo.c
===================================================================
--- linux-2.6.git.orig/fs/notify/fdinfo.c
+++ linux-2.6.git/fs/notify/fdinfo.c
@@ -16,25 +16,50 @@
 #include "inotify/inotify.h"
 #include "../fs/mount.h"
 
+#define seq_notify_group(m) ((struct file*)(m)->private)->private_data
+
 #if defined(CONFIG_PROC_FS)
 
 #if defined(CONFIG_INOTIFY_USER) || defined(CONFIG_FANOTIFY)
 
-static int show_fdinfo(struct seq_file *m, struct file *f,
-		       int (*show)(struct seq_file *m, struct fsnotify_mark *mark))
+static void *notify_start(struct seq_file *m, loff_t *pos,
+			  void *(*__start)(struct seq_file *m, loff_t *pos,
+					   struct fsnotify_group *group,
+					   struct fsnotify_mark *mark))
 {
-	struct fsnotify_group *group = f->private_data;
+	struct fsnotify_group *group = seq_notify_group(m);
 	struct fsnotify_mark *mark;
-	int ret = 0;
+	loff_t num = *pos;
 
 	mutex_lock(&group->mark_mutex);
 	list_for_each_entry(mark, &group->marks_list, g_list) {
-		ret = show(m, mark);
-		if (ret)
-			break;
+		if (num-- == 0) {
+			if (__start)
+				return __start(m, pos, group, mark);
+			return mark;
+		}
 	}
+
+	return NULL;
+}
+
+static void notify_stop(struct seq_file *m, void *v)
+{
+	struct fsnotify_group *group = seq_notify_group(m);
 	mutex_unlock(&group->mark_mutex);
-	return ret;
+}
+
+static void *notify_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct fsnotify_group *group = seq_notify_group(m);
+	struct fsnotify_mark *mark = p;
+
+	if (!list_is_last(&mark->g_list, &group->marks_list))
+		mark = list_first_entry(&mark->g_list, struct fsnotify_mark, g_list);
+	else
+		mark = NULL;
+	++*pos;
+	return mark;
 }
 
 #if defined(CONFIG_EXPORTFS)
@@ -75,9 +100,15 @@ static int show_mark_fhandle(struct seq_
 
 #ifdef CONFIG_INOTIFY_USER
 
-static int inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
+static void *inotify_start(struct seq_file *m, loff_t *pos)
+{
+	return notify_start(m, pos, NULL);
+}
+
+static int inotify_show(struct seq_file *m, void *v)
 {
 	struct inotify_inode_mark *inode_mark;
+	struct fsnotify_mark *mark = v;
 	struct inode *inode;
 	int ret = 0;
 
@@ -100,17 +131,20 @@ static int inotify_fdinfo(struct seq_fil
 	return ret;
 }
 
-int inotify_show_fdinfo(struct seq_file *m, struct file *f)
-{
-	return show_fdinfo(m, f, inotify_fdinfo);
-}
+struct seq_operations inotify_fdinfo_ops = {
+	.start		= inotify_start,
+	.next		= notify_next,
+	.stop		= notify_stop,
+	.show		= inotify_show,
+};
 
 #endif /* CONFIG_INOTIFY_USER */
 
 #ifdef CONFIG_FANOTIFY
 
-static int fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
+static int fanotify_show(struct seq_file *m, void *v)
 {
+	struct fsnotify_mark *mark = v;
 	unsigned int mflags = 0;
 	struct inode *inode;
 	int ret = 0;
@@ -143,35 +177,50 @@ out:
 	return ret;
 }
 
-int fanotify_show_fdinfo(struct seq_file *m, struct file *f)
-{
-	struct fsnotify_group *group = f->private_data;
-	unsigned int flags = 0;
+static void *__fanotify_start(struct seq_file *m, loff_t *pos,
+			      struct fsnotify_group *group,
+			      struct fsnotify_mark *mark)
+{
+	if (*pos == 0) {
+		unsigned int flags = 0;
+
+		switch (group->priority) {
+		case FS_PRIO_0:
+			flags |= FAN_CLASS_NOTIF;
+			break;
+		case FS_PRIO_1:
+			flags |= FAN_CLASS_CONTENT;
+			break;
+		case FS_PRIO_2:
+			flags |= FAN_CLASS_PRE_CONTENT;
+			break;
+		}
 
-	switch (group->priority) {
-	case FS_PRIO_0:
-		flags |= FAN_CLASS_NOTIF;
-		break;
-	case FS_PRIO_1:
-		flags |= FAN_CLASS_CONTENT;
-		break;
-	case FS_PRIO_2:
-		flags |= FAN_CLASS_PRE_CONTENT;
-		break;
-	}
+		if (group->max_events == UINT_MAX)
+			flags |= FAN_UNLIMITED_QUEUE;
 
-	if (group->max_events == UINT_MAX)
-		flags |= FAN_UNLIMITED_QUEUE;
+		if (group->fanotify_data.max_marks == UINT_MAX)
+			flags |= FAN_UNLIMITED_MARKS;
 
-	if (group->fanotify_data.max_marks == UINT_MAX)
-		flags |= FAN_UNLIMITED_MARKS;
+		seq_printf(m, "fanotify flags:%x event-flags:%x\n",
+			   flags, group->fanotify_data.f_flags);
+	}
 
-	seq_printf(m, "fanotify flags:%x event-flags:%x\n",
-		   flags, group->fanotify_data.f_flags);
+	return mark;
+}
 
-	return show_fdinfo(m, f, fanotify_fdinfo);
+static void *fanotify_start(struct seq_file *m, loff_t *pos)
+{
+	return notify_start(m, pos, __fanotify_start);
 }
 
+struct seq_operations fanotify_fdinfo_ops = {
+	.start		= fanotify_start,
+	.next		= notify_next,
+	.stop		= notify_stop,
+	.show		= fanotify_show,
+};
+
 #endif /* CONFIG_FANOTIFY */
 
 #endif /* CONFIG_INOTIFY_USER || CONFIG_FANOTIFY */
Index: linux-2.6.git/fs/notify/fdinfo.h
===================================================================
--- linux-2.6.git.orig/fs/notify/fdinfo.h
+++ linux-2.6.git/fs/notify/fdinfo.h
@@ -4,24 +4,18 @@
 #include <linux/errno.h>
 #include <linux/proc_fs.h>
 
-struct seq_file;
-struct file;
+struct seq_operations;
 
 #ifdef CONFIG_PROC_FS
 
 #ifdef CONFIG_INOTIFY_USER
-extern int inotify_show_fdinfo(struct seq_file *m, struct file *f);
+extern struct seq_operations inotify_fdinfo_ops;
 #endif
 
 #ifdef CONFIG_FANOTIFY
-extern int fanotify_show_fdinfo(struct seq_file *m, struct file *f);
+extern struct seq_operations fanotify_fdinfo_ops;
 #endif
 
-#else /* CONFIG_PROC_FS */
-
-#define inotify_show_fdinfo	NULL
-#define fanotify_show_fdinfo	NULL
-
 #endif /* CONFIG_PROC_FS */
 
 #endif /* __FSNOTIFY_FDINFO_H__ */
Index: linux-2.6.git/fs/notify/inotify/inotify_user.c
===================================================================
--- linux-2.6.git.orig/fs/notify/inotify/inotify_user.c
+++ linux-2.6.git/fs/notify/inotify/inotify_user.c
@@ -327,7 +327,9 @@ static long inotify_ioctl(struct file *f
 }
 
 static const struct file_operations inotify_fops = {
-	.show_fdinfo	= inotify_show_fdinfo,
+#ifdef CONFIG_PROC_FS
+	.fdinfo_ops	= &inotify_fdinfo_ops,
+#endif
 	.poll		= inotify_poll,
 	.read		= inotify_read,
 	.fasync		= fsnotify_fasync,

