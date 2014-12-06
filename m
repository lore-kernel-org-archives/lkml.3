Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaLFSyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:54:12 -0500
Received: from mout.gmx.net ([212.227.15.15]:49579 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaLFSyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 13:54:10 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: akpm@linux-foundation.org, jack@suse.cz, eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v3 3/3] fanotify: dont set FAN_ONDIR implicitly on a marks ignored mask
Date: Sat,  6 Dec 2014 19:53:38 +0100
Message-Id: <1417892018-19440-3-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417892018-19440-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1417892018-19440-1-git-send-email-LinoSanfilippo@gmx.de>
X-Provags-ID: V03:K0:5AGwxjB9SertOUtmVvFXEw2zYbQXHFYyQwKyVJGA/dLOksrQZ21
 nSQxKiqdmxSJZLxpnxk07zOc++8G26wCaUKkNfdAnG/BbCyBuvhOl+0L7grDSjsvVVIAcnh
 ZdZuHmdPaW63ZcssMAaPzPzvocBy0mOJYA1snTbqT3Tt/cW4+5DkUngN4SJckXogzTbAztL
 W0g6KYwQNQGlTlX5w4obg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently FAN_ONDIR is always set on a marks ignored mask when the event mask
is extended without FAN_MARK_ONDIR being set. This may result in events for
directories being ignored unexpectedly for call sequences like

fanotify_mark(fd, FAN_MARK_ADD, FAN_OPEN | FAN_ONDIR , AT_FDCWD, "dir");
fanotify_mark(fd, FAN_MARK_ADD, FAN_CLOSE, AT_FDCWD, "dir");

Also FAN_MARK_ONDIR is only honored when adding events to a marks mask, but
not for event removal. Fix both issues by not setting FAN_ONDIR implicitly on
the ignore mask any more. Instead treat FAN_ONDIR as any other event flag and
require FAN_MARK_ONDIR to be set by the user for both event mask and ignore
mask. Furthermore take FAN_MARK_ONDIR into account when set for event removal.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify.c      |  2 +-
 fs/notify/fanotify/fanotify_user.c | 24 ++++++++++++++++--------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 30d3add..51ceb81 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -140,7 +140,7 @@ static bool fanotify_should_send_event(struct fsnotify_mark *inode_mark,
 	}
 
 	if (S_ISDIR(path->dentry->d_inode->i_mode) &&
-	    (marks_ignored_mask & FS_ISDIR))
+	    !(marks_mask & FS_ISDIR & ~marks_ignored_mask))
 		return false;
 
 	if (event_mask & marks_mask & ~marks_ignored_mask)
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index ddc33fb..683d140 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -491,10 +491,17 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
+		__u32 tmask = fsn_mark->mask & ~mask;
+		if (flags & FAN_MARK_ONDIR)
+			tmask &= ~FAN_ONDIR;
+
 		oldmask = fsn_mark->mask;
-		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask & ~mask));
+		fsnotify_set_mark_mask_locked(fsn_mark, tmask);
 	} else {
 		__u32 tmask = fsn_mark->ignored_mask & ~mask;
+		if (flags & FAN_MARK_ONDIR)
+			tmask &= ~FAN_ONDIR;
+
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 	}
 	*destroy = !(fsn_mark->mask | fsn_mark->ignored_mask);
@@ -568,20 +575,21 @@ static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
+		__u32 tmask = fsn_mark->mask | mask;
+		if (flags & FAN_MARK_ONDIR)
+			tmask |= FAN_ONDIR;
+
 		oldmask = fsn_mark->mask;
-		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask | mask));
+		fsnotify_set_mark_mask_locked(fsn_mark, tmask);
 	} else {
 		__u32 tmask = fsn_mark->ignored_mask | mask;
+		if (flags & FAN_MARK_ONDIR)
+			tmask |= FAN_ONDIR;
+
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 		if (flags & FAN_MARK_IGNORED_SURV_MODIFY)
 			fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
 	}
-
-	if (!(flags & FAN_MARK_ONDIR)) {
-		__u32 tmask = fsn_mark->ignored_mask | FAN_ONDIR;
-		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
-	}
-
 	spin_unlock(&fsn_mark->lock);
 
 	return mask & ~oldmask;
-- 
1.9.1

