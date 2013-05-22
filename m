Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3EVJ1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:27:19 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55358
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255Ab3EVJ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:27:17 -0400
Date: Wed, 22 May 2013 11:27:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130522092711.GI18810@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-8-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368674141-10796-8-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:15:39PM -0400, Sasha Levin wrote:
> +
> +/* pthread mutex API */
> +
> +#ifdef __GLIBC__
> +extern int __pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr);
> +extern int __pthread_mutex_lock(pthread_mutex_t *mutex);
> +extern int __pthread_mutex_trylock(pthread_mutex_t *mutex);
> +extern int __pthread_mutex_unlock(pthread_mutex_t *mutex);
> +extern int __pthread_mutex_destroy(pthread_mutex_t *mutex);
> +#else
> +#define __pthread_mutex_init	NULL
> +#define __pthread_mutex_lock	NULL
> +#define __pthread_mutex_trylock	NULL
> +#define __pthread_mutex_unlock	NULL
> +#define __pthread_mutex_destroy	NULL
> +#endif
> +static int (*ll_pthread_mutex_init)(pthread_mutex_t *mutex,
> +			const pthread_mutexattr_t *attr)	= __pthread_mutex_init;
> +static int (*ll_pthread_mutex_lock)(pthread_mutex_t *mutex)	= __pthread_mutex_lock;
> +static int (*ll_pthread_mutex_trylock)(pthread_mutex_t *mutex)	= __pthread_mutex_trylock;
> +static int (*ll_pthread_mutex_unlock)(pthread_mutex_t *mutex)	= __pthread_mutex_unlock;
> +static int (*ll_pthread_mutex_destroy)(pthread_mutex_t *mutex)	= __pthread_mutex_destroy;
> +
> +/* pthread rwlock API */
> +
> +#ifdef __GLIBC__
> +extern int __pthread_rwlock_init(pthread_rwlock_t *rwlock, const pthread_rwlockattr_t *attr);
> +extern int __pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
> +extern int __pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
> +extern int __pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
> +extern int __pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
> +extern int __pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
> +extern int __pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
> +#else
> +#define __pthread_rwlock_init		NULL
> +#define __pthread_rwlock_destroy	NULL
> +#define __pthread_rwlock_wrlock		NULL
> +#define __pthread_rwlock_trywrlock	NULL
> +#define __pthread_rwlock_rdlock		NULL
> +#define __pthread_rwlock_tryrdlock	NULL
> +#define __pthread_rwlock_unlock		NULL
> +#endif
> +
> +static int (*ll_pthread_rwlock_init)(pthread_rwlock_t *rwlock,
> +			const pthread_rwlockattr_t *attr)		= __pthread_rwlock_init;
> +static int (*ll_pthread_rwlock_destroy)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_destroy;
> +static int (*ll_pthread_rwlock_rdlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_rdlock;
> +static int (*ll_pthread_rwlock_tryrdlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_tryrdlock;
> +static int (*ll_pthread_rwlock_trywrlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_trywrlock;
> +static int (*ll_pthread_rwlock_wrlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_wrlock;
> +static int (*ll_pthread_rwlock_unlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_unlock;
> +

> +__attribute__((constructor)) static void init_preload(void)
> +{
> +	if (__init_state != done)
> +		return;
> +
> +#ifndef __GLIBC__
> +	__init_state = prepare;
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
> +#endif
> +
> +	printf("%p\n", ll_pthread_mutex_trylock);fflush(stdout);
> +
> +	lockdep_init();
> +
> +	__init_state = done;
> +}

I guess that begs the question do we really want to support !glibc?
