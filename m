Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3CNKor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:44:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52034 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3CNKiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 67/88] random: fix locking dependency with the tasklist_lock
Date: Thu, 14 Mar 2013 10:36:00 +0000
Message-Id: <1363257381-15900-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit b980955236922ae6106774511c5c05003d3ad225 upstream.

Commit 6133705494bb introduced a circular lock dependency because
posix_cpu_timers_exit() is called by release_task(), which is holding
a writer lock on tasklist_lock, and this can cause a deadlock since
kill_fasync() gets called with nonblocking_pool.lock taken.

There's no reason why kill_fasync() needs to be taken while the random
pool is locked, so move it out to fix this locking dependency.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Russ Dill <Russ.Dill@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/random.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d98b2a6..91abbc4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -855,6 +855,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
 	unsigned long flags;
+	int wakeup_write = 0;
 
 	/* Hold lock while accounting */
 	spin_lock_irqsave(&r->lock, flags);
@@ -876,10 +877,8 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		else
 			r->entropy_count = reserved;
 
-		if (r->entropy_count < random_write_wakeup_thresh) {
-			wake_up_interruptible(&random_write_wait);
-			kill_fasync(&fasync, SIGIO, POLL_OUT);
-		}
+		if (r->entropy_count < random_write_wakeup_thresh)
+			wakeup_write = 1;
 	}
 
 	DEBUG_ENT("debiting %d entropy credits from %s%s\n",
@@ -887,6 +886,11 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 
 	spin_unlock_irqrestore(&r->lock, flags);
 
+	if (wakeup_write) {
+		wake_up_interruptible(&random_write_wait);
+		kill_fasync(&fasync, SIGIO, POLL_OUT);
+	}
+
 	return nbytes;
 }
 
-- 
1.8.1.2

