Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbaEKTpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:45:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaEKTX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Terry Barnaby <terry1@beam.ltd.uk>, Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.14 48/83] locks: allow __break_lease to sleep even when break_time is 0
Date: Sun, 11 May 2014 21:19:49 +0200
Message-Id: <20140511191913.437505571@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/locks.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1376,11 +1376,10 @@ int __break_lease(struct inode *inode, u
 
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


