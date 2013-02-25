Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3BYW0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:26:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab3BYWUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Junxiao Bi <junxiao.bi@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 35/58] ocfs2: unlock super lock if lockres refresh failed
Date: Mon, 25 Feb 2013 14:19:31 -0800
Message-Id: <20130225221643.862127008@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


