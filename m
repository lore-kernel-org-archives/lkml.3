Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbaAHIBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:01:35 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24856 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049AbaAHIBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:01:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYGAFIFzVK2/3kU/2dsb2JhbABZgwuDObF3hVSBEBZ0giUBAQEDAScTPwULCAMNAQoJJQ8FKCETh3wHxEUXjwUHgySBEwSMW4s7hm1UgwuHSoNBKA
Date: Tue, 7 Jan 2014 00:30:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Wang <liwang@ubuntukylin.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Zefan Li <lizefan@huawei.com>, Matthew Wilcox <matthew@wil.cx>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 2/3] Add shrink_pagecache_parent
Message-ID: <20140106133049.GB5145@destitution>
References: <cover.1388409686.git.liwang@ubuntukylin.com>
 <249cbd3edaa84dd58a0626780fb546ddf7c1dc11.1388409687.git.liwang@ubuntukylin.com>
 <20140102155534.9b0cd498209d835d0c93837e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140102155534.9b0cd498209d835d0c93837e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 03:55:34PM -0800, Andrew Morton wrote:
> On Mon, 30 Dec 2013 21:45:17 +0800 Li Wang <liwang@ubuntukylin.com> wrote:
> 
> > Analogous to shrink_dcache_parent except that it collects inodes.
> > It is not very appropriate to be put in dcache.c, but d_walk can only
> > be invoked from here.
> 
> Please cc Dave Chinner on future revisions.  He be da man.
> 
> The overall intent of the patchset seems reasonable and I agree that it
> can't be efficiently done from userspace with the current kernel API. 
> We *could* do it from userspace by providing facilities for userspace to
> query the VFS caches: "is this pathname in the dentry cache" and "is
> this inode in the inode cache".
> 
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -1318,6 +1318,42 @@ void shrink_dcache_parent(struct dentry *parent)
> >  }
> >  EXPORT_SYMBOL(shrink_dcache_parent);
> >  
> > +static enum d_walk_ret gather_inode(void *data, struct dentry *dentry)
> > +{
> > +	struct list_head *list = data;
> > +	struct inode *inode = dentry->d_inode;
> > +
> > +	if ((inode == NULL) || ((!inode_owner_or_capable(inode)) &&
> > +				(!capable(CAP_SYS_ADMIN))))
> > +		goto out;
> > +	spin_lock(&inode->i_lock);
> > +	if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
> 
> It's unclear what rationale lies behind this particular group of tests.
> 
> > +		(inode->i_mapping->nrpages == 0) ||
> > +		(!list_empty(&inode->i_lru))) {
> 
> arg, the "Inode locking rules" at the top of fs/inode.c needs a
> refresh, I suspect.  It is too vague.

Yes, it probably does need work.

> Formally, inode->i_lru is protected by
> i_sb->s_inode_lru->node[nid].lock, not by ->i_lock.  I guess you can
> just do a list_lru_add() and that will atomically add the inode to your
> local list_lru if ->i_lru wasn't being used for anything else.

There is no such thing as a "local" list_lru. If you need to put an
object on a local list, then just use a local struct list_head.
That's how we do dispose lists for the objects being removed from
the LRU...

However, the only way you can check if the i_lru is not in use is to
hold the relevant LRU lock, and that's something that should not be
directly accessed - the internal locking of the LRU is private,
subject to change and as such is only accessible in th places that
it is explicitly exposed. i.e. the ->isolate callback.

> I *think* that your use of i_lock works OK, because code which fiddles
> with i_lru and s_inode_lru also takes i_lock.  However we need to
> decide which is the preferred and official lock.  ie: what is the
> design here??

THe LRU lock nests inside the i_lock. The i_lock does not provide
exclusive access to i_lru if the inode is on the LRU; LRU list
manipulations can modify i_lru (e.g. removing an adjacent inode in
the LRU list) without holding i_lock....

> However...  most inodes will be on an LRU list, won't they?  Doesn't
> this reuse of i_lru mean that many inodes will fail to be processed? 
> If so, we might need to add a new list_head to the inode, which will be
> problematic.

Yes, yes, and yes, adding a new list head to the struct inode for
such an uncommon corner case is a non-starter.

> Aside: inode_lru_isolate() fiddles directly with inode->i_lru without
> taking i_sb->s_inode_lru->node[nid].lock.  Why doesn't this make a
> concurrent s_inode_lru walker go oops??  Should we be using
> list_lru_del() in there? 

No, inode_lru_isoalte() is called with the lru lock held. The
specific list lock is passed as the lru_lock parameter, so it can be
droppped if a blocking operation needs to be done to prepare the
object for isolation.  So, calling list_lru_del() will deadlock on
the LRU lock.

> (which should have been called list_lru_del_init(), sigh).

That implies that removing the object from the LRU without
initialising the object being removed is a valid thing to do. It's
not - the lru_list code requires that an object not on an LRU is in
an intialised state so that list_empty() checks work correctly. i.e
list_lru_del(object); list_lru_add(object); needs to work, and that
is non-negotiable. So, no need for suffixes to define different
behaviours - there can be only one...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
