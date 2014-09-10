Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaIJSvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:51:38 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44416 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaIJSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:51:36 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Wed, 10 Sep 2014 14:51:33 -0400
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 01/12] locks: add a new struct file_locking_context
 pointer to struct inode
Message-ID: <20140910145133.4b06c81c@tlielax.poochiereds.net>
In-Reply-To: <20140910183815.GB4210@fieldses.org>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
	<1410359330-27564-2-git-send-email-jlayton@primarydata.com>
	<20140910183815.GB4210@fieldses.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 14:38:15 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Wed, Sep 10, 2014 at 10:28:39AM -0400, Jeff Layton wrote:
> > The current scheme of using the i_flock list is really difficult to
> > manage. Start conversion to a new scheme to eventually replace it.
> > 
> > We start by adding a new i_flctx to struct inode. For now, it lives in
> > parallel with i_flock list, but will eventually replace it. The idea is
> > to allocate a structure to sit in that pointer and act as a locus for
> > all things file locking.
> > 
> > We'll manage it with RCU and the i_lock, so that things like the
> > break_lease() check can use RCU to check for its presence.
> 
> And the plan is to allocate it once and then never destroy it until the
> inode's destroyed?
> 
> OK, seems like a sensible compromise assuming that typically only a
> small nunmber of files are ever locked.
> 
> --b.
> 

Oops! Forgot to update the patch description there...sorry!

My original idea was to use RCU to manage it, but it's simpler to just
allocate it once and destroy it with the inode.

With that, we don't need to use RCU. It is certainly possible to do
this with RCU though if we think that gives us any benefit. I just
didn't see any immediate need once I started diving into coding this up.

> > 
> > Signed-off-by: Jeff Layton <jlayton@primarydata.com>
> > ---
> >  fs/inode.c         |  3 ++-
> >  fs/locks.c         | 38 ++++++++++++++++++++++++++++++++++++++
> >  include/linux/fs.h | 13 +++++++++++++
> >  3 files changed, 53 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index 26753ba7b6d6..e87b47ab69a2 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -192,7 +192,7 @@ int inode_init_always(struct super_block *sb,
> > struct inode *inode) #ifdef CONFIG_FSNOTIFY
> >  	inode->i_fsnotify_mask = 0;
> >  #endif
> > -
> > +	inode->i_flctx = NULL;
> >  	this_cpu_inc(nr_inodes);
> >  
> >  	return 0;
> > @@ -235,6 +235,7 @@ void __destroy_inode(struct inode *inode)
> >  	BUG_ON(inode_has_buffers(inode));
> >  	security_inode_free(inode);
> >  	fsnotify_inode_delete(inode);
> > +	locks_free_lock_context(inode->i_flctx);
> >  	if (!inode->i_nlink) {
> >  		WARN_ON(atomic_long_read(&inode->i_sb->s_remove_count)
> > == 0); atomic_long_dec(&inode->i_sb->s_remove_count);
> > diff --git a/fs/locks.c b/fs/locks.c
> > index 735b8d3fa78c..6aa36bf21cc9 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -202,8 +202,43 @@ static DEFINE_HASHTABLE(blocked_hash,
> > BLOCKED_HASH_BITS); */
> >  static DEFINE_SPINLOCK(blocked_lock_lock);
> >  
> > +static struct kmem_cache *flctx_cache __read_mostly;
> >  static struct kmem_cache *filelock_cache __read_mostly;
> >  
> > +static struct file_lock_context *
> > +locks_get_lock_context(struct inode *inode)
> > +{
> > +	struct file_lock_context *new = NULL;
> > +
> > +	if (inode->i_flctx)
> > +		goto out;
> > +
> > +	new = kmem_cache_alloc(flctx_cache, GFP_KERNEL);
> > +	if (!new)
> > +		goto out;
> > +
> > +	spin_lock(&inode->i_lock);
> > +	if (likely(!inode->i_flctx)) {
> > +		spin_lock_init(&new->flc_lock);
> > +		INIT_LIST_HEAD(&new->flc_flock);
> > +		swap(inode->i_flctx, new);
> > +	}
> > +	spin_unlock(&inode->i_lock);
> > +	if (new)
> > +		kmem_cache_free(flctx_cache, new);
> > +out:
> > +	return inode->i_flctx;
> > +}
> > +
> > +void
> > +locks_free_lock_context(struct file_lock_context *ctx)
> > +{
> > +	if (ctx) {
> > +		WARN_ON_ONCE(!list_empty(&ctx->flc_flock));
> > +		kmem_cache_free(flctx_cache, ctx);
> > +	}
> > +}
> > +
> >  static void locks_init_lock_heads(struct file_lock *fl)
> >  {
> >  	INIT_HLIST_NODE(&fl->fl_link);
> > @@ -2621,6 +2656,9 @@ static int __init filelock_init(void)
> >  {
> >  	int i;
> >  
> > +	flctx_cache = kmem_cache_create("file_lock_ctx",
> > +			sizeof(struct file_lock_context), 0,
> > SLAB_PANIC, NULL); +
> >  	filelock_cache = kmem_cache_create("file_lock_cache",
> >  			sizeof(struct file_lock), 0, SLAB_PANIC,
> > NULL); 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index bb9484ae1eef..090212e26d12 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -594,6 +594,7 @@ struct inode {
> >  #endif
> >  	const struct file_operations	*i_fop;	/*
> > former ->i_op->default_file_ops */ struct file_lock	*i_flock;
> > +	struct file_lock_context	*i_flctx;
> >  	struct address_space	i_data;
> >  #ifdef CONFIG_QUOTA
> >  	struct dquot		*i_dquot[MAXQUOTAS];
> > @@ -933,6 +934,11 @@ struct file_lock {
> >  	} fl_u;
> >  };
> >  
> > +struct file_lock_context {
> > +	spinlock_t		flc_lock;
> > +	struct list_head	flc_flock;
> > +};
> > +
> >  /* The following constant reflects the upper bound of the
> > file/locking space */ #ifndef OFFSET_MAX
> >  #define INT_LIMIT(x)	(~((x)1 << (sizeof(x)*8 - 1)))
> > @@ -959,6 +965,7 @@ extern int fcntl_setlease(unsigned int fd,
> > struct file *filp, long arg); extern int fcntl_getlease(struct file
> > *filp); 
> >  /* fs/locks.c */
> > +void locks_free_lock_context(struct file_lock_context *ctx);
> >  void locks_free_lock(struct file_lock *fl);
> >  extern void locks_init_lock(struct file_lock *);
> >  extern struct file_lock * locks_alloc_lock(void);
> > @@ -1016,6 +1023,12 @@ static inline int fcntl_getlease(struct file
> > *filp) return 0;
> >  }
> >  
> > +static inline void
> > +locks_free_lock_context(struct file_lock_context *ctx)
> > +{
> > +	return;
> > +}
> > +
> >  static inline void locks_init_lock(struct file_lock *fl)
> >  {
> >  	return;
> > -- 
> > 1.9.3
> > 


-- 
Jeff Layton <jlayton@primarydata.com>
