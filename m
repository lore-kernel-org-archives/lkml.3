Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3JXJAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:00:13 -0400
Received: from ip-77-221-165-120.dsl.twang.net ([77.221.165.120]:53759 "EHLO
	hsia.quadriga.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753519Ab3JXJAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:00:10 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2013 05:00:10 EDT
Date: Thu, 24 Oct 2013 01:52:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jason Baron <jbaron@akamai.com>
Cc: akpm@linux-foundation.org, normalperson@yhbt.net, nzimmer@sgi.com,
        viro@zeniv.linux.org.uk, nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] epoll: optimize EPOLL_CTL_DEL using rcu
Message-ID: <20131024085238.GA4834@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1380645717.git.jbaron@akamai.com>
 <788e40eac585039ded51e6d70856c8d432b6e97b.1380645717.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <788e40eac585039ded51e6d70856c8d432b6e97b.1380645717.git.jbaron@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 05:08:10PM +0000, Jason Baron wrote:
> Optimize EPOLL_CTL_DEL such that it does not require the 'epmutex' by
> converting the file->f_ep_links list into an rcu one.  In this way, we can
> traverse the epoll network on the add path in parallel with deletes. 
> Since deletes can't create loops or worse wakeup paths, this is safe.
> 
> This patch in combination with the patch "epoll: Do not take global 'epmutex'
> for simple topologies", shows a dramatic performance improvement in
> scalability for SPECjbb.

A few questions and comments below.

							Thanx, Paul

> Signed-off-by: Jason Baron <jbaron@akamai.com>
> Tested-by: Nathan Zimmer <nzimmer@sgi.com>
> Cc: Eric Wong <normalperson@yhbt.net>
> Cc: Nelson Elhage <nelhage@nelhage.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Davide Libenzi <davidel@xmailserver.org>
> Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/eventpoll.c |   65 +++++++++++++++++++++++++++++------------------
>  1 file changed, 41 insertions(+), 24 deletions(-)
> 
> diff -puN fs/eventpoll.c~epoll-optimize-epoll_ctl_del-using-rcu fs/eventpoll.c
> --- a/fs/eventpoll.c~epoll-optimize-epoll_ctl_del-using-rcu
> +++ a/fs/eventpoll.c
> @@ -42,6 +42,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
>  #include <linux/compat.h>
> +#include <linux/rculist.h>
> 
>  /*
>   * LOCKING:
> @@ -134,8 +135,12 @@ struct nested_calls {
>   * of these on a server and we do not want this to take another cache line.
>   */
>  struct epitem {
> -	/* RB tree node used to link this structure to the eventpoll RB tree */
> -	struct rb_node rbn;
> +	union {
> +		/* RB tree node links this structure to the eventpoll RB tree */
> +		struct rb_node rbn;

And RCU readers never need to use rbn, right?  (That appears to be the case,
so good.)

> +		/* Used to free the struct epitem */
> +		struct rcu_head rcu;
> +	};
> 
>  	/* List header used to link this structure to the eventpoll ready list */
>  	struct list_head rdllink;
> @@ -166,6 +171,9 @@ struct epitem {
> 
>  	/* The structure that describe the interested events and the source fd */
>  	struct epoll_event event;
> +
> +	/* The fllink is in use. Since rcu can't do 'list_del_init()' */
> +	int on_list;
>  };
> 
>  /*
> @@ -672,6 +680,12 @@ static int ep_scan_ready_list(struct eve
>  	return error;
>  }
> 
> +static void epi_rcu_free(struct rcu_head *head)
> +{
> +	struct epitem *epi = container_of(head, struct epitem, rcu);
> +	kmem_cache_free(epi_cache, epi);

Sigh.  I suppose that I need to create a kmem_cache_free_rcu() at some
point...

> +}
> +
>  /*
>   * Removes a "struct epitem" from the eventpoll RB tree and deallocates
>   * all the associated resources. Must be called with "mtx" held.
> @@ -693,8 +707,10 @@ static int ep_remove(struct eventpoll *e
> 
>  	/* Remove the current item from the list of epoll hooks */
>  	spin_lock(&file->f_lock);
> -	if (ep_is_linked(&epi->fllink))
> -		list_del_init(&epi->fllink);
> +	if (epi->on_list) {
> +		list_del_rcu(&epi->fllink);

OK, here is the list_del_rcu().  It does seem to precede the call_rcu()
below, as it must.  Of course, if !epi->onlist, you could just free
it without going through call_rcu(), but perhaps that optimization is
not worthwhile.

> +		epi->on_list = 0;
> +	}
>  	spin_unlock(&file->f_lock);
> 
>  	rb_erase(&epi->rbn, &ep->rbr);
> @@ -705,9 +721,14 @@ static int ep_remove(struct eventpoll *e
>  	spin_unlock_irqrestore(&ep->lock, flags);
> 
>  	wakeup_source_unregister(ep_wakeup_source(epi));
> -
> -	/* At this point it is safe to free the eventpoll item */
> -	kmem_cache_free(epi_cache, epi);
> +	/*
> +	 * At this point it is safe to free the eventpoll item. Use the union
> +	 * field epi->rcu, since we are trying to minimize the size of
> +	 * 'struct epitem'. The 'rbn' field is no longer in use. Protected by
> +	 * ep->mtx. The rcu read side, reverse_path_check_proc(), does not make
> +	 * use of the rbn field.
> +	 */
> +	call_rcu(&epi->rcu, epi_rcu_free);

And here is the call_rcu(), so good.  At least assuming there are no other
RCU-reader-accessible lists that this thing is on.  (If there are, then it
needs to be removed from these lists as well.)

> 
>  	atomic_long_dec(&ep->user->epoll_watches);
> 
> @@ -873,7 +894,6 @@ static const struct file_operations even
>   */
>  void eventpoll_release_file(struct file *file)
>  {
> -	struct list_head *lsthead = &file->f_ep_links;
>  	struct eventpoll *ep;
>  	struct epitem *epi;
> 
> @@ -891,17 +911,12 @@ void eventpoll_release_file(struct file
>  	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
>  	 */
>  	mutex_lock(&epmutex);
> -
> -	while (!list_empty(lsthead)) {
> -		epi = list_first_entry(lsthead, struct epitem, fllink);
> -
> +	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
>  		ep = epi->ep;
> -		list_del_init(&epi->fllink);
>  		mutex_lock_nested(&ep->mtx, 0);
>  		ep_remove(ep, epi);
>  		mutex_unlock(&ep->mtx);
>  	}
> -
>  	mutex_unlock(&epmutex);
>  }
> 
> @@ -1139,7 +1154,9 @@ static int reverse_path_check_proc(void
>  	struct file *child_file;
>  	struct epitem *epi;
> 
> -	list_for_each_entry(epi, &file->f_ep_links, fllink) {
> +	/* CTL_DEL can remove links here, but that can't increase our count */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
>  		child_file = epi->ep->file;
>  		if (is_file_epoll(child_file)) {
>  			if (list_empty(&child_file->f_ep_links)) {

Hmmm...  It looks like ep_call_nested() acquires a global spinlock.
Perhaps that is fixed in a later patch in this series?  Otherwise,
this will be a bottleneck on large systems.

> @@ -1161,6 +1178,7 @@ static int reverse_path_check_proc(void
>  				"file is not an ep!\n");
>  		}
>  	}
> +	rcu_read_unlock();
>  	return error;
>  }
> 
> @@ -1255,6 +1273,7 @@ static int ep_insert(struct eventpoll *e
>  	epi->event = *event;
>  	epi->nwait = 0;
>  	epi->next = EP_UNACTIVE_PTR;
> +	epi->on_list = 0;
>  	if (epi->event.events & EPOLLWAKEUP) {
>  		error = ep_create_wakeup_source(epi);
>  		if (error)
> @@ -1287,7 +1306,8 @@ static int ep_insert(struct eventpoll *e
> 
>  	/* Add the current item to the list of active epoll hook for this file */
>  	spin_lock(&tfile->f_lock);

Looks like ->f_lock protects updates to the RCU-protected structure.

> -	list_add_tail(&epi->fllink, &tfile->f_ep_links);
> +	list_add_tail_rcu(&epi->fllink, &tfile->f_ep_links);
> +	epi->on_list = 1;
>  	spin_unlock(&tfile->f_lock);
> 
>  	/*
> @@ -1328,8 +1348,8 @@ static int ep_insert(struct eventpoll *e
> 
>  error_remove_epi:
>  	spin_lock(&tfile->f_lock);

More evidence in favor of ->f_lock protecting updates to the RCU-protected
data structure.

> -	if (ep_is_linked(&epi->fllink))
> -		list_del_init(&epi->fllink);
> +	if (epi->on_list)
> +		list_del_rcu(&epi->fllink);

OK, this list_del_rcu() call is for handling failed inserts.

But if we had to use list_del_rcu(), don't we also need to wait a grace
period before freeing the item?  Or does rb_erase() somehow do that?

Or has placing it ->on_list somehow avoided exposing it to readers?
(Of course, it this is the case, the list_del_rcu() could remain
a list_del_init()...)

>  	spin_unlock(&tfile->f_lock);
> 
>  	rb_erase(&epi->rbn, &ep->rbr);
> @@ -1846,15 +1866,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
>  	 * and hang them on the tfile_check_list, so we can check that we
>  	 * haven't created too many possible wakeup paths.
>  	 *
> -	 * We need to hold the epmutex across both ep_insert and ep_remove
> -	 * b/c we want to make sure we are looking at a coherent view of
> -	 * epoll network.
> +	 * We need to hold the epmutex across ep_insert to prevent
> +	 * multple adds from creating loops in parallel.
>  	 */
> -	if (op == EPOLL_CTL_ADD || op == EPOLL_CTL_DEL) {
> +	if (op == EPOLL_CTL_ADD) {
>  		mutex_lock(&epmutex);
>  		did_lock_epmutex = 1;
> -	}
> -	if (op == EPOLL_CTL_ADD) {
>  		if (is_file_epoll(tf.file)) {
>  			error = -ELOOP;
>  			if (ep_loop_check(ep, tf.file) != 0) {
> _
> 
