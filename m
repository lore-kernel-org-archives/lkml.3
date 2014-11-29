Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaK2XiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 18:38:16 -0500
Received: from mout.gmx.net ([212.227.15.15]:57279 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaK2XiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 18:38:14 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 2/3] fanotify: dont recalculate a marks mask if only the ignored mask changed
Date: Sun, 30 Nov 2014 00:37:37 +0100
Message-Id: <1417304258-16838-2-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417304258-16838-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1417304258-16838-1-git-send-email-LinoSanfilippo@gmx.de>
X-Provags-ID: V03:K0:F9Ib/Clj86dCseNpzlod6dfKOaVytxYk/TuPCtGmyOjflv5PoM/
 x+csxu9+zkAWG5u3PWKAMJsPBgTfxldJCzmOM6woF2FI0+c3vwk4FsdMQ+7sYoiejVmHqU5
 ohh8o0EpHqZ5ADyJZ+DQJnQ0y27/FTpxoHRBneHYUvodhZUFO9Wgy/Yjh3ZLteBSPfIBbRZ
 xC/wwzSwk51U8dRpaESPw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If removing bits from a marks ignored mask, the concerning inodes/vfsmounts
mask is not affected. So dont recalculate it.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 03a0dd1..3afd8bb 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -487,7 +487,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 					    unsigned int flags,
 					    int *destroy)
 {
-	__u32 oldmask;
+	__u32 oldmask = 0;
 	__u32 new_mask;
 	__u32 new_ignored;
 
@@ -496,8 +496,8 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 		oldmask = fsn_mark->mask;
 		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask & ~mask));
 	} else {
-		oldmask = fsn_mark->ignored_mask;
-		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
+		__u32 tmask = fsn_mark->ignored_mask & ~mask;
+		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 	}
 	new_mask = fsn_mark->mask;
 	new_ignored = fsn_mark->ignored_mask;
-- 
1.9.1

