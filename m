Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaDAJTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:19:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaDAJQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:44 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 22/29] GFS2: Ensure workqueue is scheduled after noexp request
Date: Tue,  1 Apr 2014 10:15:34 +0100
Message-Id: <1396343741-1524-23-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch closes a small timing window whereby a request to hold the
transaction glock can get stuck. The problem is that after the DLM has
granted the lock, it can get into a state whereby it doesn't transition
the glock to a held state, due to not having requeued the glock state
machine to finish the transition.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 52f7478..aec7f73 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1047,9 +1047,13 @@ int gfs2_glock_nq(struct gfs2_holder *gh)
 
 	spin_lock(&gl->gl_spin);
 	add_to_queue(gh);
-	if ((LM_FLAG_NOEXP & gh->gh_flags) &&
-	    test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))
+	if (unlikely((LM_FLAG_NOEXP & gh->gh_flags) &&
+		     test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))) {
 		set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
+		gl->gl_lockref.count++;
+		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+			gl->gl_lockref.count--;
+	}
 	run_queue(gl, 1);
 	spin_unlock(&gl->gl_spin);
 
-- 
1.8.3.1

