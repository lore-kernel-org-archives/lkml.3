Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbaEPMs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:48:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49544 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jeff Layton" <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Terry Barnaby" <terry1@beam.ltd.uk>
Date: Fri, 16 May 2014 13:47:20 +0100
Message-ID: <lsq.1400244440.475163402@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 05/34] locks: allow __break_lease to sleep even when
 break_time is 0
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/locks.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1253,11 +1253,10 @@ int __break_lease(struct inode *inode, u
 
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
 	unlock_flocks();
 	error = wait_event_interruptible_timeout(new_fl->fl_wait,

