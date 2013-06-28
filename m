Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3F1JtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:49:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab3F1JtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:49:20 -0400
Date: Fri, 28 Jun 2013 11:49:15 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130628094915.GB3856@quack.suse.cz>
References: <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627143055.GA1000@redhat.com>
 <20130628011843.GD32195@dastard>
 <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
 <20130628035437.GB29338@dastard>
 <CA+55aFyZYsbMpP+6dkdkhdDn9gpTx0dkv25MUtcnswer_a2x9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyZYsbMpP+6dkdkhdDn9gpTx0dkv25MUtcnswer_a2x9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-06-13 19:59:50, Linus Torvalds wrote:
> On Thu, Jun 27, 2013 at 5:54 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jun 27, 2013 at 04:54:53PM -1000, Linus Torvalds wrote:
> >>
> >> So what made it all start happening now? I don't recall us having had
> >> these kinds of issues before..
> >
> > Not sure - it's a sudden surprise for me, too. Then again, I haven't
> > been looking at sync from a performance or lock contention point of
> > view any time recently.  The algorithm that wait_sb_inodes() is
> > effectively unchanged since at least 2009, so it's probably a case
> > of it having been protected from contention by some external factor
> > we've fixed/removed recently.  Perhaps the bdi-flusher thread
> > replacement in -rc1 has changed the timing sufficiently that it no
> > longer serialises concurrent sync calls as much....
> >
> > However, the inode_sb_list_lock is known to be a badly contended
> > lock from a create/unlink fastpath for XFS, so it's not like this sort
> > of thing is completely unexpected.
> 
> That whole inode_sb_list_lock seems moronic. Why isn't it a per-sb
> one? No, that won't fix all problems, but it might at least help a
> *bit*.
> 
> Also, looking some more now at that wait_sb_inodes logic, I have to
> say that if the problem is primarily the inode->i_lock, then that's
> just crazy. We normally shouldn't even *need* that lock, since we
> could do a totally unlocked iget() as long as the count is non-zero.
> 
> And no, I don't think really need the i_lock for checking
> "mapping->nrpages == 0" or the magical "inode is being freed" bits
> either. Or at least we could easily do some of this optimistically for
> the common cases.
> 
> So instead of doing
> 
>                 struct address_space *mapping = inode->i_mapping;
> 
>                 spin_lock(&inode->i_lock);
>                 if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
>                     (mapping->nrpages == 0)) {
>                         spin_unlock(&inode->i_lock);
>                         continue;
>                 }
>                 __iget(inode);
>                 spin_unlock(&inode->i_lock);
> 
> I really think we could do that without getting the inode lock at
> *all* in the common case.
> 
> I'm attaching a pretty trivial patch, which may obviously be trivially
> totally flawed. I have not tested this in any way, but half the new
> lines are comments about why it's doing what it is doing.  And I
> really think that it should make the "actually take the inode lock" be
> something quite rare.
> 
> And quite frankly, I'd much rather get *rid* of crazy i_lock accesses,
> than try to be clever and use a whole different list at this point.
> Not that I disagree that it wouldn't be much nicer to use a separate
> list in the long run, but for a short-term solution I'd much rather
> keep the old logic and just tweak it to be much more usable..
> 
> Hmm? Al? Jan? Comments?
  Yeah, the patch looks good to me so if it helps Dave with his softlockups
I also think it's a safer alternative than Dave's patch for 3.10. BTW, one
suggestion for improvement below:

 fs/fs-writeback.c | 58 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3be57189efd5..3dcc8b202a40 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1206,6 +1206,52 @@ out_unlock_inode:
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
+/*
+ * Do we want to get the inode for writeback?
+ */
+static int get_inode_for_writeback(struct inode *inode)
+{
+	struct address_space *mapping = inode->i_mapping;
+
+	/*
+	 * It's a data integrity sync, but we don't care about
+	 * racing with new pages - we're about data integrity
+	 * of things in the past, not the future
+	 */
+	if (!ACCESS_ONCE(mapping->nrpages))
+		return 0;
  I think we can change the above condition to:
	if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
		return 0;

  That should make us skip most of the inodes in the case Dave Chinner was
testing.

								Honza
+
+	/* Similar logic wrt the I_NEW bit */
+	if (ACCESS_ONCE(inode->i_state) & I_NEW)
+		return 0;
+
+	/*
+	 * When the inode count goes down to zero, the
+	 * I_WILL_FREE and I_FREEING bits might get set.
+	 * But not before.
+	 *
+	 * So if we get this, we know those bits are
+	 * clear, and the inode is still interesting.
+	 */
+	if (atomic_inc_not_zero(&inode->i_count))
+		return 1;
+
+	/*
+	 * Slow path never happens normally, since any
+	 * active inode will be referenced by a dentry
+	 * and thus caught above
+	 */
+	spin_lock(&inode->i_lock);
+	if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+	    (mapping->nrpages == 0)) {
+		spin_unlock(&inode->i_lock);
+		return 0;
+	}
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	return 1;
+}
+
 static void wait_sb_inodes(struct super_block *sb)
 {
 	struct inode *inode, *old_inode = NULL;
@@ -1226,16 +1272,8 @@ static void wait_sb_inodes(struct super_block *sb)
 	 * we still have to wait for that writeout.
 	 */
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		struct address_space *mapping = inode->i_mapping;
-
-		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    (mapping->nrpages == 0)) {
-			spin_unlock(&inode->i_lock);
+		if (!get_inode_for_writeback(inode))
 			continue;
-		}
-		__iget(inode);
-		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_sb_list_lock);
 
 		/*
@@ -1249,7 +1287,7 @@ static void wait_sb_inodes(struct super_block *sb)
 		iput(old_inode);
 		old_inode = inode;
 
-		filemap_fdatawait(mapping);
+		filemap_fdatawait(inode->i_mapping);
 
 		cond_resched();
 


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
