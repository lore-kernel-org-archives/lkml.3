Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3EHKDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:03:19 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46459
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798Ab3EHKDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:03:17 -0400
Date: Wed, 8 May 2013 12:01:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130508100143.GA6131@dyad.programming.kicks-ass.net>
References: <1367348080-4680-1-git-send-email-sasha.levin@oracle.com>
 <1367348080-4680-3-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367348080-4680-3-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:54:33PM -0400, Sasha Levin wrote:
> diff --git a/tools/lib/lockdep/common.c b/tools/lib/lockdep/common.c
> new file mode 100644
> index 0000000..eb5e481
> --- /dev/null
> +++ b/tools/lib/lockdep/common.c
> @@ -0,0 +1,33 @@
> +#include <stddef.h>
> +#include <stdbool.h>
> +#include <linux/compiler.h>
> +#include <linux/lockdep.h>
> +#include <unistd.h>
> +#include <sys/syscall.h>
> +
> +static struct task_struct current_obj;
> +
> +/* lockdep wants these */
> +bool debug_locks = true;
> +bool debug_locks_silent;
> +
> +__attribute__((constructor)) static void liblockdep_init(void)
> +{
> +	lockdep_init();
> +}
> +
> +__attribute__((destructor)) static void liblockdep_exit(void)
> +{
> +	debug_check_no_locks_held(&current_obj);
> +}
> +
> +struct task_struct *__curr(void)
> +{
> +	if (current_obj.pid == 0) {
> +		/* Makes lockdep output pretty */
> +		prctl(PR_GET_NAME, current_obj.comm);
> +		current_obj.pid = syscall(__NR_gettid);
> +	}
> +
> +	return &current_obj;
> +}

> diff --git a/tools/lib/lockdep/uinclude/linux/lockdep.h b/tools/lib/lockdep/uinclude/linux/lockdep.h
> new file mode 100644
> index 0000000..8e9a5c4
> --- /dev/null
> +++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
> @@ -0,0 +1,58 @@
> +#ifndef _LIBLOCKDEP_LOCKDEP_H_
> +#define _LIBLOCKDEP_LOCKDEP_H_
> +
> +#include <sys/prctl.h>
> +#include <sys/syscall.h>
> +#include <string.h>
> +#include <limits.h>
> +#include <linux/utsname.h>
> +
> +
> +#define MAX_LOCK_DEPTH 2000UL
> +
> +#include "../../../include/linux/lockdep.h"
> +
> +struct task_struct {
> +	u64 curr_chain_key;
> +	int lockdep_depth;
> +	unsigned int lockdep_recursion;
> +	struct held_lock held_locks[MAX_LOCK_DEPTH];
> +	gfp_t lockdep_reclaim_gfp;
> +	int pid;
> +	char comm[17];
> +};
> +
> +extern struct task_struct *__curr(void);
> +
> +#define current (__curr())
> +
> +#define debug_locks_off() 1
> +#define task_pid_nr(tsk) ((tsk)->pid)
> +
> +#define KSYM_NAME_LEN 128
> +#define printk printf
> +
> +#define KERN_ERR
> +#define KERN_CONT
> +
> +#define list_del_rcu list_del
> +
> +#define atomic_t unsigned long
> +#define atomic_inc(x) ((*(x))++)
> +
> +static struct new_utsname *init_utsname(void)
> +{
> +	static struct new_utsname n = (struct new_utsname) {
> +		.release = "liblockdep",
> +		.version = LIBLOCKDEP_VERSION,
> +	};
> +
> +	return &n;
> +}
> +
> +#define print_tainted() ""
> +#define static_obj(x) 1
> +
> +#define debug_show_all_locks()
> +
> +#endif

I don't see how this could possible work for threaded programs; you only have a
single task_struct instance. Wouldn't you need something like the below?

---

static int (*pthread_create_orig)(pthread_t *__restrict,
		__const pthread_attr_t *__restrict,
		void *(*)(void *),
		void *__restrict) = NULL;


static __thread struct task_struct __current;

#define current (&__current)

static void sched_fork(void)
{
	/* init __current */
}

__attribute__((constructor)) static void sched_init(void) 
{
	pthread_create_orig = dlsym(RTLD_NEXT, "pthread_create");
	if (!pthread_create_orig) {
		char *error = dlerror();
		if (!error)
			error = "pthread_create is NULL";
		die("%s\n", error);
	}

	sched_fork(); /* main thread */
}

__attribute__((destructor)) static void sched_exit(void)
{
	/* */
}

struct tramp_data {

	void *(*func)(void *);
	void *arg;

	pthread_mutex_t lock;
	pthread_cond_t  wait;
};

static void *tramp_func(void *data)
{
	struct tramp_data *tramp_data = data;
	void *(*func)(void *) = tramp_data->func;
	void *arg = tramp_data->arg;

	sched_fork();

	pthread_mutex_lock(&tramp_data->lock);
	pthread_cond_signal(&tramp_data->wait);
	pthread_mutex_unlock(&tramp_data->lock);

	return func(arg);
}

/* hijack pthread_create() */
int pthread_create(pthread_t *__restrict thread,
		__const pthread_attr_t *__restrict attr,
		void *(*func)(void *),
		void *__restrict arg)
{
	struct tramp_data tramp_data = {
		.func = func,
		.arg = arg,
	};
	int ret;

	pthread_cond_init(&tramp_data.wait, NULL);
	pthread_mutex_init(&tramp_data.lock, NULL);

	pthread_mutex_lock(&tramp_data.lock);

	ret = pthread_create_orig(thread, attr, &tramp_func, &tramp_data);
	if (!ret)
		pthread_cond_wait(&tramp_data.wait, &tramp_data.lock);

	pthread_mutex_unlock(&tramp_data.lock);

	pthread_mutex_destroy(&tramp_data.lock);
	pthread_cond_destroy(&tramp_data.wait);

	return ret;
} 

