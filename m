Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaIXDPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 23:15:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:1384 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaIXDPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 23:15:48 -0400
Message-ID: <54223758.4070300@huawei.com>
Date: Wed, 24 Sep 2014 11:15:36 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should
 be atomic flags
References: <542124D3.9000007@huawei.com> <54212509.1030809@huawei.com> <alpine.DEB.2.02.1409231508590.22630@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1409231508590.22630@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/9/24 6:10, David Rientjes wrote:
> On Tue, 23 Sep 2014, Zefan Li wrote:
> 
>> When we change cpuset.memory_spread_{page,slab}, cpuset will flip
>> PF_SPREAD_{PAGE,SLAB} bit of tsk->flags for each task in that cpuset.
>> This should be done using atomic bitops, but currently we don't,
>> which is broken.
>>
>> Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which happend
>> when one thread tried to clear PF_USED_MATH while at the same time another
>> thread tried to flip PF_SPREAD_PAGE/PF_SPREAD_SLAB. They both operate on
>> the same task.
>>
>> Here's the full report:
>> https://lkml.org/lkml/2014/9/19/230
>>
>> To fix this, we make PF_SPREAD_PAGE and PF_SPARED_SLAB atomic flags.
>>
> 
> s/SPARED/SPREAD/
> 
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Miao Xie <miaox@cn.fujitsu.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Fixes: 950592f7b991 ("cpusets: update tasks' page/slab spread flags in time")
>> Cc: <stable@vger.kernel.org> # 2.6.31+
>> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Signed-off-by: Zefan Li <lizefan@huawei.com>
>> ---
>>  include/linux/cpuset.h |  4 ++--
>>  include/linux/sched.h  | 13 +++++++++++--
>>  kernel/cpuset.c        |  9 +++++----
>>  3 files changed, 18 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>> index 0d4e067..2f073db 100644
>> --- a/include/linux/cpuset.h
>> +++ b/include/linux/cpuset.h
>> @@ -94,12 +94,12 @@ extern int cpuset_slab_spread_node(void);
>>  
>>  static inline int cpuset_do_page_mem_spread(void)
>>  {
>> -	return current->flags & PF_SPREAD_PAGE;
>> +	return task_spread_page(current);
>>  }
>>  
>>  static inline int cpuset_do_slab_mem_spread(void)
>>  {
>> -	return current->flags & PF_SPREAD_SLAB;
>> +	return task_spread_slab(current);
>>  }
>>  
>>  extern int current_cpuset_is_being_rebound(void);
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 5630763..7b1cafe 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1903,8 +1903,6 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
>>  #define PF_KTHREAD	0x00200000	/* I am a kernel thread */
>>  #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
>>  #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
>> -#define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
>> -#define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
>>  #define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
>>  #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
>>  #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
>> @@ -1958,6 +1956,9 @@ static inline void memalloc_noio_restore(unsigned int flags)
>>  
>>  /* Per-process atomic flags. */
>>  #define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
>> +#define PFA_SPREAD_PAGE  1      /* Spread page cache over cpuset */
>> +#define PFA_SPREAD_SLAB  2      /* Spread some slab caches over cpuset */
>> +
>>  
>>  #define TASK_PFA_TEST(name, func)					\
>>  	static inline bool task_##func(struct task_struct *p)		\
>> @@ -1972,6 +1973,14 @@ static inline void memalloc_noio_restore(unsigned int flags)
>>  TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
>>  TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
>>  
>> +TASK_PFA_TEST(SPREAD_PAGE, spread_page)
>> +TASK_PFA_SET(SPREAD_PAGE, spread_page)
>> +TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
>> +
>> +TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
>> +TASK_PFA_SET(SPREAD_SLAB, spread_slab)
>> +TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
>> +
>>  /*
>>   * task->jobctl flags
>>   */
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index a37f4ed..1f107c7 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -365,13 +365,14 @@ static void cpuset_update_task_spread_flag(struct cpuset *cs,
>>  					struct task_struct *tsk)
>>  {
>>  	if (is_spread_page(cs))
>> -		tsk->flags |= PF_SPREAD_PAGE;
>> +		task_set_spread_page(tsk);
>>  	else
>> -		tsk->flags &= ~PF_SPREAD_PAGE;
>> +		task_clear_spread_page(tsk);
>> +
>>  	if (is_spread_slab(cs))
>> -		tsk->flags |= PF_SPREAD_SLAB;
>> +		task_set_spread_slab(tsk);
>>  	else
>> -		tsk->flags &= ~PF_SPREAD_SLAB;
>> +		task_clear_spread_slab(tsk);
>>  }
>>  
>>  /*
> 
> This most certainly needs commentary to specify why these have to be 
> atomic ops.
> .

It won't hurt to add more comment, but I don't think it's necessary, because
the reason to use atomic bitops seems obvious to me. Besides there's no such
comment for no_new_privs, which was tsk->atomic_flags introduced for.


