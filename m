Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab3IBCBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:01:54 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53837 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab3IBCBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:01:52 -0400
Date: Sun, 1 Sep 2013 19:01:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        lttng-dev@lists.lttng.org, sparse@chrisli.org,
        linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: Make rcu_assign_pointer's assignment volatile and
 type-safe
Message-ID: <20130902020137.GI3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130823164637.GB3871@linux.vnet.ibm.com>
 <20130823171653.GA16558@Krystal>
 <20130823210822.GD3871@linux.vnet.ibm.com>
 <20130830005733.GA20664@linux.vnet.ibm.com>
 <20130830021637.GA21862@leaf>
 <20130831213228.GF3871@linux.vnet.ibm.com>
 <20130901204209.GA20802@leaf>
 <20130901222619.GH3871@linux.vnet.ibm.com>
 <20130901224317.GA25057@leaf>
 <20130901234251.GB25057@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130901234251.GB25057@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090202-7182-0000-0000-0000084489BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 04:42:52PM -0700, Josh Triplett wrote:
> rcu_assign_pointer needs to use ACCESS_ONCE to make the assignment to
> the destination pointer volatile, to protect against compilers too
> clever for their own good.
> 
> In addition, since rcu_assign_pointer force-casts the source pointer to
> add the __rcu address space (overriding any existing address space), add
> an explicit check that the source pointer has the __kernel address space
> to start with.
> 
> This new check produces warnings like this, when attempting to assign
> from a __user pointer:
> 
> test.c:25:9: warning: incorrect type in argument 2 (different address spaces)
> test.c:25:9:    expected struct foo *<noident>
> test.c:25:9:    got struct foo [noderef] <asn:1>*badsrc
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Queued for 3.13, thank you very much!

							Thanx, Paul

> ---
>  include/linux/rcupdate.h | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 4b14bdc..3f62def 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -510,8 +510,17 @@ static inline void rcu_preempt_sleep_check(void)
>  #ifdef __CHECKER__
>  #define rcu_dereference_sparse(p, space) \
>  	((void)(((typeof(*p) space *)p) == p))
> +/* The dummy first argument in __rcu_assign_pointer_typecheck makes the
> + * typechecked pointer the second argument, matching rcu_assign_pointer itself;
> + * this avoids confusion about argument numbers in warning messages. */
> +#define __rcu_assign_pointer_check_kernel(v) \
> +	do { \
> +		extern void __rcu_assign_pointer_typecheck(int, typeof(*(v)) __kernel *); \
> +		__rcu_assign_pointer_typecheck(0, v); \
> +	} while (0)
>  #else /* #ifdef __CHECKER__ */
>  #define rcu_dereference_sparse(p, space)
> +#define __rcu_assign_pointer_check_kernel(v) do { } while (0)
>  #endif /* #else #ifdef __CHECKER__ */
> 
>  #define __rcu_access_pointer(p, space) \
> @@ -555,7 +564,8 @@ static inline void rcu_preempt_sleep_check(void)
>  #define __rcu_assign_pointer(p, v, space) \
>  	do { \
>  		smp_wmb(); \
> -		(p) = (typeof(*v) __force space *)(v); \
> +		__rcu_assign_pointer_check_kernel(v); \
> +		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \
>  	} while (0)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

