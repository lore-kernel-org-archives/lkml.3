Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3EJN6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:58:53 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59058
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928Ab3EJN6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:58:52 -0400
Date: Fri, 10 May 2013 15:57:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130510135716.GA304@dyad.programming.kicks-ass.net>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-8-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368115089-8909-8-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:58:07AM -0400, Sasha Levin wrote:

So you're doing instance tracking and not creating classes like the kernel
lockdep does? While that reduces false positives it also greatly reduces the
effectiveness of lockdep.

The power of lock-classes is that it increases the chance of catching potential
deadlocks without there ever actually being a deadlock.

I think something like so:

> +/**
> + * struct lock_lookup - liblockdep's view of a single unique lock
> + * @orig: pointer to the original pthread lock, used for lookups
> + * @dep_map: lockdep's dep_map structure
> + * @key: lockdep's key structure
> + * @node: rb-tree node used to store the lock in a global tree
> + * @name: a unique name for the lock
> + */
> +struct lock_lookup {
> +	void *orig; /* Original pthread lock, used for lookups */
> +	struct lockdep_map dep_map; /* Since all locks are dynamic, we need
> +				     * a dep_map and a key for each lock */

-	struct lock_class_key key;

> +	struct rb_node node;
> +#define LIBLOCKDEP_MAX_LOCK_NAME 22
> +	char name[LIBLOCKDEP_MAX_LOCK_NAME];
> +};

> +static struct rb_node **__get_lock_node(void *lock, struct rb_node **parent)
> +{
> +	struct rb_node **node = &locks.rb_node;
> +	struct lock_lookup *l;
> +
> +	*parent = NULL;
> +
> +	while (*node) {
> +		l = rb_entry(*node, struct lock_lookup, node);
> +
> +		*parent = *node;
> +		if (lock < l->orig)
> +			node = &l->node.rb_left;
> +		else if (lock > l->orig)
> +			node = &l->node.rb_right;
> +		else
> +			return node;
> +	}
> +
> +	return node;
> +}
> +
> +/**
> + * __get_lock - find or create a lock instance
> + * @lock: pointer to a pthread lock function
> + *
> + * Try to find an existing lock in the rbtree using the provided pointer. If
> + * one wasn't found - create it.
> + */

+ static struct lock_lookup *__get_lock(void *lock, unsigned long addr)

> +{
> +	struct rb_node **node, *parent;
> +	struct lock_lookup *l;
> +
> +	ll_pthread_rwlock_rdlock(&locks_rwlock);
> +	node = __get_lock_node(lock, &parent);
> +	ll_pthread_rwlock_unlock(&locks_rwlock);
> +	if (*node) {
> +		return rb_entry(*node, struct lock_lookup, node);
> +	}
> +
> +	/* We didn't find the lock, let's create it */
> +	l = malloc(sizeof(*l));
> +	if (l == NULL)
> +		return NULL;
> +
> +	l->orig = lock;
> +	/*
> +	 * Currently the name of the lock is the ptr value of the pthread lock,
> +	 * while not optimal, it makes debugging a bit easier.
> +	 *
> +	 * TODO: Get the real name of the lock using libdwarf
> +	 */
> +	sprintf(l->name, "%p", lock);

+	lockdep_init_map(&l->dep_map, l->name, (void *)addr, 0);

> +
> +	ll_pthread_rwlock_wrlock(&locks_rwlock);
> +	/* This might have changed since the last time we fetched it */
> +	node = __get_lock_node(lock, &parent);
> +	rb_link_node(&l->node, parent, node);
> +	rb_insert_color(&l->node, &locks);
> +	ll_pthread_rwlock_unlock(&locks_rwlock);
> +
> +	return l;
> +}

> +int pthread_mutex_init(pthread_mutex_t *mutex,
> +			const pthread_mutexattr_t *attr)
> +{
> +	int r;

+ unsigned long addr = __RET_IP_;

> +
> +	/*
> +	 * We keep trying to init our preload module because there might be
> +	 * code in init sections that tries to touch locks before we are
> +	 * initialized, in that case we'll need to manually call preload
> +	 * to get us going.
> +	 *
> +	 * Funny enough, kernel's lockdep had the same issue, and used
> +	 * (almost) the same solution. See look_up_lock_class() in
> +	 * kernel/lockdep.c for details.
> +	 */
> +	try_init_preload();
> +
> +	r = ll_pthread_mutex_init(mutex, attr);
> +	if (r == 0)
> +		/*
> +		 * We do a dummy initialization here so that lockdep could
> +		 * warn us if something fishy is going on - such as
> +		 * initializing a held lock.
> +		 */
+		__get_lock(mutex, addr);
> +
> +	return r;
> +}
> +
> +int pthread_mutex_lock(pthread_mutex_t *mutex)
> +{
> +	int r;

+ struct lock_lookup *lock = __get_lock(mutex, (unsigned long)mutex);

> +
> +	try_init_preload();
> +
+	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL,
> +			(unsigned long)_THIS_IP_);
> +	/*
> +	 * Here's the thing with pthread mutexes: unlike the kernel variant,
> +	 * they can fail.
> +	 *
> +	 * This means that the behaviour here is a bit different from what's
> +	 * going on in the kernel: there we just tell lockdep that we took the
> +	 * lock before actually taking it, but here we must deal with the case
> +	 * that locking failed.
> +	 *
> +	 * To do that we'll "release" the lock if locking failed - this way
> +	 * we'll get lockdep doing the correct checks when we try to take
> +	 * the lock, and if that fails - we'll be back to the correct
> +	 * state by releasing it.
> +	 */
> +	r = ll_pthread_mutex_lock(mutex);
> +	if (r)
+		lock_release(&lock->dep_map, 0, (unsigned long)_THIS_IP_);
> +
> +	return r;
> +}

Should get classes working. It will use the return address of pthread_*_init()
for key; thus all locks initialized from the same pthread_*_init() site will
end up belonging to the same class.

Failing that, the pthread_mutex_*() functions will initialize the lock using
the 'static' address of the mutex itself -- assuming its been initialized using
PTHREAD_MUTEX_INITIALIZER or similar.



