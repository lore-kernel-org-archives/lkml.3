Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaEGNNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:13:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45369 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbaEGNNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:13:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 08/70] locks: allow __break_lease to sleep even when break_time is 0
Date: Wed,  7 May 2014 14:12:11 +0100
Message-Id: <1399468393-10140-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit f1c6bb2cb8b81013e8979806f8e15e3d53efb96d upstream.

A fl->fl_break_time of 0 has a special meaning to the lease break code
that basically means "never break the lease". knfsd uses this to ensure
that leases don't disappear out from under it.

Unfortunately, the code in __break_lease can end up passing this value
to wait_event_interruptible as a timeout, which prevents it from going
to sleep at all. This makes __break_lease to spin in a tight loop and
causes soft lockups.

Fix this by ensuring that we pass a minimum value of 1 as a timeout
instead.

Cc: J. Bruce Fields <bfields@fieldses.org>
Reported-by: Terry Barnaby <terry1@beam.ltd.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/locks.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index b27a300..ad95fbd 100644
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
1.9.1

