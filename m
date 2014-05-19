Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaESNKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:10:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaESNKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:10:01 -0400
Date: Mon, 19 May 2014 06:08:53 -0700
From: tip-bot for NeilBrown <tipbot@zytor.com>
Message-ID: <tip-aba3320acaa3197f667a41be5c972ca4fb97a283@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, bfields@fieldses.org,
        hpa@zytor.com, mingo@kernel.org, trond.myklebust@primarydata.com,
        peterz@infradead.org, neilb@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bfields@fieldses.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        trond.myklebust@primarydata.com, peterz@infradead.org, neilb@suse.de,
        tglx@linutronix.de
In-Reply-To: <20140501124143.5712eb96@notabene.brown>
References: <20140501124143.5712eb96@notabene.brown>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Allow wait_on_bit_action functions to support a timeout
Git-Commit-ID: aba3320acaa3197f667a41be5c972ca4fb97a283
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aba3320acaa3197f667a41be5c972ca4fb97a283
Gitweb:     http://git.kernel.org/tip/aba3320acaa3197f667a41be5c972ca4fb97a283
Author:     NeilBrown <neilb@suse.de>
AuthorDate: Thu, 1 May 2014 12:41:43 +1000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:40 +0900

sched: Allow wait_on_bit_action functions to support a timeout

It is currently not possible for various wait_on_bit functions to
implement a timeout.
While the "action" function that is called to do the waiting could
certainly use schedule_timeout(), there is no way to carry forward the
remaining timeout after a false wake-up.
As false-wakeups a clearly possible at least due to possible
hash collisions in bit_waitqueue(), this is a real problem.

The 'action' function is currently passed a pointer to the word
containing the bit being waited on.  No current action functions use
this pointer.  So changing it to something else will be a little noisy
but will have no immediate effect.

This patch changes the 'action' function to take a pointer to the
"struct wait_bit_key", which contains a pointer to the word
containing the bit so nothing is really lost.

It also adds a 'private' field to "struct wait_bit_key", which is
initialized to zero.

An action function can now implement a timeout with something like

static int timed_out_waiter(struct wait_bit_key *key)
{
	unsigned long waited;
	if (key->private == 0) {
		key->private = jiffies;
		if (key->private == 0)
			key->private -= 1;
	}
	waited = jiffies - key->private;
	if (waited > 10 * HZ)
		return -EAGAIN;
	schedule_timeout(waited - 10 * HZ);
	return 0;
}

If any other need for context in a waiter were found it would be easy
to use ->private for some other purpose, or even extend "struct
wait_bit_key".

My particular need is to support timeouts in nfs_release_page() to
avoid deadlocks with loopback mounted NFS.

While wait_on_bit_timeout() would be a cleaner interface, it will not
meet my need.  I need the timeout to be sensitive to the state of
the connection with the server, which could change.  So I need to
use an 'action' interface.

Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140501124143.5712eb96@notabene.brown
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/nfs/inode.c               |  2 +-
 fs/nfs/internal.h            |  2 +-
 fs/nfs/pagelist.c            |  2 +-
 include/linux/sunrpc/sched.h |  2 +-
 include/linux/wait.h         | 17 +++++++++--------
 kernel/sched/wait.c          | 16 ++++++++--------
 net/sunrpc/sched.c           |  4 ++--
 7 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index cd6e656..5c19408 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -75,7 +75,7 @@ nfs_fattr_to_ino_t(struct nfs_fattr *fattr)
  * nfs_wait_bit_killable - helper for functions that are sleeping on bit locks
  * @word: long word containing the bit lock
  */
-int nfs_wait_bit_killable(void *word)
+int nfs_wait_bit_killable(struct wait_bit_key *key)
 {
 	if (fatal_signal_pending(current))
 		return -ERESTARTSYS;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index dd8bfc2..9bafea8 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -342,7 +342,7 @@ extern int nfs_drop_inode(struct inode *);
 extern void nfs_clear_inode(struct inode *);
 extern void nfs_evict_inode(struct inode *);
 void nfs_zap_acl_cache(struct inode *inode);
-extern int nfs_wait_bit_killable(void *word);
+extern int nfs_wait_bit_killable(struct wait_bit_key *key);
 
 /* super.c */
 extern const struct super_operations nfs_sops;
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index f369a74..3f7c257 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -112,7 +112,7 @@ __nfs_iocounter_wait(struct nfs_io_counter *c)
 		set_bit(NFS_IO_INPROGRESS, &c->flags);
 		if (atomic_read(&c->io_count) == 0)
 			break;
-		ret = nfs_wait_bit_killable(&c->flags);
+		ret = nfs_wait_bit_killable(&q.key);
 	} while (atomic_read(&c->io_count) != 0);
 	finish_wait(wq, &q.wait);
 	return ret;
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 3a847de..592be58 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -236,7 +236,7 @@ void *		rpc_malloc(struct rpc_task *, size_t);
 void		rpc_free(void *);
 int		rpciod_up(void);
 void		rpciod_down(void);
-int		__rpc_wait_for_completion_task(struct rpc_task *task, int (*)(void *));
+int		__rpc_wait_for_completion_task(struct rpc_task *task, int (*)(struct wait_bit_key *));
 #ifdef RPC_DEBUG
 struct net;
 void		rpc_show_tasks(struct net *);
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 438dc60..162cbcd 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -25,6 +25,7 @@ struct wait_bit_key {
 	void			*flags;
 	int			bit_nr;
 #define WAIT_ATOMIC_T_BIT_NR	-1
+	unsigned long		private;
 };
 
 struct wait_bit_queue {
@@ -147,12 +148,12 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, void *k
 void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
-int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
-int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
+int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(struct wait_bit_key *), unsigned);
+int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(struct wait_bit_key *), unsigned);
 void wake_up_bit(void *, int);
 void wake_up_atomic_t(atomic_t *);
-int out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned);
-int out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned);
+int out_of_line_wait_on_bit(void *, int, int (*)(struct wait_bit_key *), unsigned);
+int out_of_line_wait_on_bit_lock(void *, int, int (*)(struct wait_bit_key *), unsigned);
 int out_of_line_wait_on_atomic_t(atomic_t *, int (*)(atomic_t *), unsigned);
 wait_queue_head_t *bit_waitqueue(void *, int);
 
@@ -855,8 +856,8 @@ int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 	} while (0)
 
 
-extern int bit_wait(void *);
-extern int bit_wait_io(void *);
+extern int bit_wait(struct wait_bit_key *);
+extern int bit_wait_io(struct wait_bit_key *);
 
 /**
  * wait_on_bit - wait for a bit to be cleared
@@ -925,7 +926,7 @@ wait_on_bit_io(void *word, int bit, unsigned mode)
  * on that signal.
  */
 static inline int
-wait_on_bit_action(void *word, int bit, int (*action)(void *), unsigned mode)
+wait_on_bit_action(void *word, int bit, int (*action)(struct wait_bit_key *), unsigned mode)
 {
 	if (!test_bit(bit, word))
 		return 0;
@@ -1000,7 +1001,7 @@ wait_on_bit_lock_io(void *word, int bit, unsigned mode)
  * the @mode allows that signal to wake the process.
  */
 static inline int
-wait_on_bit_lock_action(void *word, int bit, int (*action)(void *), unsigned mode)
+wait_on_bit_lock_action(void *word, int bit, int (*action)(struct wait_bit_key *), unsigned mode)
 {
 	if (!test_and_set_bit(bit, word))
 		return 0;
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 0c07950..738fa68 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -319,14 +319,14 @@ EXPORT_SYMBOL(wake_bit_function);
  */
 int __sched
 __wait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
-			int (*action)(void *), unsigned mode)
+			int (*action)(struct wait_bit_key *), unsigned mode)
 {
 	int ret = 0;
 
 	do {
 		prepare_to_wait(wq, &q->wait, mode);
 		if (test_bit(q->key.bit_nr, q->key.flags))
-			ret = (*action)(q->key.flags);
+			ret = (*action)(&q->key);
 	} while (test_bit(q->key.bit_nr, q->key.flags) && !ret);
 	finish_wait(wq, &q->wait);
 	return ret;
@@ -334,7 +334,7 @@ __wait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
 EXPORT_SYMBOL(__wait_on_bit);
 
 int __sched out_of_line_wait_on_bit(void *word, int bit,
-					int (*action)(void *), unsigned mode)
+					int (*action)(struct wait_bit_key *), unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
 	DEFINE_WAIT_BIT(wait, word, bit);
@@ -345,7 +345,7 @@ EXPORT_SYMBOL(out_of_line_wait_on_bit);
 
 int __sched
 __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
-			int (*action)(void *), unsigned mode)
+			int (*action)(struct wait_bit_key *), unsigned mode)
 {
 	do {
 		int ret;
@@ -353,7 +353,7 @@ __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 		prepare_to_wait_exclusive(wq, &q->wait, mode);
 		if (!test_bit(q->key.bit_nr, q->key.flags))
 			continue;
-		ret = action(q->key.flags);
+		ret = action(&q->key);
 		if (!ret)
 			continue;
 		abort_exclusive_wait(wq, &q->wait, mode, &q->key);
@@ -365,7 +365,7 @@ __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 EXPORT_SYMBOL(__wait_on_bit_lock);
 
 int __sched out_of_line_wait_on_bit_lock(void *word, int bit,
-					int (*action)(void *), unsigned mode)
+					int (*action)(struct wait_bit_key *), unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
 	DEFINE_WAIT_BIT(wait, word, bit);
@@ -503,7 +503,7 @@ void wake_up_atomic_t(atomic_t *p)
 }
 EXPORT_SYMBOL(wake_up_atomic_t);
 
-__sched int bit_wait(void *word)
+__sched int bit_wait(struct wait_bit_key *word)
 {
 	if (signal_pending_state(current->state, current))
 		return 1;
@@ -512,7 +512,7 @@ __sched int bit_wait(void *word)
 }
 EXPORT_SYMBOL(bit_wait);
 
-__sched int bit_wait_io(void *word)
+__sched int bit_wait_io(struct wait_bit_key *word)
 {
 	if (signal_pending_state(current->state, current))
 		return 1;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 25578af..7b9a673 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -250,7 +250,7 @@ void rpc_destroy_wait_queue(struct rpc_wait_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
 
-static int rpc_wait_bit_killable(void *word)
+static int rpc_wait_bit_killable(struct wait_bit_key *key)
 {
 	if (fatal_signal_pending(current))
 		return -ERESTARTSYS;
@@ -309,7 +309,7 @@ static int rpc_complete_task(struct rpc_task *task)
  * to enforce taking of the wq->lock and hence avoid races with
  * rpc_complete_task().
  */
-int __rpc_wait_for_completion_task(struct rpc_task *task, int (*action)(void *))
+int __rpc_wait_for_completion_task(struct rpc_task *task, int (*action)(struct wait_bit_key *))
 {
 	if (action == NULL)
 		action = rpc_wait_bit_killable;
