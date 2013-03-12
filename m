Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab3CLXAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:00:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab3CLWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Russ Dill <Russ.Dill@gmail.com>
Subject: [ 065/100] random: fix locking dependency with the tasklist_lock
Date: Tue, 12 Mar 2013 15:31:50 -0700
Message-Id: <20130312223129.960540099@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -852,6 +852,7 @@ static size_t account(struct entropy_sto
 		      int reserved)
 {
 	unsigned long flags;
+	int wakeup_write = 0;
 
 	/* Hold lock while accounting */
 	spin_lock_irqsave(&r->lock, flags);
@@ -873,10 +874,8 @@ static size_t account(struct entropy_sto
 		else
 			r->entropy_count = reserved;
 
-		if (r->entropy_count < random_write_wakeup_thresh) {
-			wake_up_interruptible(&random_write_wait);
-			kill_fasync(&fasync, SIGIO, POLL_OUT);
-		}
+		if (r->entropy_count < random_write_wakeup_thresh)
+			wakeup_write = 1;
 	}
 
 	DEBUG_ENT("debiting %zu entropy credits from %s%s\n",
@@ -884,6 +883,11 @@ static size_t account(struct entropy_sto
 
 	spin_unlock_irqrestore(&r->lock, flags);
 
+	if (wakeup_write) {
+		wake_up_interruptible(&random_write_wait);
+		kill_fasync(&fasync, SIGIO, POLL_OUT);
+	}
+
 	return nbytes;
 }
 


