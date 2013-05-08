Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3EHKXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:23:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46589
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190Ab3EHKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:23:53 -0400
Date: Wed, 8 May 2013 12:22:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130508102220.GB6131@dyad.programming.kicks-ass.net>
References: <1367348080-4680-1-git-send-email-sasha.levin@oracle.com>
 <1367348080-4680-8-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367348080-4680-8-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:54:38PM -0400, Sasha Levin wrote:
> +
> +static struct rb_node **__get_lock_node(void *lock, struct rb_node **parent)
> +{

> +}
> +
> +/**
> + * __get_lock - find or create a lock instance
> + * @lock: pointer to a pthread lock function
> + *
> + * Try to find an existing lock in the rbtree using the provided pointer. If
> + * one wasn't found - create it.
> + */
> +static struct lock_lookup *__get_lock(void *lock)
> +{

> +}

This needs something like:

static void __del_lock(void *lock);

Since now you're repeating yourself in pthread_{rwlock,mutex}_destroy() :-)

> +int pthread_mutex_lock(pthread_mutex_t *mutex)
> +{
> +	int r;
> +
> +        try_init_preload();

You seem consistently whitespace challenged on this line.

> +
> +	lock_acquire(&__get_lock(mutex)->dep_map, 0, 0, 0, 2, NULL,
> +			(unsigned long)_THIS_IP_);
> +	/*
> +	 * Here's the thing with pthread mutexes: unlike the kernel variant,
> +	 * they can fail.
> +	 *
> +	 * This means that the behaviour here is a bit different from what's
> +	 * going on in the kernel: there we just tell lockdep that we took the
> +	 * lock before actually taking it, but here we must deal with the case
> +	 * that locking failed.

mutex_lock_{interruptible,killable}() could be argued to be able to fail too.
And if you look at __mutex_lock_common() you'll see that it does the exact same
thing -- that is release on fail.

> +	 * To do that we'll "release" the lock if locking failed - this way
> +	 * we'll get lockdep doing the correct checks when we try to take
> +	 * the lock, and if that fails - we'll be back to the correct
> +	 * state by releasing it.
> +	 */
> +	r = ll_pthread_mutex_lock(mutex);
> +	if (r)
> +		lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)_THIS_IP_);
> +
> +	return r;
> +}
> +
> +int pthread_mutex_trylock(pthread_mutex_t *mutex)
> +{
> +	int r;
> +
> +        try_init_preload();

See..

> +	lock_acquire(&__get_lock(mutex)->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_THIS_IP_);
> +	r = ll_pthread_mutex_trylock(mutex);
> +	if (r)
> +		lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)_THIS_IP_);
> +
> +	return r;
> +}

> +__attribute__((constructor)) static void init_preload(void)
> +{
> +	static bool preload_started;
> +
> +	if (preload_done)
> +		return;
> +
> +	/*
> +	 * Some programs attempt to initialize and use locks in their
> +	 * allocation path. This means that a call to malloc() would
> +	 * result in locks being initialized and locked.
> +	 *
> +	 * Why is it an issue for us? dlsym() below will try allocating to
> +	 * give us the original function. Since this allocation will result
> +	 * in a locking operations, we have to let pthread deal with it,
> +	 * but we can't! we don't have the pointer to the original API
> +	 * since we're inside dlsym() trying to get it :(
> +	 *
> +	 * We can work around it by telling the program that locking was
> +	 * really okay, and just initialize those locks when we're fully
> +	 * up and running (this is ok because this all happens during
> +	 * initialization phase, when we have just one thread). But
> +	 * this is a big TODO at this point.
> +	 */

Fun.. got any example programs that trigger this?

> +	if (preload_started) {
> +		printf(
> +		"LOCKDEP error: It seems that the program you are trying to "
> +		"debug is initializing locks in it's allocation path.\n"
> +		"This means that liblockdep cannot reliably analyze this "
> +		"program since we need the allocator to work before we can "
> +		"debug locks.\nSorry!\n");
> +
> +		exit(1);
> +	}
> +
> +	preload_started = true;
> +
> +	ll_pthread_mutex_init = dlsym(RTLD_NEXT, "pthread_mutex_init");
> +	ll_pthread_mutex_lock = dlsym(RTLD_NEXT, "pthread_mutex_lock");
> +	ll_pthread_mutex_trylock = dlsym(RTLD_NEXT, "pthread_mutex_trylock");
> +	ll_pthread_mutex_unlock = dlsym(RTLD_NEXT, "pthread_mutex_unlock");
> +	ll_pthread_mutex_destroy = dlsym(RTLD_NEXT, "pthread_mutex_destroy");
> +
> +	ll_pthread_rwlock_init = dlsym(RTLD_NEXT, "pthread_rwlock_init");
> +	ll_pthread_rwlock_destroy = dlsym(RTLD_NEXT, "pthread_rwlock_destroy");
> +	ll_pthread_rwlock_rdlock = dlsym(RTLD_NEXT, "pthread_rwlock_rdlock");
> +	ll_pthread_rwlock_tryrdlock = dlsym(RTLD_NEXT, "pthread_rwlock_tryrdlock");
> +	ll_pthread_rwlock_wrlock = dlsym(RTLD_NEXT, "pthread_rwlock_wrlock");
> +	ll_pthread_rwlock_trywrlock = dlsym(RTLD_NEXT, "pthread_rwlock_trywrlock");
> +	ll_pthread_rwlock_unlock = dlsym(RTLD_NEXT, "pthread_rwlock_unlock");
> +
> +	lockdep_init();
> +
> +	preload_done = true;
> +}
