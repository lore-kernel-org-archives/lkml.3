Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965677Ab3GSF0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:26:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965490Ab3GSF0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 07/72] jbd2: fix theoretical race in jbd2__journal_restart
Date: Thu, 18 Jul 2013 22:25:24 -0700
Message-Id: <20130719052600.363125882@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -517,10 +517,10 @@ int jbd2__journal_restart(handle_t *hand
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


