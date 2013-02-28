Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113Ab3B1PIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:08:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42248 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab3B1Osv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Junxiao Bi <junxiao.bi@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 073/139] ocfs2: unlock super lock if lockres refresh failed
Date: Thu, 28 Feb 2013 14:43:43 +0000
Message-Id: <1362062689-2567-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 3278bb748d2437eb1464765f36429e5d6aa91c38 upstream.

If lockres refresh failed, the super lock will never be released which
will cause some processes on other cluster nodes hung forever.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ocfs2/dlmglue.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4f7795f..88577eb 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2545,6 +2545,7 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 	 * everything is up to the caller :) */
 	status = ocfs2_should_refresh_lock_res(lockres);
 	if (status < 0) {
+		ocfs2_cluster_unlock(osb, lockres, level);
 		mlog_errno(status);
 		goto bail;
 	}
@@ -2553,8 +2554,10 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 
 		ocfs2_complete_lock_res_refresh(lockres, status);
 
-		if (status < 0)
+		if (status < 0) {
+			ocfs2_cluster_unlock(osb, lockres, level);
 			mlog_errno(status);
+		}
 		ocfs2_track_lock_refresh(lockres);
 	}
 bail:
-- 
1.8.1.2

