Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaK2XiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 18:38:12 -0500
Received: from mout.gmx.net ([212.227.15.19]:49255 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaK2XiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 18:38:11 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 1/3] fanotify: only destroy mark when both mask and ignored_mask are cleared
Date: Sun, 30 Nov 2014 00:37:36 +0100
Message-Id: <1417304258-16838-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:2+JdX3LRIobBsT8kGT04DKHdT5qr6wXYwEg4bFxZI/epuEuvKb/
 keDeuSZ8qlglFf4Rl908YAwwzxvUQqkbEir5CdoJVTilnTKjUjRKMu24ecxoe5UqIGuzQsp
 00DJ+7M8QVfSuNBAR+/3y1qFK2JdOpyZyQgmJP7H5CfNf0ALqvusLKRdUDqdgYWNhoWYOYH
 S58foU1AEvUWSW/Jx233w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fanotify_mark_remove_from_mask() a mark is destroyed if only one of both
bitmasks (mask or ignored_mask) of a mark is cleared. However the other mask
may still be set and contain information that should not be lost. Thus only
destroy a mark if both masks are cleared.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c991616..03a0dd1 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -488,6 +488,8 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 					    int *destroy)
 {
 	__u32 oldmask;
+	__u32 new_mask;
+	__u32 new_ignored;
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
@@ -497,9 +499,11 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 		oldmask = fsn_mark->ignored_mask;
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
 	}
+	new_mask = fsn_mark->mask;
+	new_ignored = fsn_mark->ignored_mask;
 	spin_unlock(&fsn_mark->lock);
 
-	*destroy = !(oldmask & ~mask);
+	*destroy = !(new_mask | new_ignored);
 
 	return mask & oldmask;
 }
-- 
1.9.1

