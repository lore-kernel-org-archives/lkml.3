Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab3HMQbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:31:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965Ab3HMQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:53 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=EZ9dkMiECO0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=FR55-wRpeWgA:10 a=VwQbUJbxAAAA:8 a=5aplBM2G-4FtWVaCQ5YA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155834.036573610@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>
Subject: [66/88] jbd2: fix theoretical race in jbd2__journal_restart
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0066-jbd2-fix-theoretical-race-in-jbd2__journal_restart.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 39c04153fda8c32e85b51c96eb5511a326ad7609 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/jbd2/transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 9427cf1..718fe8f 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -499,10 +499,10 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
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
1.7.10.4


