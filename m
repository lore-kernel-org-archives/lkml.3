Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaEAPgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:36:13 -0400
Received: from mout.gmx.net ([212.227.15.18]:57907 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209AbaEAPgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:36:09 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] fanotify: check file flags passed in fanotify_init
Date: Thu,  1 May 2014 17:35:32 +0200
Message-Id: <1398958532-11221-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.9.2
X-Provags-ID: V03:K0:tK8Jy3I4eN4a850Gis1Z4cz7h3fcTXTRzPbY04IWBn3PKDykXRU
 XKjT0+hDGTDTemzUIXLJjt/sp8vXPGJo9AnZtg1JvrNJcq19t+Edw/jpmG50sHc0Xo13+0/
 Hm/vEJ0xWGREjl8moYzs0RFZ9cVq92LLHS9Gyb57q/AJujcZsDgf+RLd1Us2XQcFk2OGBqs
 EkQyDwOwj1tiYAyj5X9Nw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch fanotify_init does not validate the value passed in
event_f_flags.

When a fanotify event is read from the fanotify file descriptor a new file
descriptor is created where file.f_flags = event_f_flags.

Internal and external open flags are stored together in field f_flags of
struct file. Hence, an application might create file descriptors with
internal flags like FMODE_EXEC, FMODE_NOCMTIME set.

With the patch the value of event_f_flags is checked. Only external open flags
are allowed. When specifying an invalid value error EINVAL is returned.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 4e565c8..3e456d7 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -25,6 +25,21 @@
 #define FANOTIFY_DEFAULT_MAX_MARKS	8192
 #define FANOTIFY_DEFAULT_MAX_LISTENERS	128
 
+/*
+ * All flags that may be specified in parameter event_f_flags of fanotify_init.
+ * 
+ * Internal and external open flags are stored together in field f_flags of
+ * struct file. Only external open flags shall be allowed in event_f_flags.
+ * Internal flags like FMODE_EXEC shall be excluded.
+ */
+#define FANOTIFY_INIT_ALL_EVENT_F_FLAGS				( \
+		O_RDONLY	| O_WRONLY	| O_RDWR	| \
+		O_CREAT		| O_EXCL	| O_NOCTTY	| \
+		O_TRUNC		| O_APPEND	| O_NONBLOCK	| \
+		__O_SYNC	| O_DSYNC	| FASYNC	| \
+		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	| \
+		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	| \
+		O_PATH		| __O_TMPFILE	| O_NDELAY	)
 extern const struct fsnotify_ops fanotify_fsnotify_ops;
 
 static struct kmem_cache *fanotify_mark_cache __read_mostly;
@@ -669,6 +684,9 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	if (flags & ~FAN_ALL_INIT_FLAGS)
 		return -EINVAL;
 
+	if (event_f_flags & ~FANOTIFY_INIT_ALL_EVENT_F_FLAGS)
+		return -EINVAL;
+
 	user = get_current_user();
 	if (atomic_read(&user->fanotify_listeners) > FANOTIFY_DEFAULT_MAX_LISTENERS) {
 		free_uid(user);
-- 
1.9.2

