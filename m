Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3JCUOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:14:41 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53787 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab3JCUOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:14:39 -0400
Message-ID: <524DD041.4060803@redhat.com>
Date: Thu, 03 Oct 2013 22:14:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
References: <20131002145655.361606532@infradead.org> <20131002150518.675931976@infradead.org> <20131003164117.GD5790@linux.vnet.ibm.com> <20131003184001.GM28601@twins.programming.kicks-ass.net>
In-Reply-To: <20131003184001.GM28601@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/10/2013 20:40, Peter Zijlstra ha scritto:
> On Thu, Oct 03, 2013 at 09:41:17AM -0700, Paul E. McKenney wrote:
>> On Wed, Oct 02, 2013 at 04:56:57PM +0200, Peter Zijlstra wrote:
>> #ifdef CONFIG_PROVE_RCU
>> #define rcu_sync_is_idle_check(rss) BUG_ON(!rss->read_side_check())
>> #else
>> #define rcu_sync_is_idle_check(rss) do { } while (0)
>> #endif
>>
>> 	rcu_sync_is_idle_check(rss);
> 
> The below actually seems to build, although I didn't test the config
> permutations, only defconfig.
> 
> ---
> --- a/include/linux/rcusync.h
> +++ b/include/linux/rcusync.h
> @@ -14,6 +14,7 @@ struct rcu_sync_struct {
>  
>  	void (*sync)(void);
>  	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> +	int  (*held)(void);
>  };
>  
>  #define ___RCU_SYNC_INIT(name)						\
> @@ -26,18 +27,21 @@ struct rcu_sync_struct {
>  	___RCU_SYNC_INIT(name),						\
>  	.sync = synchronize_sched,					\
>  	.call = call_rcu_sched,						\
> +	.held = rcu_read_lock_sched_held,				\
>  }
>  
>  #define __RCU_BH_SYNC_INIT(name) {					\
>  	___RCU_SYNC_INIT(name),						\
>  	.sync = synchronize_rcu_bh,					\
>  	.call = call_rcu_bh,						\
> +	.held = rcu_read_lock_bh_held,					\
>  }
>  
>  #define __RCU_SYNC_INIT(name) {						\
>  	___RCU_SYNC_INIT(name),						\
>  	.sync = synchronize_rcu,					\
>  	.call = call_rcu,						\
> +	.held = rcu_read_lock_held,					\
>  }
>  
>  #define DEFINE_RCU_SCHED_SYNC(name)					\
> @@ -51,6 +55,9 @@ struct rcu_sync_struct {
>  
>  static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
>  {
> +#ifdef CONFIG_PROVE_RCU
> +	BUG_ON(!rss->held());
> +#endif
>  	return !rss->gp_state; /* GP_IDLE */
>  }
>  
> 

Do you need to do the same in rcu_sync_init?

Paolo
