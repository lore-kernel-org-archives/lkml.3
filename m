Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3GKOZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:25:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42895 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3GKOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 18/98] jbd2: fix theoretical race in jbd2__journal_restart
Date: Thu, 11 Jul 2013 15:23:48 +0100
Message-Id: <1373552708-15235-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 39c04153fda8c32e85b51c96eb5511a326ad7609 upstream.

Once we decrement transaction->t_updates, if this is the last handle
holding the transaction from closing, and once we release the
t_handle_lock spinlock, it's possible for the transaction to commit
and be released.  In practice with normal kernels, this probably won't
happen, since the commit happens in a separate kernel thread and it's
unlikely this could all happen within the space of a few CPU cycles.

On the other hand, with a real-time kernel, this could potentially
happen, so save the tid found in transaction->t_tid before we release
t_handle_lock.  It would require an insane configuration, such as one
where the jbd2 thread was set to a very high real-time priority,
perhaps because a high priority real-time thread is trying to read or
write to a file system.  But some people who use real-time kernels
have been known to do insane things, including controlling
laser-wielding industrial robots.  :-)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/jbd2/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 399e4ee..81203d1 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -500,10 +500,10 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
 		   &transaction->t_outstanding_credits);
 	if (atomic_dec_and_test(&transaction->t_updates))
 		wake_up(&journal->j_wait_updates);
+	tid = transaction->t_tid;
 	spin_unlock(&transaction->t_handle_lock);
 
 	jbd_debug(2, "restarting handle %p\n", handle);
-	tid = transaction->t_tid;
 	need_to_start = !tid_geq(journal->j_commit_request, tid);
 	read_unlock(&journal->j_state_lock);
 	if (need_to_start)
-- 
1.8.1.2

