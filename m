Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3ICPPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:15:13 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:45822 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab3ICPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:15:12 -0400
Message-ID: <5225FCEE.7030901@hp.com>
Date: Tue, 03 Sep 2013 11:14:54 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
References: <5220F090.5050908@hp.com> <20130830194059.GC13318@ZenIV.linux.org.uk> <5220F811.9060902@hp.com> <20130830202608.GD13318@ZenIV.linux.org.uk> <52210225.60805@hp.com> <20130830204852.GE13318@ZenIV.linux.org.uk> <52214EBC.90100@hp.com> <20130831023516.GI13318@ZenIV.linux.org.uk> <20130831024233.GJ13318@ZenIV.linux.org.uk> <5224E647.80303@hp.com> <20130903060130.GD16261@gmail.com>
In-Reply-To: <20130903060130.GD16261@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 02:01 AM, Ingo Molnar wrote:
> * Waiman Long<waiman.long@hp.com>  wrote:
>
>> Yes, that patch worked. It eliminated the lglock as a bottleneck in 
>> the AIM7 workload. The lg_global_lock did not show up in the perf 
>> profile, whereas the lg_local_lock was only 0.07%. 
> Just curious: what's the worst bottleneck now in the optimized kernel? :-)
>
> Thanks,
>
> 	Ingo
With the following patches on v3.11:
1. Linus's version of lockref patch
2. Al's lglock patch
3. My preliminary patch to convert prepend_path under RCU

The perf profile of the kernel portion of the short workload in a 
80-core system became like this:

     29.87%     reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
                   |--50.00%-- tty_ldisc_deref
                   |--49.01%-- tty_ldisc_try
                    --0.99%-- [...]

      7.55%   swapper  [kernel.kallsyms]  [k] intel_idle
      1.03%     reaim  [kernel.kallsyms]  [k] copy_user_generic_string
      0.91%     reaim  [kernel.kallsyms]  [k] _raw_spin_lock
                   |--15.88%-- __rcu_process_callbacks
                   |--6.55%-- load_balance
                   |--6.02%-- sem_lock
                   |--4.77%-- enqueue_to_backlog
                   |--4.21%-- task_rq_lock
                   |--3.97%-- process_backlog
                   |--3.35%-- unix_dgram_sendmsg
                   |--3.28%-- kmem_cache_free
                   |--3.16%-- tcp_v4_rcv
                   |--2.77%-- unix_stream_sendmsg
                   |--2.36%-- rcu_accelerate_cbs
                   |--2.02%-- do_wp_page
                   |--2.02%-- unix_create1
                   |--1.83%-- unix_peer_get
                   |--1.67%-- udp_lib_get_port
                   |--1.66%-- unix_stream_recvmsg
                   |--1.63%-- handle_pte_fault
                   |--1.63%-- udp_queue_rcv_skb
                   |--1.54%-- unix_release_sock
                   |--1.48%-- try_to_wake_up
                   |--1.37%-- do_anonymous_page
                   |--1.37%-- new_inode_pseudo
                   |--1.33%-- __d_lookup
                   |--1.20%-- free_one_page
                   |--1.11%-- __do_fault
                   |--1.06%-- scheduler_tick
                   |--0.90%-- __drain_alien_cache
                   |--0.81%-- inet_csk_get_port
                   |--0.76%-- sock_alloc
                   |--0.76%-- shmem_lock
                   |--0.75%-- __d_instantiate
                   |--0.70%-- __inet_hash_connect
                   |--0.69%-- __inet_hash_nolisten
                   |--0.68%-- ip_local_deliver_finish
                   |--0.64%-- inet_hash
                   |--0.64%-- kfree
                   |--0.60%-- d_path
                   |--0.58%-- __close_fd
                   |--0.51%-- evict
                    --11.76%-- [...]

      0.51%     reaim  [ip_tables]        [k] ipt_do_table
      0.46%     reaim  [kernel.kallsyms]  [k] __alloc_skb
      0.38%     reaim  [kernel.kallsyms]  [k] kfree
      0.36%     reaim  [kernel.kallsyms]  [k] kmem_cache_free
      0.34%     reaim  [kernel.kallsyms]  [k] system_call_after_swapg
      0.32%     reaim  [kernel.kallsyms]  [k] fsnotify
      0.32%     reaim  [kernel.kallsyms]  [k] ip_finish_output
      0.27%     reaim  [kernel.kallsyms]  [k] system_call

Other than the global tty_ldisc_lock, there is no other major
bottleneck. I am not that worry about the tty_ldisc_lock bottleneck
as real world applications probably won't have that many calls to
set the tty driver.

Regards,
Longman

