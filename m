Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbaF3MFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:05:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52026 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Geyslan G. Bem" <geyslan@gmail.com>,
        Ben Myers <bpm@sgi.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/181] xfs: fix possible NULL dereference in xlog_verify_iclog
Date: Mon, 30 Jun 2014 13:51:02 +0200
Message-Id: <8ceeb85cd8b2aa2141c21dcc2b830cac14b8cfbe.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Geyslan G. Bem" <geyslan@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 643f7c4e5656bd18c769211f933190f7bb738245 upstream.

In xlog_verify_iclog a debug check of the incore log buffers prints an
error if icptr is null and then goes on to dereference the pointer
regardless.  Convert this to an assert so that the intention is clear.
This was reported by Coverty.

Signed-off-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_log.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 613ed9414e70..3c4ddc1c79a4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3712,11 +3712,9 @@ xlog_verify_iclog(
 	/* check validity of iclog pointers */
 	spin_lock(&log->l_icloglock);
 	icptr = log->l_iclog;
-	for (i=0; i < log->l_iclog_bufs; i++) {
-		if (icptr == NULL)
-			xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
-		icptr = icptr->ic_next;
-	}
+	for (i = 0; i < log->l_iclog_bufs; i++, icptr = icptr->ic_next)
+		ASSERT(icptr);
+
 	if (icptr != log->l_iclog)
 		xfs_emerg(log->l_mp, "%s: corrupt iclog ring", __func__);
 	spin_unlock(&log->l_icloglock);
-- 
2.0.0

