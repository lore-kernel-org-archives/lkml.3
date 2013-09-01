Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3IAPpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 11:45:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54665 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab3IAPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:45:06 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
	<CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
Date: Sun, 1 Sep 2013 17:45:03 +0200
Message-ID: <CA+icZUWPUDorK+9KRD-H3FpbDeC_7LMatzrYk35jZk13vNuLBQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 1, 2013 at 5:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Sep 1, 2013 at 3:01 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> Looks like this is now 10x faster: ~2.66Mloops (debug) VS.
>> ~26.60Mloops (no-debug).
>
> Ok, that's getting to be in the right ballpark.
>
> But your profile is still odd.
>
>> Samples: 159K of event 'cycles:pp', Event count (approx.): 76968896763
>>  12,79%  t_lockref_from-  [kernel.kallsyms]     [k] irq_return
>>   4,36%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_lock
>
> If you do the profile with "-g", what are the top callers of this? You
> shouldn't see any spinlock load from the path lookup, but you have all
> these other things going on..
>

$ sudo ~/src/linux-kernel/linux/tools/perf/perf record -g -e cycles:pp
./scripts/t_lockref_from-linus
Total loops: 26205085
[ perf record: Woken up 77 times to write data ]
[ perf record: Captured and wrote 19.778 MB perf.data (~864092 samples) ]


$ sudo ~/src/linux-kernel/linux/tools/perf/perf report <--- I used
here with -f option, the last one, dropped here.

Samples: 160K of event 'cycles:pp', Event count (approx.): 77003901089
+  12,46%  t_lockref_from-  [kernel.kallsyms]     [k] irq_return
+   4,86%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_get_or_lock
+   4,42%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_lock
+   4,28%  t_lockref_from-  [kernel.kallsyms]     [k] __acct_update_integrals
+   3,97%  t_lockref_from-  [kernel.kallsyms]     [k] user_exit
+   3,04%  t_lockref_from-  [kernel.kallsyms]     [k] local_clock
+   2,71%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_alloc
+   2,50%  t_lockref_from-  [kernel.kallsyms]     [k] link_path_walk
+   2,46%  t_lockref_from-  libc-2.15.so          [.] __xstat64
+   2,38%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_free
+   1,96%  t_lockref_from-  [kernel.kallsyms]     [k] path_lookupat
+   1,88%  t_lockref_from-  [kernel.kallsyms]     [k] __d_lookup_rcu
+   1,87%  t_lockref_from-  [kernel.kallsyms]     [k] tracesys
+   1,84%  t_lockref_from-  [kernel.kallsyms]     [k]
rcu_eqs_exit_common.isra.43
+   1,81%  t_lockref_from-  [kernel.kallsyms]     [k]
rcu_eqs_enter_common.isra.45
+   1,80%  t_lockref_from-  [kernel.kallsyms]     [k] user_enter
+   1,79%  t_lockref_from-  [kernel.kallsyms]     [k] sched_clock_cpu
+   1,61%  t_lockref_from-  [kernel.kallsyms]     [k] native_read_tsc
+   1,56%  t_lockref_from-  [kernel.kallsyms]     [k] cp_new_stat
+   1,52%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_put_or_lock
+   1,51%  t_lockref_from-  [kernel.kallsyms]     [k] account_system_time
+   1,46%  t_lockref_from-  [kernel.kallsyms]     [k] path_init
+   1,46%  t_lockref_from-  [kernel.kallsyms]     [k] copy_user_generic_unrolled
+   1,42%  t_lockref_from-  [kernel.kallsyms]     [k] syscall_trace_enter
+   1,38%  t_lockref_from-  [kernel.kallsyms]     [k] jiffies_to_timeval
+   1,32%  t_lockref_from-  [kernel.kallsyms]     [k] lookup_fast
+   1,31%  t_lockref_from-  [kernel.kallsyms]     [k] native_sched_clock
+   1,24%  t_lockref_from-  [kernel.kallsyms]     [k] getname_flags
+   1,17%  t_lockref_from-  [kernel.kallsyms]     [k] vfs_getattr
+   1,15%  t_lockref_from-  [kernel.kallsyms]     [k] get_vtime_delta
+   1,03%  t_lockref_from-  [kernel.kallsyms]     [k] syscall_trace_leave
+   0,95%  t_lockref_from-  [kernel.kallsyms]     [k] generic_fillattr
+   0,94%  t_lockref_from-  [kernel.kallsyms]     [k] user_path_at_empty
+   0,93%  t_lockref_from-  [kernel.kallsyms]     [k] system_call_after_swapgs
+   0,93%  t_lockref_from-  [kernel.kallsyms]     [k] account_user_time
+   0,89%  t_lockref_from-  [kernel.kallsyms]     [k] strncpy_from_user
+   0,86%  t_lockref_from-  [kernel.kallsyms]     [k] complete_walk
+   0,80%  t_lockref_from-  [kernel.kallsyms]     [k] filename_lookup
+   0,80%  t_lockref_from-  [kernel.kallsyms]     [k] vfs_fstatat
+   0,78%  t_lockref_from-  [kernel.kallsyms]     [k] generic_permission
+   0,77%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_unlock
+   0,73%  t_lockref_from-  [kernel.kallsyms]     [k] __inode_permission
+   0,69%  t_lockref_from-  [kernel.kallsyms]     [k] vtime_account_user
+   0,66%  t_lockref_from-  [kernel.kallsyms]     [k] d_rcu_to_refcount
+   0,61%  t_lockref_from-  [kernel.kallsyms]     [k] common_perm
+   0,60%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_enter
+   0,59%  t_lockref_from-  [kernel.kallsyms]     [k] dput
+   0,54%  t_lockref_from-  [kernel.kallsyms]     [k] vtime_user_enter
+   0,51%  t_lockref_from-  [kernel.kallsyms]     [k] cpuacct_account_field
+   0,50%  t_lockref_from-  [kernel.kallsyms]     [k] mntput
+   0,48%  t_lockref_from-  [kernel.kallsyms]     [k] lg_local_lock
+   0,48%  t_lockref_from-  [kernel.kallsyms]     [k] apparmor_inode_getattr
+   0,45%  t_lockref_from-  t_lockref_from-linus  [.] start_routine
+   0,45%  t_lockref_from-  [kernel.kallsyms]     [k] __vtime_account_system
Press '?' for help on key bindings

- Sedat -

>>   4,36%  t_lockref_from-  [kernel.kallsyms]     [k] __acct_update_integrals
>>   4,07%  t_lockref_from-  [kernel.kallsyms]     [k] user_exit
>>   3,12%  t_lockref_from-  [kernel.kallsyms]     [k] local_clock
>>   2,83%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_get_or_lock
>>   2,73%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_alloc
>>   2,62%  t_lockref_from-  [kernel.kallsyms]     [k] __d_lookup_rcu
>
> You're spending more time on the task stats than on the actual lookup.
> Maybe you should turn off CONFIG_TASKSTATS..But why that whole
> irq_return thing? Odd.
>

Yes, I have CONFIG_TASKSTATS=y.
I can try a -4 build w/o it.

- Sedat -
