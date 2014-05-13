Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbaEMKLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933406AbaEMKLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "J. Bruce Fields" <bfields@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 159/182] locks: allow __break_lease to sleep even when break_time is 0
Date: Tue, 13 May 2014 11:28:31 +0200
Message-Id: <3052c8d992802acd99c91e90ec5287753775d2b9.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4991a628a789dc5954e98e79476d9808812292ec upstream.

A fl->fl_break_time of 0 has a special meaning to the lease break code
that basically means "never break the lease". knfsd uses this to ensure
that leases don't disappear out from under it.

Unfortunately, the code in __break_lease can end up passing this value
to wait_event_interruptible as a timeout, which prevents it from going
to sleep at all. This causes __break_lease to spin in a tight loop and
causes soft lockups.

Fix this by ensuring that we pass a minimum value of 1 as a timeout
instead.

Cc: J. Bruce Fields <bfields@fieldses.org>
Reported-by: Terry Barnaby <terry1@beam.ltd.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/locks.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index b27a3005d78d..ad95fbd20f8a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1359,11 +1359,10 @@ int __break_lease(struct inode *inode, unsigned int mode)
 
 restart:
 	break_time = flock->fl_break_time;
-	if (break_time != 0) {
+	if (break_time != 0)
 		break_time -= jiffies;
-		if (break_time == 0)
-			break_time++;
-	}
+	if (break_time == 0)
+		break_time++;
 	locks_insert_block(flock, new_fl);
 	spin_unlock(&inode->i_lock);
 	error = wait_event_interruptible_timeout(new_fl->fl_wait,
-- 
1.9.3

