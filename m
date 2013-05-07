Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab3EGNy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:54:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3EGNmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 093/118] LOCKD: Ensure that nlmclnt_block resets block->b_status after a server reboot
Date: Tue,  7 May 2013 14:38:59 +0100
Message-Id: <1367933964-1564-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 1dfd89af8697a299e7982ae740d4695ecd917eef upstream.

After a server reboot, the reclaimer thread will recover all the existing
locks. For locks that are blocked, however, it will change the value
of block->b_status to nlm_lck_denied_grace_period in order to signal that
they need to wake up and resend the original blocking lock request.

Due to a bug, however, the block->b_status never gets reset after the
blocked locks have been woken up, and so the process goes into an
infinite loop of resends until the blocked lock is satisfied.

Reported-by: Marc Eshel <eshel@us.ibm.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/lockd/clntlock.c | 3 +++
 fs/lockd/clntproc.c | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
index ca0a080..193f04c 100644
--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -144,6 +144,9 @@ int nlmclnt_block(struct nlm_wait *block, struct nlm_rqst *req, long timeout)
 			timeout);
 	if (ret < 0)
 		return -ERESTARTSYS;
+	/* Reset the lock status after a server reboot so we resend */
+	if (block->b_status == nlm_lck_denied_grace_period)
+		block->b_status = nlm_lck_blocked;
 	req->a_res.status = block->b_status;
 	return 0;
 }
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index a3a0987..8392cb8 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -551,9 +551,6 @@ again:
 		status = nlmclnt_block(block, req, NLMCLNT_POLL_TIMEOUT);
 		if (status < 0)
 			break;
-		/* Resend the blocking lock request after a server reboot */
-		if (resp->status ==  nlm_lck_denied_grace_period)
-			continue;
 		if (resp->status != nlm_lck_blocked)
 			break;
 	}
-- 
1.8.1.2

