Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaKRTdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:33:10 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56256 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbaKRTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:33:04 -0500
Date: Tue, 18 Nov 2014 09:16:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/16] rcupdate: Replace smp_read_barrier_depends() with
 lockless_dereference()
Message-ID: <20141118171639.GV5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
 <1415906662-4576-9-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415906662-4576-9-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111819-0013-0000-0000-0000065862F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 02:24:14PM -0500, Pranith Kumar wrote:
> Recently lockless_dereference() was added which can be used in place of
> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Queued for 3.20, thank you!  I was wondering about your removing the
"_" from "_________p1", but see that this allowed you to avoid the
checkpatch.pl warning.  ;-)

							Thanx, Paul

> ---
>  include/linux/rcupdate.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index ed4f593..386ba28 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -582,11 +582,11 @@ static inline void rcu_preempt_sleep_check(void)
>  })
>  #define __rcu_dereference_check(p, c, space) \
>  ({ \
> -	typeof(*p) *_________p1 = (typeof(*p) *__force)ACCESS_ONCE(p); \
> +	/* Dependency order vs. p above. */ \
> +	typeof(*p) *________p1 = (typeof(*p) *__force)lockless_dereference(p); \
>  	rcu_lockdep_assert(c, "suspicious rcu_dereference_check() usage"); \
>  	rcu_dereference_sparse(p, space); \
> -	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
> -	((typeof(*p) __force __kernel *)(_________p1)); \
> +	((typeof(*p) __force __kernel *)(________p1)); \
>  })
>  #define __rcu_dereference_protected(p, c, space) \
>  ({ \
> @@ -603,10 +603,10 @@ static inline void rcu_preempt_sleep_check(void)
>  })
>  #define __rcu_dereference_index_check(p, c) \
>  ({ \
> -	typeof(p) _________p1 = ACCESS_ONCE(p); \
> +	/* Dependency order vs. p above. */ \
> +	typeof(p) _________p1 = lockless_dereference(p); \
>  	rcu_lockdep_assert(c, \
>  			   "suspicious rcu_dereference_index_check() usage"); \
> -	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
>  	(_________p1); \
>  })
> 
> -- 
> 1.9.1
> 

