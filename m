Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3EVJWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:22:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38093 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3EVJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:22:39 -0400
Date: Wed, 22 May 2013 11:22:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/9] liblockdep: Add public headers for
 pthread_mutex_t implementation
Message-ID: <20130522092232.GF18810@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-4-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368674141-10796-4-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:15:35PM -0400, Sasha Levin wrote:
> These headers provide the same API as their pthread mutex
> counterparts.
> 
> The design here is to allow to easily switch to liblockdep lock
> validation just by adding a "liblockdep_" to pthread_mutex_*()
> calls, which means that it's easy to integrate liblockdep into
> existing codebases.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  tools/lib/lockdep/include/liblockdep/common.h | 42 ++++++++++++++++
>  tools/lib/lockdep/include/liblockdep/mutex.h  | 70 +++++++++++++++++++++++++++
>  2 files changed, 112 insertions(+)
>  create mode 100644 tools/lib/lockdep/include/liblockdep/common.h
>  create mode 100644 tools/lib/lockdep/include/liblockdep/mutex.h
> 
> diff --git a/tools/lib/lockdep/include/liblockdep/common.h b/tools/lib/lockdep/include/liblockdep/common.h
> new file mode 100644
> index 0000000..1113cad
> --- /dev/null
> +++ b/tools/lib/lockdep/include/liblockdep/common.h
> @@ -0,0 +1,42 @@
> +#ifndef _LIBLOCKDEP_COMMON_H
> +#define _LIBLOCKDEP_COMMON_H
> +
> +#include <pthread.h>
> +
> +#ifndef _THIS_IP_

#ifndef _RET_IP_ ?

> +#define _RET_IP_ (unsigned long)__builtin_return_address(0)
> +#endif
> +
> +#define NR_LOCKDEP_CACHING_CLASSES 2
> +#define MAX_LOCKDEP_SUBCLASSES 8UL
> +
> +struct lockdep_subclass_key {
> +	char __one_byte;
> +};
> +
> +struct lock_class_key {
> +	struct lockdep_subclass_key subkeys[MAX_LOCKDEP_SUBCLASSES];
> +};
> +
> +struct lockdep_map {
> +	struct lock_class_key	*key;
> +	struct lock_class	*class_cache[NR_LOCKDEP_CACHING_CLASSES];
> +	const char		*name;
> +#ifdef CONFIG_LOCK_STAT
> +	int			cpu;
> +	unsigned long		ip;
> +#endif
> +};
> +
> +void lockdep_init_map(struct lockdep_map *lock, const char *name,
> +			struct lock_class_key *key, int subclass);
> +void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> +			int trylock, int read, int check,
> +			struct lockdep_map *nest_lock, unsigned long ip);
> +void lock_release(struct lockdep_map *lock, int nested,
> +			unsigned long ip);
> +
> +#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
> +	{ .name = (_name), .key = (void *)(_key), }
> +
> +#endif
> diff --git a/tools/lib/lockdep/include/liblockdep/mutex.h b/tools/lib/lockdep/include/liblockdep/mutex.h
> new file mode 100644
> index 0000000..c342f70
> --- /dev/null
> +++ b/tools/lib/lockdep/include/liblockdep/mutex.h
> @@ -0,0 +1,70 @@
> +#ifndef _LIBLOCKDEP_MUTEX_H
> +#define _LIBLOCKDEP_MUTEX_H
> +
> +#include <pthread.h>
> +#include "common.h"
> +
> +struct liblockdep_pthread_mutex {
> +	pthread_mutex_t mutex;
> +	struct lockdep_map dep_map;
> +};
> +
> +typedef struct liblockdep_pthread_mutex liblockdep_pthread_mutex_t;
> +
> +#define LIBLOCKDEP_PTHREAD_MUTEX_INITIALIZER(mtx)			\
> +		(const struct liblockdep_pthread_mutex) {		\
> +	.mutex = PTHREAD_MUTEX_INITIALIZER,				\
> +	.dep_map = STATIC_LOCKDEP_MAP_INIT(#mtx, &((&(mtx))->dep_map)),	\
> +}
> +
> +static inline int __mutex_init(liblockdep_pthread_mutex_t *lock,
> +				const char *name,
> +				struct lock_class_key *key,
> +				const pthread_mutexattr_t *__mutexattr)
> +{
> +	lockdep_init_map(&lock->dep_map, name, key, 0);
> +	return pthread_mutex_init(&lock->mutex, __mutexattr);
> +}
> +
> +#define liblockdep_pthread_mutex_init(mutex, mutexattr)		\
> +({								\
> +	static struct lock_class_key __key;			\
> +								\
> +	__mutex_init((mutex), #mutex, &__key, (mutexattr));	\
> +})

OK, so people using liblockdep_pthread_mutex_init() do get the 'normal'
class rules.

> +
> +static inline int liblockdep_pthread_mutex_lock(liblockdep_pthread_mutex_t *lock)
> +{
> +	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
> +	return pthread_mutex_lock(&lock->mutex);
> +}

They will however then also want all the 'normal' lockdep annotations to
deal with that like:

liblockdep_pthread_mutex_lock_nested()
liblockdep_pthread_mutex_lock_nest_lock()

*phew* and here I always though pthread_mutex_* was a long prefix...

Also, the above doesn't have the full lockstat contention hooks -- not
sure that's on purpose or not.

> +
> +static inline int liblockdep_pthread_mutex_unlock(liblockdep_pthread_mutex_t *lock)
> +{
> +	lock_release(&lock->dep_map, 0, (unsigned long)_RET_IP_);
> +	return pthread_mutex_unlock(&lock->mutex);
> +}
> +
> +static inline int liblockdep_pthread_mutex_trylock(liblockdep_pthread_mutex_t *lock)
> +{
> +	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
> +	return pthread_mutex_trylock(&lock->mutex) == 0 ? 1 : 0;
> +}
> +
> +static inline int liblockdep_pthread_mutex_destroy(liblockdep_pthread_mutex_t *lock)
> +{
> +	return pthread_mutex_destroy(&lock->mutex);
> +}
> +
> +#ifdef __USE_LIBLOCKDEP
> +
> +#define pthread_mutex_t         liblockdep_pthread_mutex_t
> +#define pthread_mutex_init      liblockdep_pthread_mutex_init
> +#define pthread_mutex_lock      liblockdep_pthread_mutex_lock
> +#define pthread_mutex_unlock    liblockdep_pthread_mutex_unlock
> +#define pthread_mutex_trylock   liblockdep_pthread_mutex_trylock
> +#define pthread_mutex_destroy   liblockdep_pthread_mutex_destroy

Given the liblockdep_* things use 'proper' classes do you want this
mapping? If you do, should we use the same alias nonsense glibc uses or
are CPP macros good enough for us?
