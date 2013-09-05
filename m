Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935515Ab3IECf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:35:59 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:31486 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761658Ab3IECf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:35:56 -0400
Message-ID: <5227EDFC.2010403@hp.com>
Date: Wed, 04 Sep 2013 22:35:40 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
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
References: <5220F090.5050908@hp.com> <20130830194059.GC13318@ZenIV.linux.org.uk> <5220F811.9060902@hp.com> <20130830202608.GD13318@ZenIV.linux.org.uk> <52210225.60805@hp.com> <20130830204852.GE13318@ZenIV.linux.org.uk> <52214EBC.90100@hp.com> <20130831023516.GI13318@ZenIV.linux.org.uk> <20130831024233.GJ13318@ZenIV.linux.org.uk> <5224E647.80303@hp.com> <20130903060130.GD16261@gmail.com> <5225FCEE.7030901@hp.com> <CA+55aFyNmLt9GeR5XyxOs7aGLwH3EBCB+K9D6uGBef3FziP2-A@mail.gmail.com> <CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com> <52274943.1040005@hp.com> <CA+55aFyY-KEvqYze56Vw4wiznEBaxjRqHFT6aVxbu_U3k66BdQ@mail.gmail.com> <5227892B.7030906@hp.com> <CA+55aFy9hywXPhAu8JVSW=a4=2ctFTvQttf+x06mo3f6_4-g3w@mail.gmail.com>
In-Reply-To: <CA+55aFy9hywXPhAu8JVSW=a4=2ctFTvQttf+x06mo3f6_4-g3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 05:34 PM, Linus Torvalds wrote:
> On Wed, Sep 4, 2013 at 12:25 PM, Waiman Long<waiman.long@hp.com>  wrote:
>> Yes, the perf profile was taking from an 80-core machine. There isn't any
>> scalability issue hiding for the short workload on an 80-core machine.
>>
>> However, I am certain that more may pop up when running in an even larger
>> machine like the prototype 240-core machine that our team has been testing
>> on.
> Sure. Please let us know, I think it's going to be interesting to see
> what that shows.
>
> SGI certainly did much larger machines, but their primary target
> tended to be all user space, so they had things like "tons of
> concurrent page faults in the same process" rather than filename
> lookup or the tty layer.
>
>                  Linus

I think SGI is more focus on compute-intensive workload. HP is more 
focus on high-end commercial workload like SAP HANA. Below was a sample 
perf profile of the high-systime workload on a 240-core prototype 
machine (HT off) with 3.10-rc1 kernel with my lockref and seqlock patches:

      9.61%    3382925          swapper  [kernel.kallsyms]         [k] 
_raw_spin_lock
                        |--59.90%-- rcu_process_callbacks
                        |--19.41%-- load_balance
                        |--9.58%-- rcu_accelerate_cbs
                        |--6.70%-- tick_do_update_jiffies64
                        |--1.46%-- scheduler_tick
                        |--1.17%-- sched_rt_period_timer
                        |--0.56%-- perf_adjust_freq_unthr_context
                         --1.21%-- [...]

      6.34%         99            reaim  [kernel.kallsyms]         [k] 
_raw_spin_lock
                          |--73.96%-- load_balance
                          |--11.98%-- rcu_process_callbacks
                          |--2.21%-- __mutex_lock_slowpath
                          |--2.02%-- rcu_accelerate_cbs
                          |--1.95%-- wake_up_new_task
                          |--1.70%-- scheduler_tick
                          |--1.67%-- xfs_alloc_log_agf
                          |--1.24%-- task_rq_lock
                          |--1.15%-- try_to_wake_up
                           --2.12%-- [...]

      5.39%          2            reaim  [kernel.kallsyms]         [k] 
_raw_spin_lock_irqsave
                          |--95.08%-- rwsem_wake
                          |--1.80%-- rcu_process_callbacks
                          |--1.03%-- prepare_to_wait
                          |--0.59%-- __wake_up
                           --1.50%-- [...]

      2.28%          1            reaim  [kernel.kallsyms]         [k] 
_raw_spin_lock_irq
                          |--90.56%-- rwsem_down_write_failed
                          |--9.25%-- __schedule
                           --0.19%-- [...]

Longman
