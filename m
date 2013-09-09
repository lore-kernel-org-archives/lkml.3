Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3IIT2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:28:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54429 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3IIT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:28:39 -0400
Date: Mon, 9 Sep 2013 20:28:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130909192835.GU13318@ZenIV.linux.org.uk>
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
 <1378743493-33546-2-git-send-email-Waiman.Long@hp.com>
 <20130909172905.GN13318@ZenIV.linux.org.uk>
 <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
 <20130909180604.GO13318@ZenIV.linux.org.uk>
 <20130909182111.GQ13318@ZenIV.linux.org.uk>
 <20130909183608.GR13318@ZenIV.linux.org.uk>
 <522E17A1.1020205@hp.com>
 <20130909191028.GT13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909191028.GT13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 08:10:29PM +0100, Al Viro wrote:
> On Mon, Sep 09, 2013 at 02:46:57PM -0400, Waiman Long wrote:
> 
> > I am fine with your proposed change as long as it gets the job done.
> 
> I suspect that the real problem is the unlock part of read_seqretry_or_unlock();
> for d_walk() we want to be able to check if we need retry and continue walking
> if we do not.  Let's do it that way: I've applied your patch as is, with the
> next step being
> 	* split read_seqretry_or_unlock():
> need_seqretry() (return (!(seq & 1) && read_seqretry(lock, seq))
> done_seqretry() (if (seq & 1) write_sequnlock(lock, seq)),
> your if (read_seqretry_or_unlock(&rename_lock, &seq))
> 		goto restart;
> becoming
> 	if (need_seqretry(&rename_lock, seq)) {
> 		seq = 1;
> 		goto restart;
> 	}
> 	done_seqretry(&rename_lock, seq);
> 
> Then d_walk() is trivially massaged to use of read_seqbegin_or_lock(),
> need_seqretry() and done_seqretry().  Give me a few, I'll post it...

OK, how about this?  It splits read_seqretry_or_unlock(), takes
rcu_read_{lock,unlock} in the callers and converts d_walk() to those
primitives.  I've pushed that and your commit into vfs.git#experimental
(head at 48f5ec2, should propagate in a few); guys, please give it a look
and comment.

diff --git a/fs/dcache.c b/fs/dcache.c
index 38b1b09..b9caf47 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -100,30 +100,21 @@ static struct kmem_cache *dentry_cache __read_mostly;
  */
 static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
 {
-	if (!(*seq & 1)) {	/* Even */
+	if (!(*seq & 1))	/* Even */
 		*seq = read_seqbegin(lock);
-		rcu_read_lock();
-	} else			/* Odd */
+	else			/* Odd */
 		write_seqlock(lock);
 }
 
-/**
- * read_seqretry_or_unlock - end a seqretry or lock block & return retry status
- * lock	 : sequence lock
- * seq	 : sequence number
- * Return: 1 to retry operation again, 0 to continue
- */
-static inline int read_seqretry_or_unlock(seqlock_t *lock, int *seq)
+static inline int need_seqretry(seqlock_t *lock, int seq)
 {
-	if (!(*seq & 1)) {	/* Even */
-		rcu_read_unlock();
-		if (read_seqretry(lock, *seq)) {
-			(*seq)++;	/* Take writer lock */
-			return 1;
-		}
-	} else			/* Odd */
+	return !(seq & 1) && read_seqretry(lock, seq);
+}
+
+static inline void done_seqretry(seqlock_t *lock, int seq)
+{
+	if (seq & 1)
 		write_sequnlock(lock);
-	return 0;
 }
 
 /*
@@ -1047,7 +1038,7 @@ void shrink_dcache_for_umount(struct super_block *sb)
  * the parenthood after dropping the lock and check
  * that the sequence number still matches.
  */
-static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq)
+static struct dentry *try_to_ascend(struct dentry *old, unsigned seq)
 {
 	struct dentry *new = old->d_parent;
 
@@ -1061,7 +1052,7 @@ static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq
 	 */
 	if (new != old->d_parent ||
 		 (old->d_flags & DCACHE_DENTRY_KILLED) ||
-		 (!locked && read_seqretry(&rename_lock, seq))) {
+		 need_seqretry(&rename_lock, seq)) {
 		spin_unlock(&new->d_lock);
 		new = NULL;
 	}
@@ -1098,13 +1089,12 @@ static void d_walk(struct dentry *parent, void *data,
 {
 	struct dentry *this_parent;
 	struct list_head *next;
-	unsigned seq;
-	int locked = 0;
+	unsigned seq = 0;
 	enum d_walk_ret ret;
 	bool retry = true;
 
-	seq = read_seqbegin(&rename_lock);
 again:
+	read_seqbegin_or_lock(&rename_lock, &seq);
 	this_parent = parent;
 	spin_lock(&this_parent->d_lock);
 
@@ -1158,13 +1148,13 @@ resume:
 	 */
 	if (this_parent != parent) {
 		struct dentry *child = this_parent;
-		this_parent = try_to_ascend(this_parent, locked, seq);
+		this_parent = try_to_ascend(this_parent, seq);
 		if (!this_parent)
 			goto rename_retry;
 		next = child->d_u.d_child.next;
 		goto resume;
 	}
-	if (!locked && read_seqretry(&rename_lock, seq)) {
+	if (need_seqretry(&rename_lock, seq)) {
 		spin_unlock(&this_parent->d_lock);
 		goto rename_retry;
 	}
@@ -1173,17 +1163,13 @@ resume:
 
 out_unlock:
 	spin_unlock(&this_parent->d_lock);
-	if (locked)
-		write_sequnlock(&rename_lock);
+	done_seqretry(&rename_lock, seq);
 	return;
 
 rename_retry:
 	if (!retry)
 		return;
-	if (locked)
-		goto again;
-	locked = 1;
-	write_seqlock(&rename_lock);
+	seq = 1;
 	goto again;
 }
 
@@ -2745,6 +2731,7 @@ static int prepend_path(const struct path *path,
 	char *bptr;
 	int blen;
 
+	rcu_read_lock();
 restart:
 	bptr = *buffer;
 	blen = *buflen;
@@ -2783,8 +2770,13 @@ restart:
 
 		dentry = parent;
 	}
-	if (read_seqretry_or_unlock(&rename_lock, &seq))
+	if (!(seq & 1))
+		rcu_read_unlock();
+	if (need_seqretry(&rename_lock, seq)) {
+		seq = 1;
 		goto restart;
+	}
+	done_seqretry(&rename_lock, seq);
 
 	if (error >= 0 && bptr == *buffer) {
 		if (--blen < 0)
@@ -2957,6 +2949,7 @@ static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 	int len, seq = 0;
 	int error = 0;
 
+	rcu_read_lock();
 restart:
 	end = buf + buflen;
 	len = buflen;
@@ -2979,8 +2972,13 @@ restart:
 		retval = end;
 		dentry = parent;
 	}
-	if (read_seqretry_or_unlock(&rename_lock, &seq))
+	if (!(seq & 1))
+		rcu_read_unlock();
+	if (need_seqretry(&rename_lock, seq)) {
+		seq = 1;
 		goto restart;
+	}
+	done_seqretry(&rename_lock, seq);
 	if (error)
 		goto Elong;
 	return retval;
