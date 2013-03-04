Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab3CDDnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32869 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756361Ab3CDDni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:38 -0500
Message-Id: <20130304033716.615783127@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:38 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Junxiao Bi <junxiao.bi@oracle.com>,
        Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 091/153] ocfs2: unlock super lock if lockres refresh failed
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/dlmglue.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2545,6 +2545,7 @@ int ocfs2_super_lock(struct ocfs2_super
 	 * everything is up to the caller :) */
 	status = ocfs2_should_refresh_lock_res(lockres);
 	if (status < 0) {
+		ocfs2_cluster_unlock(osb, lockres, level);
 		mlog_errno(status);
 		goto bail;
 	}
@@ -2553,8 +2554,10 @@ int ocfs2_super_lock(struct ocfs2_super
 
 		ocfs2_complete_lock_res_refresh(lockres, status);
 
-		if (status < 0)
+		if (status < 0) {
+			ocfs2_cluster_unlock(osb, lockres, level);
 			mlog_errno(status);
+		}
 		ocfs2_track_lock_refresh(lockres);
 	}
 bail:


