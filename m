Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3EHN2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:28:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41562 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab3EHN2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:28:39 -0400
Message-ID: <518A52D2.4050505@oracle.com>
Date: Wed, 08 May 2013 09:27:46 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
References: <1367348080-4680-1-git-send-email-sasha.levin@oracle.com> <1367348080-4680-3-git-send-email-sasha.levin@oracle.com> <20130508100143.GA6131@dyad.programming.kicks-ass.net>
In-Reply-To: <20130508100143.GA6131@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 06:01 AM, Peter Zijlstra wrote:
> On Tue, Apr 30, 2013 at 02:54:33PM -0400, Sasha Levin wrote:
>> diff --git a/tools/lib/lockdep/common.c b/tools/lib/lockdep/common.c
>> new file mode 100644
>> index 0000000..eb5e481
>> --- /dev/null
>> +++ b/tools/lib/lockdep/common.c
>> @@ -0,0 +1,33 @@
>> +#include <stddef.h>
>> +#include <stdbool.h>
>> +#include <linux/compiler.h>
>> +#include <linux/lockdep.h>
>> +#include <unistd.h>
>> +#include <sys/syscall.h>
>> +
>> +static struct task_struct current_obj;
>> +
>> +/* lockdep wants these */
>> +bool debug_locks = true;
>> +bool debug_locks_silent;
>> +
>> +__attribute__((constructor)) static void liblockdep_init(void)
>> +{
>> +	lockdep_init();
>> +}
>> +
>> +__attribute__((destructor)) static void liblockdep_exit(void)
>> +{
>> +	debug_check_no_locks_held(&current_obj);
>> +}
>> +
>> +struct task_struct *__curr(void)
>> +{
>> +	if (current_obj.pid == 0) {
>> +		/* Makes lockdep output pretty */
>> +		prctl(PR_GET_NAME, current_obj.comm);
>> +		current_obj.pid = syscall(__NR_gettid);
>> +	}
>> +
>> +	return &current_obj;
>> +}
> 
>> diff --git a/tools/lib/lockdep/uinclude/linux/lockdep.h b/tools/lib/lockdep/uinclude/linux/lockdep.h
>> new file mode 100644
>> index 0000000..8e9a5c4
>> --- /dev/null
>> +++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
>> @@ -0,0 +1,58 @@
>> +#ifndef _LIBLOCKDEP_LOCKDEP_H_
>> +#define _LIBLOCKDEP_LOCKDEP_H_
>> +
>> +#include <sys/prctl.h>
>> +#include <sys/syscall.h>
>> +#include <string.h>
>> +#include <limits.h>
>> +#include <linux/utsname.h>
>> +
>> +
>> +#define MAX_LOCK_DEPTH 2000UL
>> +
>> +#include "../../../include/linux/lockdep.h"
>> +
>> +struct task_struct {
>> +	u64 curr_chain_key;
>> +	int lockdep_depth;
>> +	unsigned int lockdep_recursion;
>> +	struct held_lock held_locks[MAX_LOCK_DEPTH];
>> +	gfp_t lockdep_reclaim_gfp;
>> +	int pid;
>> +	char comm[17];
>> +};
>> +
>> +extern struct task_struct *__curr(void);
>> +
>> +#define current (__curr())
>> +
>> +#define debug_locks_off() 1
>> +#define task_pid_nr(tsk) ((tsk)->pid)
>> +
>> +#define KSYM_NAME_LEN 128
>> +#define printk printf
>> +
>> +#define KERN_ERR
>> +#define KERN_CONT
>> +
>> +#define list_del_rcu list_del
>> +
>> +#define atomic_t unsigned long
>> +#define atomic_inc(x) ((*(x))++)
>> +
>> +static struct new_utsname *init_utsname(void)
>> +{
>> +	static struct new_utsname n = (struct new_utsname) {
>> +		.release = "liblockdep",
>> +		.version = LIBLOCKDEP_VERSION,
>> +	};
>> +
>> +	return &n;
>> +}
>> +
>> +#define print_tainted() ""
>> +#define static_obj(x) 1
>> +
>> +#define debug_show_all_locks()
>> +
>> +#endif
> 
> I don't see how this could possible work for threaded programs; you only have a
> single task_struct instance. Wouldn't you need something like the below?

[snip]

Hi Peter,

You're right - I broke multithreading for some odd reason (mostly me being stupid)
after having it working :/

It's enough to set the __thread flag on current_obj:

	diff --git a/tools/lib/lockdep/common.c b/tools/lib/lockdep/common.c
	index eb5e481..8ef602f 100644
	--- a/tools/lib/lockdep/common.c
	+++ b/tools/lib/lockdep/common.c
	@@ -5,7 +5,7 @@
	 #include <unistd.h>
	 #include <sys/syscall.h>
	
	-static struct task_struct current_obj;
	+static __thread struct task_struct current_obj;
	
	 /* lockdep wants these */
	 bool debug_locks = true;

Since we don't need any special initialization of the struct at any point. This
means that the patch above is enough and we don't need to hook pthread_create.

I've tested it by adding the following test to the tests dir:

	#include <pthread.h>

	#include <liblockdep/mutex.h>
	#include "common.h"

	pthread_mutex_t a, b;

	static void *thread_a(void *arg)
	{
	        LOCK_UNLOCK_2(a, b);

	        return NULL;
	}

	static void *thread_b(void *arg)
	{
	        LOCK_UNLOCK_2(b, a);

	        return NULL;
	}

	void main(void)
	{
	        pthread_t ta, tb;

	        pthread_mutex_init(&a, NULL);
	        pthread_mutex_init(&b, NULL);

	        pthread_create(&ta, NULL, thread_a, NULL);
	        pthread_create(&tb, NULL, thread_b, NULL);

	        pthread_join(ta, NULL);
	        pthread_join(tb, NULL);
	}

Which, as expected, produced the following spew:

======================================================
[ INFO: possible circular locking dependency detected ]
liblockdep 0.0.1
-------------------------------------------------------
ABBA_MT/30105 is trying to acquire lock:
 (&a){......}, at: /lib64/libpthread.so.0(+0x8f3b) [0x7ffa7d2f1f3b]

but task is already holding lock:
 (&b){......}, at: /lib64/libpthread.so.0(+0x8f3b) [0x7ffa7d2f1f3b]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&b){......}:
tests/ABBA_MT[0x4017e4]
tests/ABBA_MT[0x403381]
tests/ABBA_MT[0x40361b]
tests/ABBA_MT[0x403cb1]
tests/ABBA_MT[0x40476e]
tests/ABBA_MT[0x40522d]
tests/ABBA_MT[0x4012d2]
/lib64/libpthread.so.0(+0x8f3b)[0x7ffa7d2f1f3b]
/lib64/libc.so.6(clone+0x6d)[0x7ffa7d02d26d]

-> #0 (&a){......}:
tests/ABBA_MT[0x4017e4]
tests/ABBA_MT[0x402c95]
tests/ABBA_MT[0x403267]
tests/ABBA_MT[0x40361b]
tests/ABBA_MT[0x403cb1]
tests/ABBA_MT[0x40476e]
tests/ABBA_MT[0x40522d]
tests/ABBA_MT[0x401372]
/lib64/libpthread.so.0(+0x8f3b)[0x7ffa7d2f1f3b]
/lib64/libc.so.6(clone+0x6d)[0x7ffa7d02d26d]

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&b);
                               lock(&a);
                               lock(&b);
  lock(&a);

 *** DEADLOCK ***

1 lock held by ABBA_MT/30105:
 #0:  (&b){......}, at: /lib64/libpthread.so.0(+0x8f3b) [0x7ffa7d2f1f3b]

stack backtrace:
tests/ABBA_MT[0x401518]
tests/ABBA_MT[0x402d4f]
tests/ABBA_MT[0x403267]
tests/ABBA_MT[0x40361b]
tests/ABBA_MT[0x403cb1]
tests/ABBA_MT[0x40476e]
tests/ABBA_MT[0x40522d]
tests/ABBA_MT[0x401372]
/lib64/libpthread.so.0(+0x8f3b)[0x7ffa7d2f1f3b]
/lib64/libc.so.6(clone+0x6d)[0x7ffa7d02d26d]


Thanks,
Sasha
