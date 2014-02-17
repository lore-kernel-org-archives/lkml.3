Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaBQM76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:59:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbaBQM75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:59:57 -0500
Date: Mon, 17 Feb 2014 13:59:54 +0100
From: Jan Kara <jack@suse.cz>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: inotify cookie regression/info leak in latest mainline
Message-ID: <20140217125954.GD3686@quack.suse.cz>
References: <52FFDE9A.2030109@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <52FFDE9A.2030109@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Sat 15-02-14 22:39:38, Vegard Nossum wrote:
> It would seem that
> 
> commit 7053aee26a3548ebaba046ae2e52396ccf56ac6c
> Author: Jan Kara <jack@suse.cz>
> Date:   Tue Jan 21 15:48:14 2014 -0800
> 
>     fsnotify: do not share events between notification groups
> 
> introduced a bug where the cookie field of struct inotify_event
> never gets initialised. In particular, it used to be initialised
> when send_to_group() called fsnotify_create_event(), but that no
> longer happens, and the 'cookie' parameter of send_to_group() never
> gets used.
> 
> The problem manifests itself in copy_event_to_user() where the
> cookie field is copied to userspace without being initialised.
> 
> I tested this with a simple userspace program, I seem to get mostly
> 0xffff8800 in the cookie field for non-move events (which should
> always have 0 here).
  That's a really embarassing bug. I've extented LTP inotify tests to
verify the cookie value is sane (so far the tests completely ignored the
value which is why I didn't notice the breakage).

Attached patch fixes the problem for me. I'll send it to Linus tomorrow.
Thanks for spotting the problem!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--17pEHd4RhPHOinZp
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-inotify-Fix-reporting-of-cookies-for-inotify-events.patch"

>From c9628b86163de99bb8b18cb9c8efc5b2ccc875e6 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 17 Feb 2014 13:09:50 +0100
Subject: [PATCH] inotify: Fix reporting of cookies for inotify events

My rework of handling of notification events (namely commit 7053aee26a35
"fsnotify: do not share events between notification groups") broke
sending of cookies with inotify events. We didn't propagate the value
passed to fsnotify() properly and passed 4 uninitialized bytes to
userspace instead (so it is also an information leak). Sadly I didn't
notice this during my testing because inotify cookies aren't used very
much and LTP inotify tests ignore them.

Fix the problem by passing the cookie value properly.

Fixes: 7053aee26a3548ebaba046ae2e52396ccf56ac6c
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/dnotify/dnotify.c          | 2 +-
 fs/notify/fanotify/fanotify.c        | 2 +-
 fs/notify/fsnotify.c                 | 2 +-
 fs/notify/inotify/inotify.h          | 2 +-
 fs/notify/inotify/inotify_fsnotify.c | 3 ++-
 fs/notify/inotify/inotify_user.c     | 2 +-
 include/linux/fsnotify_backend.h     | 2 +-
 kernel/audit_tree.c                  | 2 +-
 kernel/audit_watch.c                 | 2 +-
 9 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 0b9ff4395e6a..abc8cbcfe90e 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -86,7 +86,7 @@ static int dnotify_handle_event(struct fsnotify_group *group,
 				struct fsnotify_mark *inode_mark,
 				struct fsnotify_mark *vfsmount_mark,
 				u32 mask, void *data, int data_type,
-				const unsigned char *file_name)
+				const unsigned char *file_name, u32 cookie)
 {
 	struct dnotify_mark *dn_mark;
 	struct dnotify_struct *dn;
diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 0e792f5e3147..205dc2163822 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -147,7 +147,7 @@ static int fanotify_handle_event(struct fsnotify_group *group,
 				 struct fsnotify_mark *inode_mark,
 				 struct fsnotify_mark *fanotify_mark,
 				 u32 mask, void *data, int data_type,
-				 const unsigned char *file_name)
+				 const unsigned char *file_name, u32 cookie)
 {
 	int ret = 0;
 	struct fanotify_event_info *event;
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 1d4e1ea2f37c..9d3e9c50066a 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -179,7 +179,7 @@ static int send_to_group(struct inode *to_tell,
 
 	return group->ops->handle_event(group, to_tell, inode_mark,
 					vfsmount_mark, mask, data, data_is,
-					file_name);
+					file_name, cookie);
 }
 
 /*
diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
index 485eef3f4407..ed855ef6f077 100644
--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -27,6 +27,6 @@ extern int inotify_handle_event(struct fsnotify_group *group,
 				struct fsnotify_mark *inode_mark,
 				struct fsnotify_mark *vfsmount_mark,
 				u32 mask, void *data, int data_type,
-				const unsigned char *file_name);
+				const unsigned char *file_name, u32 cookie);
 
 extern const struct fsnotify_ops inotify_fsnotify_ops;
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index d5ee56348bb8..43ab1e1a07a2 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -67,7 +67,7 @@ int inotify_handle_event(struct fsnotify_group *group,
 			 struct fsnotify_mark *inode_mark,
 			 struct fsnotify_mark *vfsmount_mark,
 			 u32 mask, void *data, int data_type,
-			 const unsigned char *file_name)
+			 const unsigned char *file_name, u32 cookie)
 {
 	struct inotify_inode_mark *i_mark;
 	struct inotify_event_info *event;
@@ -103,6 +103,7 @@ int inotify_handle_event(struct fsnotify_group *group,
 	fsn_event = &event->fse;
 	fsnotify_init_event(fsn_event, inode, mask);
 	event->wd = i_mark->wd;
+	event->sync_cookie = cookie;
 	event->name_len = len;
 	if (len)
 		strcpy(event->name, file_name);
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 497395c8274b..6528b5a54ca0 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -495,7 +495,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 
 	/* Queue ignore event for the watch */
 	inotify_handle_event(group, NULL, fsn_mark, NULL, FS_IN_IGNORED,
-			     NULL, FSNOTIFY_EVENT_NONE, NULL);
+			     NULL, FSNOTIFY_EVENT_NONE, NULL, 0);
 
 	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 	/* remove this mark from the idr */
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 3d286ff49ab0..c84bc7c2bfc8 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -99,7 +99,7 @@ struct fsnotify_ops {
 			    struct fsnotify_mark *inode_mark,
 			    struct fsnotify_mark *vfsmount_mark,
 			    u32 mask, void *data, int data_type,
-			    const unsigned char *file_name);
+			    const unsigned char *file_name, u32 cookie);
 	void (*free_group_priv)(struct fsnotify_group *group);
 	void (*freeing_mark)(struct fsnotify_mark *mark, struct fsnotify_group *group);
 	void (*free_event)(struct fsnotify_event *event);
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 67ccf0e7cca9..135944a7b28a 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -916,7 +916,7 @@ static int audit_tree_handle_event(struct fsnotify_group *group,
 				   struct fsnotify_mark *inode_mark,
 				   struct fsnotify_mark *vfsmount_mark,
 				   u32 mask, void *data, int data_type,
-				   const unsigned char *file_name)
+				   const unsigned char *file_name, u32 cookie)
 {
 	return 0;
 }
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 2596fac5dcb4..70b4554d2fbe 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -471,7 +471,7 @@ static int audit_watch_handle_event(struct fsnotify_group *group,
 				    struct fsnotify_mark *inode_mark,
 				    struct fsnotify_mark *vfsmount_mark,
 				    u32 mask, void *data, int data_type,
-				    const unsigned char *dname)
+				    const unsigned char *dname, u32 cookie)
 {
 	struct inode *inode;
 	struct audit_parent *parent;
-- 
1.8.1.4


--17pEHd4RhPHOinZp--
