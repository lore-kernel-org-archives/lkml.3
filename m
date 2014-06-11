Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaFKBKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 21:10:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51804 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaFKBKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 21:10:39 -0400
Date: Wed, 11 Jun 2014 02:10:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.15 .. and continuation of merge window
Message-ID: <20140611011036.GV18016@ZenIV.linux.org.uk>
References: <CA+55aFw3A=ycq4kRpsDDoV4+rzg0z2kwfE9C9Bg1nSwiYfUpLw@mail.gmail.com>
 <13591.1402284634@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13591.1402284634@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 12:30:34PM +0900, J. R. Okajima wrote:
> 
> Linus Torvalds:
> > So I ended up doing an rc8 because I was a bit worried about some
> > last-minute dcache fixes, but it turns out that nobody seemed to even
> > notice those. We did have other issues during the week, though, so it
> 	:::
> 
> I am afraid there is a problem in dcache. Please read
> http://marc.info/?l=linux-fsdevel&m=140214911608925&w=2

There is a problem, all right, but your fix doesn't really fix it - just
narrows the race window ;-/  I would really like to detach the bugger
as soon as __dentry_kill() removes it from the list of children, but
unfortunately NFS wants it to be still valid in ->d_iput() (BTW,
nfs_can_unlink() is doing something very odd -
        parent = dget_parent(dentry);
        if (parent == NULL)
                goto out_free;
is pointless, since dget_parent() never returns NULL; what was that
check trying to accomplish?)

Your scenario isn't feasible as described, but something similar can
happen with *two* shrinkers racing - dirB might've ended up on one list,
with fileC looked up a bit later, ending up on another list right after
that.  So the problem is real; unfortunately, DCACHE_DENTRY_KILLED might
have appeared right after we'd dropped ->d_lock.

So I suspect that the right fix is a bit trickier - in addition to check
on the fast path (i.e. when trylock gets us the lock on parent), we need
to
	* get rcu_read_lock() before dropping ->d_lock.
	* check if dentry is already doomed right after taking rcu_read_lock();
if not, any value we might see in ->d_parent afterwards will point to object
not freed until we drop rcu_read_lock.

IOW, something like the delta below.  Comments?

PS: apologies for being MIA; caught some crap, spent the last week being
very unhappy ;-/  I'll send a pull request tomorrow morning.

diff --git a/fs/dcache.c b/fs/dcache.c
index be2bea8..65ec10f 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -532,10 +532,16 @@ static inline struct dentry *lock_parent(struct dentry *dentry)
 	struct dentry *parent = dentry->d_parent;
 	if (IS_ROOT(dentry))
 		return NULL;
+	if (unlikely((int)dentry->d_lockref.count < 0))
+		return NULL;
 	if (likely(spin_trylock(&parent->d_lock)))
 		return parent;
-	spin_unlock(&dentry->d_lock);
 	rcu_read_lock();
+	if (unlikely((int)dentry->d_lockref.count < 0)) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	spin_unlock(&dentry->d_lock);
 again:
 	parent = ACCESS_ONCE(dentry->d_parent);
 	spin_lock(&parent->d_lock);
