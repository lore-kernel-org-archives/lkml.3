Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaLFSyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:54:14 -0500
Received: from mout.gmx.net ([212.227.15.19]:50133 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaLFSyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 13:54:12 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: akpm@linux-foundation.org, jack@suse.cz, eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v3 1/3] fanotify: only destroy mark when both mask and ignored_mask are cleared
Date: Sat,  6 Dec 2014 19:53:36 +0100
Message-Id: <1417892018-19440-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:JMRw5B3y0c7T46TzTXIRHkfL17ikw+Bxmjj0HpWQLpIB9S6U9dd
 DlF/xpLrDKONtdDwr36639w3z6KntBHc4AsbGDV4IY2ieBVFkslUNQnRJRy/yk82qpjld4Y
 +LFDC1lJP8RbN9rCR5iWo47AiQxJy+us175xFIoxq4rOLMH9NO3PmvqI1W8Ws35NTT1x75M
 snXuebOVDRdB9u/aJKK+Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fanotify_mark_remove_from_mask() a mark is destroyed if only one of both
bitmasks (mask or ignored_mask) of a mark is cleared. However the other mask
may still be set and contain information that should not be lost. So only
destroy a mark if both masks are cleared.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify_user.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c991616..ba31055 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -497,10 +497,9 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 		oldmask = fsn_mark->ignored_mask;
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
 	}
+	*destroy = !(fsn_mark->mask | fsn_mark->ignored_mask);
 	spin_unlock(&fsn_mark->lock);
 
-	*destroy = !(oldmask & ~mask);
-
 	return mask & oldmask;
 }
 
-- 
1.9.1

