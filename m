Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaCCLMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:12:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbaCCLMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:12:35 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/5] fanotify: Remove useless bypass_perm check
Date: Mon,  3 Mar 2014 12:12:19 +0100
Message-Id: <1393845143-28007-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393845143-28007-1-git-send-email-jack@suse.cz>
References: <1393845143-28007-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare_for_access_response() checks whether
group->fanotify_data.bypass_perm is set. However this test can never be
true because prepare_for_access_response() is called only from
fanotify_read() which means fanotify group is alive with an active fd
while bypass_perm is set from fanotify_release() when all file
descriptors pointing to the group are closed and the group is going
away.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify_user.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 287a22c04149..70fe65437d21 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -211,14 +211,6 @@ static int prepare_for_access_response(struct fsnotify_group *group,
 	re->fd = fd;
 
 	mutex_lock(&group->fanotify_data.access_mutex);
-
-	if (atomic_read(&group->fanotify_data.bypass_perm)) {
-		mutex_unlock(&group->fanotify_data.access_mutex);
-		kmem_cache_free(fanotify_response_event_cache, re);
-		FANOTIFY_E(event)->response = FAN_ALLOW;
-		return 0;
-	}
-		
 	list_add_tail(&re->list, &group->fanotify_data.access_list);
 	mutex_unlock(&group->fanotify_data.access_mutex);
 
-- 
1.8.1.4

