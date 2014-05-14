Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaENJxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:53:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:41432 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaENJxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:53:37 -0400
Date: Wed, 14 May 2014 11:53:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Carlos O'Donell" <carlos@redhat.com>
cc: Darren Hart <dvhart@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
In-Reply-To: <537313FD.4000306@redhat.com>
Message-ID: <alpine.DEB.2.02.1405141034320.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <537313FD.4000306@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Carlos O'Donell wrote:
> I agree. Something is wrong. There are *few* cases where we might probe the
> kernel to test for things, but you'd only see that failed futex syscall once.
> If this is repeating for each call to pthread_mutex_lock, then I would appreciate
> a test case I could use to debug this and then stick into the regression tests
> for glibc.

That happens if user space corrupts the lock->data. Here you go:

#define _GNU_SOURCE
#include <pthread.h>
#include <unistd.h>
#include <stdint.h>
#include <stdio.h>

#include <sys/syscall.h>

#define gettid() syscall(__NR_gettid)

static pthread_mutex_t m1;

static void *fn1(void *d)
{
	pthread_mutex_lock(&m1);
	sleep(60);
	return NULL;
}

static void *fn2(void *d)
{
	uint32_t *p = (uint32_t *) &m1;

	*p = (uint32_t) 0x80000000 | gettid();
	sleep(60);
	return NULL;
}

int main(void)
{
	pthread_mutexattr_t ma;
	pthread_t t1, t2;
	uint32_t *p;
	int ret;

	pthread_mutexattr_init(&ma);
	pthread_mutexattr_setprotocol(&ma, PTHREAD_PRIO_INHERIT);
	pthread_mutex_init(&m1, &ma);

	p = (uint32_t *) &m1;
	*p = (uint32_t) gettid();

	pthread_create(&t1, NULL, fn1, NULL);
	sleep(1);
	pthread_create(&t2, NULL, fn2, NULL);
	sleep(1);

	ret = pthread_mutex_lock(&m1);
	printf("ret %d %08x\n", ret, *p);
	return 0;
}

# strace ./fail
...
futex(0x600e20, FUTEX_LOCK_PI_PRIVATE, 1) = -1 EINVAL (Invalid argument)
...

# ./fail
ret 0 80002991

And note, you cannot detect the inconsistency of this in user
space. Simply because in case of PI futexes the kernel manipulates the
user space value and you have no idea what's going on in paralell.

So you need to handle the return value from the kernel proper. Whether
you assert or return -EINVAL to the caller is a different story, but
returning 0 is horribly wrong.

I prefer EINVAL as this matches the spec in the widest sense:

The pthread_mutex_lock(), pthread_mutex_trylock() and
pthread_mutex_unlock() functions may fail if:

  [EINVAL]
    The value specified by mutex does not refer to an initialised mutex object. 

And a wreckaged mutex is not a proper initialized one.

> > IIRC, glibc takes the approach that if this operation fails, there is no way for
> > it to recovery "properly", and so it chooses to:
> > 
> > 	/* Delay the thread indefinitely. */
> > 
> > I believe the thinking goes that if we get to here, then the lock is in an
> > inconsistent state (between kernel and userspace). I don't have an answer for
> > why pausing forever would be preferable to returning an error however...
> 
> What error would we return?
>
> This particular case is a serious error for which we have no good error code
> to return to userspace. It's an implementation defect, a bug, we should probably
> assert instead of pausing.

Errm.

http://pubs.opengroup.org/onlinepubs/7908799/xsh/pthread_mutex_lock.html

 The pthread_mutex_lock() function may fail if:

  [EDEADLK]
    The current thread already owns the mutex. 

That's a exactly the error code, which the kernel returns when it
detects a deadlock. 

And glibc returns EDEADLK at a lot of places already. So in that case
it's not a serious error? Because it's detected by glibc. You can't be
serious about that.

So why is a kernel detected deadlock different? Because it detects not
only AA, it detects ABBA and more. But it's still a dead lock. And
while posix spec only talks about AA, it's the very same issue.

So why not propagate this to the caller so he gets an alert right away
instead of letting him attach a debugger, and scratch his head and
lookup glibc source to find out why the hell glibc called pause.

Thanks,

	tglx
