Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbbAXVsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 16:48:15 -0500
Received: from netz39.de ([78.46.22.20]:48018 "EHLO mail.netz39.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbbAXVsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 16:48:12 -0500
X-Spam-Report: -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	0.0 URIBL_BLOCKED          ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	See
	http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	for more information.
	[URIs: netz39.de]
	-1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
From: Stefan Haun <tux@netz39.de>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Cc: linux-kernel@vger.kernel.org, Stefan Haun <tux@netz39.de>
Subject: [PATCH 2/2] fs: fix checkpatch code warnings for inotify
Date: Sat, 24 Jan 2015 22:40:03 +0100
Message-Id: <1422135603-1135-2-git-send-email-tux@netz39.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422135603-1135-1-git-send-email-tux@netz39.de>
References: <1422135603-1135-1-git-send-email-tux@netz39.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

./fs/notify/inotify/inotify.h:23:
CHECK: extern prototypes should be avoided in .h files
./fs/notify/inotify/inotify.h:25:
CHECK: extern prototypes should be avoided in .h files

	Removed extrn keywords; the matter, however, seems to be an open
	debate.

./fs/notify/inotify/inotify_fsnotify.c:140:
ERROR: do not initialise statics to 0 or NULL

	Replace the initialization by a comment:
	Compiler takes care of the proper initialization.

./fs/notify/inotify/inotify_fsnotify.c:159:
WARNING: Prefer [subsystem eg: netdev]_warn([subsystem]dev, ... then
dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
./fs/notify/inotify/inotify_user.c:473:
WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then
dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
./fs/notify/inotify/inotify_user.c:474:
WARNING: quoted string split across lines

	Use pr_warn instead of printk and fix line break.

./fs/notify/inotify/inotify_user.c:645:
CHECK: Prefer kmalloc(sizeof(*oevent)...) over
kmalloc(sizeof(struct inotify_event_info)...)

	Done that (complies to coding stlye).

Signed-off-by: Stefan Haun <tux@netz39.de>
---
 fs/notify/inotify/inotify.h          |   16 ++++++++--------
 fs/notify/inotify/inotify_fsnotify.c |    6 +++---
 fs/notify/inotify/inotify_user.c     |    8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
index ed855ef..9d6d4e2 100644
--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -20,13 +20,13 @@ static inline struct inotify_event_info *INOTIFY_E(struct fsnotify_event *fse)
 	return container_of(fse, struct inotify_event_info, fse);
 }
 
-extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
-					   struct fsnotify_group *group);
-extern int inotify_handle_event(struct fsnotify_group *group,
-				struct inode *inode,
-				struct fsnotify_mark *inode_mark,
-				struct fsnotify_mark *vfsmount_mark,
-				u32 mask, void *data, int data_type,
-				const unsigned char *file_name, u32 cookie);
+void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
+				    struct fsnotify_group *group);
+
+int inotify_handle_event(struct fsnotify_group *group, struct inode *inode,
+			 struct fsnotify_mark *inode_mark,
+			 struct fsnotify_mark *vfsmount_mark,
+			 u32 mask, void *data, int data_type,
+			 const unsigned char *file_name, u32 cookie);
 
 extern const struct fsnotify_ops inotify_fsnotify_ops;
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 0238615..16efe98 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -137,7 +137,7 @@ static int idr_callback(int id, void *p, void *data)
 {
 	struct fsnotify_mark *fsn_mark;
 	struct inotify_inode_mark *i_mark;
-	static bool warned = false;
+	static bool warned; /* = false;  default by GCC */
 
 	if (warned)
 		return 0;
@@ -156,8 +156,8 @@ static int idr_callback(int id, void *p, void *data)
 	 * BUG() that was here.
 	 */
 	if (fsn_mark)
-		printk(KERN_WARNING "fsn_mark->group=%p inode=%p wd=%d\n",
-		       fsn_mark->group, fsn_mark->inode, i_mark->wd);
+		pr_warn("fsn_mark->group=%p inode=%p wd=%d\n",
+			fsn_mark->group, fsn_mark->inode, i_mark->wd);
 	return 0;
 }
 
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 3214e2b..d7e3e58 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -470,9 +470,9 @@ static void inotify_remove_from_idr(struct fsnotify_group *group,
 	 * one ref grabbed by inotify_idr_find
 	 */
 	if (unlikely(atomic_read(&i_mark->fsn_mark.refcnt) < 3)) {
-		printk(KERN_ERR "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
-			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
-			i_mark->fsn_mark.group, i_mark->fsn_mark.inode);
+		pr_err("%s: i_mark=%p i_mark->wd=%d i_mark->group=%p i_mark->inode=%p\n",
+		       __func__, i_mark, i_mark->wd, i_mark->fsn_mark.group,
+		       i_mark->fsn_mark.inode);
 		/* we can't really recover with bad ref cnting.. */
 		BUG();
 	}
@@ -642,7 +642,7 @@ static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 	if (IS_ERR(group))
 		return group;
 
-	oevent = kmalloc(sizeof(struct inotify_event_info), GFP_KERNEL);
+	oevent = kmalloc(sizeof(*oevent), GFP_KERNEL);
 	if (unlikely(!oevent)) {
 		fsnotify_destroy_group(group);
 		return ERR_PTR(-ENOMEM);
-- 
1.7.10.4
