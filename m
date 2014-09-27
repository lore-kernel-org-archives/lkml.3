Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaI0Sbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 14:31:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49794 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaI0Sbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 14:31:43 -0400
Date: Sat, 27 Sep 2014 19:31:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140927183139.GT7996@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
 <20140924185521.GC7996@ZenIV.linux.org.uk>
 <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 10:56:57AM -0700, Linus Torvalds wrote:

>  - make a new "move_name(src,dst)" that explicitly moves names, and
> explicitly knows that the source needs to be kept alive (although it
> *could* also look at the source dentry refcount to decide whether it
> needs to be careful or not). And do it right for the long names too,
> not just the inline case.

Er?  Source dentry refcount doesn't matter at all - *that* one gets
rehashed, so we must get its name right, no matter what.  The target
one is where it becomes interesting.  And I doubt it's worth bothering
with refcount checks on that either, TBH...

The reason why we really can't get it right for long names without more
serious surgery is that currently the lifetime of external name is
the same as of dentry having that name.  And that makes "just copy them
over, long or not" a problem - we suddenly get two dentries sharing the
external name.  And we hit that under a shitload of spinlocks, so
allocating a separate copy isn't attractive.  Mikhail (IIRC - I hadn't
watched this thread all that closely back then, so I might be misattributing)
had proposed refcounting the external names.  That would work, but we'll
need to get it right.  Sure, we can make that refcount atomic_t; it's not
as if we'll be playing with it a lot.  However, if the *source* name had
been external, we need to drop the refcount on that, and we need to
RCU-delay actual freeing.  Right now the delay comes from RCU-delaying
__d_free(), with some optimisations for dentries that had never been hashed;
this will be somewhat hairier.

> Al (or Mikhail) - willing to do that extra cleanup? Please?

See above.  I can do that, but it will be less trivial than you seem to
expect it to be.  Anyway, the situation right now: vfs.git#for-linus
survives the testing (and I'd like your S-o-b on the last one-liner there;
if you have saner commit message - even better).  That can go in right
now, as far as I'm concerned.

The minimal port of Mikhail's patch on top of that is below; it doesn't
include what you are asking for, it's just an update to the situation past
merging __d_move() and __d_materialise_dentry().

We can get the long name cases right, and I agree that it'll make the
things nicer, but it might take a couple of days to get right.  The thing
I'm concerned about is not screwing DCACHE_RCUACCESS up.

BTW, the comments about being more careful with ->d_name.hash than with
->d_name.name are from back in 2.3.40s; they became obsolete by 2.3.60s,
when we started to unhash the target instead of swapping hash chain positions
followed by d_delete() as we used to do when dcache was first introduced.
It's a really old piece of detritus...

diff --git a/fs/dcache.c b/fs/dcache.c
index 7599d35..cb25a1a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2372,7 +2372,8 @@ void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
 }
 EXPORT_SYMBOL(dentry_update_name_case);
 
-static void switch_names(struct dentry *dentry, struct dentry *target)
+static void switch_names(struct dentry *dentry, struct dentry *target,
+			 bool exchange)
 {
 	if (dname_external(target)) {
 		if (dname_external(dentry)) {
@@ -2406,6 +2407,12 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
 			 */
 			unsigned int i;
 			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
+			if (!exchange) {
+				memcpy(dentry->d_iname, target->d_name.name,
+						target->d_name.len + 1);
+				dentry->d_name.hash_len = target->d_name.hash_len;
+				return;
+			}
 			for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
 				swap(((long *) &dentry->d_iname)[i],
 				     ((long *) &target->d_iname)[i]);
@@ -2456,12 +2463,15 @@ static void dentry_unlock_for_move(struct dentry *dentry, struct dentry *target)
  * When switching names, the actual string doesn't strictly have to
  * be preserved in the target - because we're dropping the target
  * anyway. As such, we can just do a simple memcpy() to copy over
- * the new name before we switch.
- *
- * Note that we have to be a lot more careful about getting the hash
- * switched - we have to switch the hash value properly even if it
- * then no longer matches the actual (corrupted) string of the target.
- * The hash value has to match the hash queue that the dentry is on..
+ * the new name before we switch, unless we are going to rehash
+ * it.  Note that if we *do* unhash the target, we are not allowed
+ * to rehash it without giving it a new name/hash key - whether
+ * we swap or overwrite the names here, resulting name won't match
+ * the reality in filesystem; it's only there for d_path() purposes.
+ * Note that all of this is happening under rename_lock, so the
+ * any hash lookup seeing it in the middle of manipulations will
+ * be discarded anyway.  So we do not care what happens to the hash
+ * key in that case.
  */
 /*
  * __d_move - move a dentry
@@ -2507,9 +2517,8 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
 			   d_hash(dentry->d_parent, dentry->d_name.hash));
 	}
 
-
 	/* Switch the names.. */
-	switch_names(dentry, target);
+	switch_names(dentry, target, exchange);
 
 	/* ... and switch them in the tree */
 	if (IS_ROOT(dentry)) {
