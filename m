Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab3CZNO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:14:58 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:62480 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069Ab3CZNO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:14:56 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Mar 2013 09:14:56 EDT
From: Jeff Layton <jlayton@redhat.com>
To: trond.myklebust@netapp.com
Cc: ycnian@gmail.com, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfs: allow the v4.1 callback thread to freeze
Date: Tue, 26 Mar 2013 09:06:39 -0400
Message-Id: <1364303199-13295-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The v4.1 callback thread has set_freezable() at the top, but it doesn't
ever try to freeze within the loop. Have it call try_to_freeze() at the
top of the loop. If a freeze event occurs, recheck kthread_should_stop()
after thawing.

Reported-and-Tested-by: Yanchuan Nian <ycnian@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nfs/callback.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 5088b57..cff089a 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -125,6 +125,9 @@ nfs41_callback_svc(void *vrqstp)
 	set_freezable();
 
 	while (!kthread_should_stop()) {
+		if (try_to_freeze())
+			continue;
+
 		prepare_to_wait(&serv->sv_cb_waitq, &wq, TASK_INTERRUPTIBLE);
 		spin_lock_bh(&serv->sv_cb_lock);
 		if (!list_empty(&serv->sv_cb_list)) {
-- 
1.7.11.7

