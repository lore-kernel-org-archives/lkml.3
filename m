Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab3H3TVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:21:09 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16519 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3H3TVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:21:04 -0400
Message-ID: <5220F090.5050908@hp.com>
Date: Fri, 30 Aug 2013 15:20:48 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
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
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com> <1375758759-29629-2-git-send-email-Waiman.Long@hp.com> <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com> <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com> <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com> <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com> <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com> <52200DAE.2020303@hp.com> <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com> <5220E56A.80603@hp.com> <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
In-Reply-To: <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 02:53 PM, Linus Torvalds wrote:
> So the perf data would be *much* more interesting for a more varied 
> load. I know pretty much exactly what happens with my silly 
> test-program, and as you can see it never really gets to the actual 
> spinlock, because that test program will only ever hit the fast-path 
> case. It would be much more interesting to see another load that may 
> trigger the d_lock actually being taken. So:
>> For the other test cases that I am interested in, like the AIM7 benchmark,
>> your patch may not be as good as my original one. I got 1-3M JPM (varied
>> quite a lot in different runs) in the short workloads on a 80-core system.
>> My original one got 6M JPM. However, the test was done on 3.10 based kernel.
>> So I need to do more test to see if that has an effect on the JPM results.
> I'd really like to see a perf profile of that, particularly with some
> call chain data for the relevant functions (ie "what it is that causes
> us to get to spinlocks"). Because it may well be that you're hitting
> some of the cases that I didn't see, and thus didn't notice.
>
> In particular, I suspect AIM7 actually creates/deletes files and/or
> renames them too. Or maybe I screwed up the dget_parent() special case
> thing, which mattered because AIM7 did a lot of getcwd() calls or
> someting odd like that.
>
>                  Linus

Below is the perf data of my short workloads run in an 80-core DL980:

     13.60%            reaim  [kernel.kallsyms]        [k] 
_raw_spin_lock_irqsave
                          |--48.79%-- tty_ldisc_try
                          |--48.58%-- tty_ldisc_deref
                           --2.63%-- [...]

     11.31%          swapper  [kernel.kallsyms]        [k] intel_idle
                        |--99.94%-- cpuidle_enter_state
                         --0.06%-- [...]

      4.86%            reaim  [kernel.kallsyms]        [k] lg_local_lock
                          |--59.41%-- mntput_no_expire
                          |--19.37%-- path_init
                          |--15.14%-- d_path
                          |--5.88%-- sys_getcwd
                           --0.21%-- [...]

      3.00%            reaim  reaim                    [.] mul_short

      2.41%            reaim  reaim                    [.] mul_long
                          |--87.21%-- 0xbc614e
                           --12.79%-- (nil)

      2.29%            reaim  reaim                    [.] mul_int

      2.20%            reaim  [kernel.kallsyms]        [k] _raw_spin_lock
                          |--12.81%-- prepend_path
                          |--9.90%-- lockref_put_or_lock
                          |--9.62%-- __rcu_process_callbacks
                          |--8.77%-- load_balance
                          |--6.40%-- lockref_get
                          |--5.55%-- __mutex_lock_slowpath
                          |--4.85%-- __mutex_unlock_slowpath
                          |--4.83%-- inet_twsk_schedule
                          |--4.27%-- lockref_get_or_lock
                          |--2.19%-- task_rq_lock
                          |--2.13%-- sem_lock
                          |--2.09%-- scheduler_tick
                          |--1.88%-- try_to_wake_up
                          |--1.53%-- kmem_cache_free
                          |--1.30%-- unix_create1
                          |--1.22%-- unix_release_sock
                          |--1.21%-- process_backlog
                          |--1.11%-- unix_stream_sendmsg
                          |--1.03%-- enqueue_to_backlog
                          |--0.85%-- rcu_accelerate_cbs
                          |--0.79%-- unix_dgram_sendmsg
                          |--0.76%-- do_anonymous_page
                          |--0.70%-- unix_stream_recvmsg
                          |--0.69%-- unix_stream_connect
                          |--0.64%-- net_rx_action
                          |--0.61%-- tcp_v4_rcv
                          |--0.59%-- __do_fault
                          |--0.54%-- new_inode_pseudo
                          |--0.52%-- __d_lookup
                           --10.62%-- [...]

      1.19%            reaim  [kernel.kallsyms]        [k] mspin_lock
                          |--99.82%-- __mutex_lock_slowpath
                           --0.18%-- [...]

      1.01%            reaim  [kernel.kallsyms]        [k] lg_global_lock
                          |--51.62%-- __shmdt
                           --48.38%-- __shmctl

There are more contention in the lglock than I remember for the run in 
3.10. This is an area that I need to look at. In fact, lglock is 
becoming a problem for really large machine with a lot of cores. We have 
a prototype 16-socket machine with 240 cores under development. The cost 
of doing a lg_global_lock will be very high in that type of machine 
given that it is already high in this 80-core machine. I have been 
thinking about instead of per-cpu spinlocks, we could change the locking 
to per-node level. While there will be more contention for 
lg_local_lock, the cost of doing a lg_global_lock will be much lower and 
contention within the local die should not be too bad. That will require 
either a per-node variable infrastructure or simulated with the existing 
per-cpu subsystem.

I will also need to look at ways reduce the need of taking d_lock in 
existing code. One area that I am looking at is whether we can take out 
the lock/unlock pair in prepend_path(). This function can only be called 
with the rename_lock taken. So no filename change or deletion will be 
allowed. It will only be a problem if somehow the dentry itself got 
killed or dropped while the name is being copied out. The first dentry 
referenced by the path structure should have a non-zero reference count, 
so that shouldn't happen. I am not so sure about the parents of that 
dentry as I am not so familiar with that part of the filesystem code.

Regards,
Longman
