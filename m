Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaLDEnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 23:43:46 -0500
Received: from mout.gmx.net ([212.227.17.20]:59371 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbaLDEno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 23:43:44 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com, jack@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v2 2/3] fanotify: dont recalculate a marks mask if only the ignored mask changed
Date: Thu,  4 Dec 2014 05:43:03 +0100
Message-Id: <1417668184-14544-2-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417668184-14544-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1417668184-14544-1-git-send-email-LinoSanfilippo@gmx.de>
X-Provags-ID: V03:K0:J9M/rUJuIYWfFte7+nlBLjzl/P3lnEGsTBrZ9PkYug++eRBmKXu
 sb1JDSuUOWpsIoz8uMEg4/11ChjGX5wIOxtdWLWEjZGvUjCvxhGwVNciA9YIz+Uescq0Dcc
 8+HPhhMD7xefstWpsnBg4q/Bk5t7TJ+dv8OQAJ0kELrwuqcPr9OKx3DjlP4Q8Y8a+PJ+gmp
 +X5M6AJbS/dhZS8y59HZA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If removing bits from a marks ignored mask, the concerning inodes/vfsmounts
mask is not affected. So dont recalculate it.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index ba31055..ddc33fb 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -487,15 +487,15 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 					    unsigned int flags,
 					    int *destroy)
 {
-	__u32 oldmask;
+	__u32 oldmask = 0;
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
 		oldmask = fsn_mark->mask;
 		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask & ~mask));
 	} else {
-		oldmask = fsn_mark->ignored_mask;
-		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
+		__u32 tmask = fsn_mark->ignored_mask & ~mask;
+		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 	}
 	*destroy = !(fsn_mark->mask | fsn_mark->ignored_mask);
 	spin_unlock(&fsn_mark->lock);
-- 
1.9.1

