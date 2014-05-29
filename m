Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbaE2F00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:26:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54834 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934410AbaE2F0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 01:26:23 -0400
Date: Thu, 29 May 2014 06:26:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140529052621.GH18016@ZenIV.linux.org.uk>
References: <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
 <20140529031149.GE18016@ZenIV.linux.org.uk>
 <CA+55aFyHCF1+DfxndzxkGLLoNErRF2MA0YWtdx7UOTJ=gQWhEw@mail.gmail.com>
 <20140529051647.GG18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529051647.GG18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:16:47AM +0100, Al Viro wrote:
> On Wed, May 28, 2014 at 09:21:00PM -0700, Linus Torvalds wrote:
> > On Wed, May 28, 2014 at 8:11 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Here's an updated patch, hopefully slightly less vomit-inducing.
> > 
> > Hmm. Less vomit-inducing, except for this part:
> 
> > Ugh, that just *screams* for a helper function. Something like
> > 
> >         parent = get_parent_and_lock(dentry);
> > 
> > or whatever, with that trylock/renamelock dance separated out. The
> > rule would be that it would lock the "dentry", and return the
> > (similarly locked) parent. Or NULL for a root dentry, of course.
> > 
> > Please?
> 
> Already done in my current tree; see below for the next commit in there...
> I can separate that helper from the rest (dealing with the same livelock
> for dentry_kill(dentry, 1) caller in shrink_dentry_list()).  All of that
> is very much subject to reordering, resplitting, writing more decent commit
> messages, etc.

Except that it's from the wrong branch ;-/  Correct one follows:

commit fb860957449c07c6f1a1dd911e83a635b6f11f21
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu May 29 00:37:49 2014 -0400

    deal with "put the parent" side of shrink_dentry_list()

diff --git a/fs/dcache.c b/fs/dcache.c
index 6c2a92e..628a791 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -793,30 +793,34 @@ restart:
 }
 EXPORT_SYMBOL(d_prune_aliases);
 
-static void shrink_dentry_list(struct list_head *list)
+static inline struct dentry *lock_parent(struct dentry *dentry)
 {
-	struct dentry *dentry, *parent;
+	struct dentry *parent = dentry->d_parent;
+	if (IS_ROOT(dentry))
+		return NULL;
+	if (unlikely(!spin_trylock(&parent->d_lock))) {
+		spin_unlock(&dentry->d_lock);
+		read_seqlock_excl(&rename_lock);
+		parent = NULL;
+		if (!IS_ROOT(dentry)) {
+			parent = dentry->d_parent;
+			spin_lock(&parent->d_lock);
+		}
+		read_sequnlock_excl(&rename_lock);
+		spin_lock(&dentry->d_lock);
+	}
+	return parent;
+}
 
+static void shrink_dentry_list(struct list_head *list)
+{
 	while (!list_empty(list)) {
 		struct inode *inode;
-		dentry = list_entry(list->prev, struct dentry, d_lru);
+		struct dentry *dentry = list_entry(list->prev, struct dentry, d_lru);
+		struct dentry *parent;
 
-		parent = NULL;
 		spin_lock(&dentry->d_lock);
-		if (!IS_ROOT(dentry)) {
-			parent = dentry->d_parent;
-			if (unlikely(!spin_trylock(&parent->d_lock))) {
-				spin_unlock(&dentry->d_lock);
-				parent = NULL;
-				read_seqlock_excl(&rename_lock);
-				if (!IS_ROOT(dentry)) {
-					parent = dentry->d_parent;
-					spin_lock(&parent->d_lock);
-				}
-				read_sequnlock_excl(&rename_lock);
-				spin_lock(&dentry->d_lock);
-			}
-		}
+		parent = lock_parent(dentry);
 
 		/*
 		 * The dispose list is isolated and dentries are not accounted
@@ -864,8 +868,26 @@ static void shrink_dentry_list(struct list_head *list)
 		 * fragmentation.
 		 */
 		dentry = parent;
-		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
-			dentry = dentry_kill(dentry);
+		while (dentry && !lockref_put_or_lock(&dentry->d_lockref)) {
+			parent = lock_parent(dentry);
+			if (dentry->d_lockref.count != 1) {
+				dentry->d_lockref.count--;
+				spin_unlock(&dentry->d_lock);
+				if (parent)
+					spin_unlock(&parent->d_lock);
+				break;
+			}
+			inode = dentry->d_inode;	/* can't be NULL */
+			if (unlikely(!spin_trylock(&inode->i_lock))) {
+				spin_unlock(&dentry->d_lock);
+				if (parent)
+					spin_unlock(&parent->d_lock);
+				cpu_relax();
+				continue;
+			}
+			__dentry_kill(dentry);
+			dentry = parent;
+		}
 	}
 }
 
