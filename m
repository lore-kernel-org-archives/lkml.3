Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaELTCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:02:50 -0400
Received: from mout.gmx.net ([212.227.15.15]:56864 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbaELTCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:02:48 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1 v2] fanotify: check file flags passed in fanotify_init
Date: Mon, 12 May 2014 21:02:16 +0200
Message-Id: <1399921336-6433-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.0.0.rc0
X-Provags-ID: V03:K0:Ne3cB0AjR4ddWzj1q1kv2RHxIjh347UoKKYKAO3VUgljuhAGkXW
 HrZ2IOGx7CNOv+nByzrFVc9A/wVV5hZRQjdqXGj7AMKIB+rM9LMI0pxZ/KnGj3DAdfgcGTx
 nQScFX84t/h003RS9ISQhA1vt1FdbjM8hQkb6l+KzRT/jhVTo+YYFyfFOdmRDk04wgmB9MD
 YnNpBwJY4/+3Bv+/3TjWQ==
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

Jan Kara and Eric Paris both aggreed that this is a bug and the value of
event_f_flags should be checked:
https://lkml.org/lkml/2014/4/29/522
https://lkml.org/lkml/2014/4/29/539

This updated patch version considers the comments by Michael Kerrisk in
https://lkml.org/lkml/2014/5/4/10

With the patch the value of event_f_flags is checked.
When specifying an invalid value error EINVAL is returned.

Internal flags are disallowed.

File creation flags are disallowed:
O_CREAT, O_DIRECTORY, O_EXCL, O_NOCTTY, O_NOFOLLOW, O_TRUNC, and O_TTY_INIT.

Flags which do not make sense with fanotify are disallowed:
__O_TMPFILE, O_PATH, FASYNC, and O_DIRECT.

This leaves us with the following allowed values:

O_RDONLY, O_WRONLY, O_RDWR are basic functionality. The are stored in the
bits given by O_ACCMODE.

O_APPEND is working as expected. The value might be useful in a logging
application which appends the current status each time the log is opened.

O_LARGEFILE is needed for files exceeding 4GB on 32bit systems.

O_NONBLOCK may be useful when monitoring slow devices like tapes.

O_NDELAY is equal to O_NONBLOCK except for platform parisc.
To avoid code breaking on parisc either both flags should be
allowed or none. The patch allows both.

__O_SYNC and O_DSYNC may be used to avoid data loss on power disruption.

O_NOATIME may be useful to reduce disk activity.

O_CLOEXEC may be useful, if separate processes shall be used to scan files.

Once this patch is accepted, the fanotify_init.2 manpage has to be updated.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index d42220f..31b0de2 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -25,6 +25,19 @@
 #define FANOTIFY_DEFAULT_MAX_MARKS	8192
 #define FANOTIFY_DEFAULT_MAX_LISTENERS	128
 
+/*
+ * All flags that may be specified in parameter event_f_flags of fanotify_init.
+ *
+ * Internal and external open flags are stored together in field f_flags of
+ * struct file. Only external open flags shall be allowed in event_f_flags.
+ * Internal flags like FMODE_NONOTIFY, FMODE_EXEC, FMODE_NOCMTIME shall be
+ * excluded.
+ */
+#define	FANOTIFY_INIT_ALL_EVENT_F_BITS				( \
+		O_ACCMODE	| O_APPEND	| O_NONBLOCK	| \
+		__O_SYNC	| O_DSYNC	| O_CLOEXEC     | \
+		O_LARGEFILE	| O_NOATIME	)
+
 extern const struct fsnotify_ops fanotify_fsnotify_ops;
 
 static struct kmem_cache *fanotify_mark_cache __read_mostly;
@@ -669,6 +682,18 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	if (flags & ~FAN_ALL_INIT_FLAGS)
 		return -EINVAL;
 
+	if (event_f_flags & ~FANOTIFY_INIT_ALL_EVENT_F_BITS)
+		return -EINVAL;
+
+	switch (event_f_flags & O_ACCMODE) {
+	case O_RDONLY:
+	case O_RDWR:
+	case O_WRONLY:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	user = get_current_user();
 	if (atomic_read(&user->fanotify_listeners) > FANOTIFY_DEFAULT_MAX_LISTENERS) {
 		free_uid(user);
-- 
2.0.0.rc0

