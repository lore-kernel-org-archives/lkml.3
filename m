Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3JRBTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:19:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26265 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab3JRBTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:19:11 -0400
X-IronPort-AV: E=Sophos;i="4.93,518,1378828800"; 
   d="scan'208";a="8787898"
Message-ID: <52608D88.6010807@cn.fujitsu.com>
Date: Fri, 18 Oct 2013 09:23:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] rcusync: Introduce struct rcu_sync_ops
References: <20131008102505.404025673@infradead.org>	<20131008103830.291708447@infradead.org> <525F4653.809@cn.fujitsu.com> <20131017154228.GL4553@linux.vnet.ibm.com>
In-Reply-To: <20131017154228.GL4553@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/18 09:16:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/18 09:16:47,
	Serialize complete at 2013/10/18 09:16:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 11:42 PM, Paul E. McKenney wrote:
> On Thu, Oct 17, 2013 at 10:07:15AM +0800, Lai Jiangshan wrote:
>> On 10/08/2013 06:25 PM, Peter Zijlstra wrote:
>>> From: Oleg Nesterov <oleg@redhat.com>
>>>
>>> Add the new struct rcu_sync_ops which holds sync/call methods, and
>>> turn the function pointers in rcu_sync_struct into an array of struct
>>> rcu_sync_ops.
>>
>> Hi, Paul
>>
>> I think this work should be done in rcupdate.[ch] side by introducing
>> struct rcu_flavor.
> 
> I -do- have on my list to add an rcutorture test for rcu_sync, but
> what do you have in mind by adding struct rcu_flavor?  I am guessing
> that you do not mean to try to create an rcu_state and a set of

No.
The thing what I need is just as same as Oleg Nesterov implemented.
It is just a structure with several function pointers for different RCU variants.
But it would be better if we implement in rcupdate.[ch],
and name it to struct rcu_flavor like the URCU.

After we have struct rcu_flavor, we can replace the following code
to a pointer to struct rcu_flavor.

struct rcu_state:
	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
		     void (*func)(struct rcu_head *head));

struct rcu_torture_ops {
	int (*readlock)(void);
	void (*readunlock)(int idx);
	void (*sync)(void);
	void (*exp_sync)(void);
	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
	void (*cb_barrier)(void);
};

and struct rcu_sync {
	...
};


Thanks,
Lai.



> rcu_data structures for rcu_sync -- the write-side optimizations
> would not fit well into rcu_state/rcu_data.
> 
> You might mean to simply put this code into rcupdate.[ch], which
> would be OK, but rcu_sync seems to me to be sufficiently different
> to deserve its own .c and .h files.
> 
> So what did you have in mind?

I mean we need something like struct rcu_flavor as the URCU.


> 
> 							Thanx, Paul
> 
>> Thanks,
>> Lai
>>
>>>
>>> This simplifies the "init" helpers, and this way it is simpler to add
>>> the new methods we need, especially ifdef'ed.
>>>
>>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>>> Link: http://lkml.kernel.org/r/20131005171746.GA17664@redhat.com
>>> ---
>>>
>>> diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
>>> index 7858491..988ec33 100644
>>> --- a/include/linux/rcusync.h
>>> +++ b/include/linux/rcusync.h
>>> @@ -4,6 +4,8 @@
>>>  #include <linux/wait.h>
>>>  #include <linux/rcupdate.h>
>>>  
>>> +enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
>>> +
>>>  struct rcu_sync_struct {
>>>  	int			gp_state;
>>>  	int			gp_count;
>>> @@ -12,53 +14,37 @@ struct rcu_sync_struct {
>>>  	int			cb_state;
>>>  	struct rcu_head		cb_head;
>>>  
>>> -	void (*sync)(void);
>>> -	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
>>> +	enum rcu_sync_type	gp_type;
>>>  };
>>>  
>>> -#define ___RCU_SYNC_INIT(name)						\
>>> -	.gp_state = 0,							\
>>> -	.gp_count = 0,							\
>>> -	.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),		\
>>> -	.cb_state = 0
>>> -
>>> -#define __RCU_SCHED_SYNC_INIT(name) {					\
>>> -	___RCU_SYNC_INIT(name),						\
>>> -	.sync = synchronize_sched,					\
>>> -	.call = call_rcu_sched,						\
>>> -}
>>> -
>>> -#define __RCU_BH_SYNC_INIT(name) {					\
>>> -	___RCU_SYNC_INIT(name),						\
>>> -	.sync = synchronize_rcu_bh,					\
>>> -	.call = call_rcu_bh,						\
>>> -}
>>> -
>>> -#define __RCU_SYNC_INIT(name) {						\
>>> -	___RCU_SYNC_INIT(name),						\
>>> -	.sync = synchronize_rcu,					\
>>> -	.call = call_rcu,						\
>>> -}
>>> -
>>> -#define DEFINE_RCU_SCHED_SYNC(name)					\
>>> -	struct rcu_sync_struct name = __RCU_SCHED_SYNC_INIT(name)
>>> -
>>> -#define DEFINE_RCU_BH_SYNC(name)					\
>>> -	struct rcu_sync_struct name = __RCU_BH_SYNC_INIT(name)
>>> -
>>> -#define DEFINE_RCU_SYNC(name)						\
>>> -	struct rcu_sync_struct name = __RCU_SYNC_INIT(name)
>>> -
>>>  static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
>>>  {
>>>  	return !rss->gp_state; /* GP_IDLE */
>>>  }
>>>  
>>> -enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
>>> -
>>>  extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
>>>  extern void rcu_sync_enter(struct rcu_sync_struct *);
>>>  extern void rcu_sync_exit(struct rcu_sync_struct *);
>>>  
>>> +#define __RCU_SYNC_INITIALIZER(name, type) {				\
>>> +		.gp_state = 0,						\
>>> +		.gp_count = 0,						\
>>> +		.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),	\
>>> +		.cb_state = 0,						\
>>> +		.gp_type = type,					\
>>> +	}
>>> +
>>> +#define	__DEFINE_RCU_SYNC(name, type)	\
>>> +	struct rcu_sync_struct name = __RCU_SYNC_INITIALIZER(name, type)
>>> +
>>> +#define DEFINE_RCU_SYNC(name)		\
>>> +	__DEFINE_RCU_SYNC(name, RCU_SYNC)
>>> +
>>> +#define DEFINE_RCU_SCHED_SYNC(name)	\
>>> +	__DEFINE_RCU_SYNC(name, RCU_SCHED_SYNC)
>>> +
>>> +#define DEFINE_RCU_BH_SYNC(name)	\
>>> +	__DEFINE_RCU_SYNC(name, RCU_BH_SYNC)
>>> +
>>>  #endif /* _LINUX_RCUSYNC_H_ */
>>>  
>>> diff --git a/kernel/rcusync.c b/kernel/rcusync.c
>>> index f84176a..99051b7 100644
>>> --- a/kernel/rcusync.c
>>> +++ b/kernel/rcusync.c
>>> @@ -1,7 +1,24 @@
>>> -
>>>  #include <linux/rcusync.h>
>>>  #include <linux/sched.h>
>>>  
>>> +static const struct {
>>> +	void (*sync)(void);
>>> +	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
>>> +} gp_ops[] = {
>>> +	[RCU_SYNC] = {
>>> +		.sync = synchronize_rcu,
>>> +		.call = call_rcu,
>>> +	},
>>> +	[RCU_SCHED_SYNC] = {
>>> +		.sync = synchronize_sched,
>>> +		.call = call_rcu_sched,
>>> +	},
>>> +	[RCU_BH_SYNC] = {
>>> +		.sync = synchronize_rcu_bh,
>>> +		.call = call_rcu_bh,
>>> +	},
>>> +};
>>> +
>>>  enum { GP_IDLE = 0, GP_PENDING, GP_PASSED };
>>>  enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
>>>  
>>> @@ -11,23 +28,7 @@ void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
>>>  {
>>>  	memset(rss, 0, sizeof(*rss));
>>>  	init_waitqueue_head(&rss->gp_wait);
>>> -
>>> -	switch (type) {
>>> -	case RCU_SYNC:
>>> -		rss->sync = synchronize_rcu;
>>> -		rss->call = call_rcu;
>>> -		break;
>>> -
>>> -	case RCU_SCHED_SYNC:
>>> -		rss->sync = synchronize_sched;
>>> -		rss->call = call_rcu_sched;
>>> -		break;
>>> -
>>> -	case RCU_BH_SYNC:
>>> -		rss->sync = synchronize_rcu_bh;
>>> -		rss->call = call_rcu_bh;
>>> -		break;
>>> -	}
>>> +	rss->gp_type = type;
>>>  }
>>>  
>>>  void rcu_sync_enter(struct rcu_sync_struct *rss)
>>> @@ -44,7 +45,7 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
>>>  	BUG_ON(need_wait && need_sync);
>>>  
>>>  	if (need_sync) {
>>> -		rss->sync();
>>> +		gp_ops[rss->gp_type].sync();
>>>  		rss->gp_state = GP_PASSED;
>>>  		wake_up_all(&rss->gp_wait);
>>>  	} else if (need_wait) {
>>> @@ -81,7 +82,7 @@ static void rcu_sync_func(struct rcu_head *rcu)
>>>  		 * to catch a later GP.
>>>  		 */
>>>  		rss->cb_state = CB_PENDING;
>>> -		rss->call(&rss->cb_head, rcu_sync_func);
>>> +		gp_ops[rss->gp_type].call(&rss->cb_head, rcu_sync_func);
>>>  	} else {
>>>  		/*
>>>  		 * We're at least a GP after rcu_sync_exit(); eveybody will now
>>> @@ -99,7 +100,7 @@ void rcu_sync_exit(struct rcu_sync_struct *rss)
>>>  	if (!--rss->gp_count) {
>>>  		if (rss->cb_state == CB_IDLE) {
>>>  			rss->cb_state = CB_PENDING;
>>> -			rss->call(&rss->cb_head, rcu_sync_func);
>>> +			gp_ops[rss->gp_type].call(&rss->cb_head, rcu_sync_func);
>>>  		} else if (rss->cb_state == CB_PENDING) {
>>>  			rss->cb_state = CB_REPLAY;
>>>  		}
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
> 

