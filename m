Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaLFSyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:54:10 -0500
Received: from mout.gmx.net ([212.227.15.15]:62546 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaLFSyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 13:54:09 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: akpm@linux-foundation.org, jack@suse.cz, eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v3 2/3] fanotify: dont recalculate a marks mask if only the ignored mask changed
Date: Sat,  6 Dec 2014 19:53:37 +0100
Message-Id: <1417892018-19440-2-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417892018-19440-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1417892018-19440-1-git-send-email-LinoSanfilippo@gmx.de>
X-Provags-ID: V03:K0:0vEOXNI53EFbZtLEFQj0tyMsf5dw5Uiu40nHtU+fSLHbnWzFREH
 Fs3Xsme4ta1yAMORsCM2+G5wn8UqDfxoXM1Snn4LSjQO1QydjYUP+kYuVUJsVMI5IM0Bup8
 McB31y0GmYvJ12p50TGNmcDbdj4w+mzLUjlci1kzLkuThTdguYKgT5cy9HS/3Hts80fBlW+
 uUCakqR+/8HdT/M40LeMg==
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

