Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaFKMa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:30:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53549 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaFKMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:30:25 -0400
Date: Wed, 11 Jun 2014 13:30:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.15 .. and continuation of merge window
Message-ID: <20140611123022.GW18016@ZenIV.linux.org.uk>
References: <CA+55aFw3A=ycq4kRpsDDoV4+rzg0z2kwfE9C9Bg1nSwiYfUpLw@mail.gmail.com>
 <13591.1402284634@jrobl>
 <20140611011036.GV18016@ZenIV.linux.org.uk>
 <26914.1402479178@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26914.1402479178@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 06:32:58PM +0900, J. R. Okajima wrote:
> 
> Al Viro:
> > So I suspect that the right fix is a bit trickier - in addition to check
> > on the fast path (i.e. when trylock gets us the lock on parent), we need
> > to
> > 	* get rcu_read_lock() before dropping ->d_lock.
> > 	* check if dentry is already doomed right after taking rcu_read_lock();
> > if not, any value we might see in ->d_parent afterwards will point to object
> > not freed until we drop rcu_read_lock.
> >
> > IOW, something like the delta below.  Comments?
> 
> I will try testing later.
> For now, as a comment before testing, the patch looks weird for me. It
> checks d_lockref.count twice during d_lockref.lock held. It must be the
> same result, isn't it?

Right you are.  So what we need is
	* check that thing once, as in your variant (I'd still prefer to
check ->d_lockref.count instead of ->d_flags, but it's the same thing being
tested)
	* ... and get rcu_read_lock() *before* dropping ->d_lock.

The former guarantees that the address we are doing trylock on would be that
of a live dentry.  The latter makes sure that anything assigned to 
dentry->d_parent after we drop ->d_lock will not be freed until we drop
rcu_read_lock.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/dcache.c b/fs/dcache.c
index be2bea8..e99c6f5 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -532,10 +532,12 @@ static inline struct dentry *lock_parent(struct dentry *dentry)
 	struct dentry *parent = dentry->d_parent;
 	if (IS_ROOT(dentry))
 		return NULL;
+	if (unlikely((int)dentry->d_lockref.count < 0))
+		return NULL;
 	if (likely(spin_trylock(&parent->d_lock)))
 		return parent;
-	spin_unlock(&dentry->d_lock);
 	rcu_read_lock();
+	spin_unlock(&dentry->d_lock);
 again:
 	parent = ACCESS_ONCE(dentry->d_parent);
 	spin_lock(&parent->d_lock);
