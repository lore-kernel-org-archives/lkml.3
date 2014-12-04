Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaLDEnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 23:43:52 -0500
Received: from mout.gmx.net ([212.227.17.21]:58538 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbaLDEns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 23:43:48 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com, jack@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v2 1/3] fanotify: only destroy mark when both mask and ignored_mask are cleared
Date: Thu,  4 Dec 2014 05:43:02 +0100
Message-Id: <1417668184-14544-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:8kqJhmTeYxqWhTeLv80/1hZo4F4NiYXYN39IKLqwb5R8tWhX+Ni
 h/Ciin6dw8LyY6wXbGMYqUH7jqTop7ZFkbVSyODWhIRoq77wXMa/iJ6QlhHPz+OWYGDaj/h
 e0xixQgwRw7YJAcaoBd/+GMcr4zT6JzGfW0PtyLHfmY0DB3nyZRoWsEzRYw19iex9G8lYLu
 mm89Aw2V8IjcaoUlnm5Gw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fanotify_mark_remove_from_mask() a mark is destroyed if only one of both
bitmasks (mask or ignored_mask) of a mark is cleared. However the other mask
may still be set and contain information that should not be lost. So only
destroy a mark if both masks are cleared.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
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

