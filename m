Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3F1TZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:25:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46181 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3F1TZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:25:14 -0400
Date: Fri, 28 Jun 2013 12:25:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rculist: list_first_or_null_rcu() should use
 list_entry_rcu()
Message-ID: <20130628192509.GB3773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130621003244.GD11837@mtj.dyndns.org>
 <20130626172753.GC4405@mtj.dyndns.org>
 <20130628173448.GD18889@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628173448.GD18889@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062819-5406-0000-0000-000009F6C559
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 10:34:48AM -0700, Tejun Heo wrote:
> list_first_or_null() should test whether the list is empty and return
> pointer to the first entry if not in a RCU safe manner.  It's broken
> in several ways.
> 
> * It compares __kernel @__ptr with __rcu @__next triggering the
>   following sparse warning.
> 
>   net/core/dev.c:4331:17: error: incompatible types in comparison expression (different address spaces)
> 
> * It doesn't perform rcu_dereference*() and computes the entry address
>   using container_of() directly from the __rcu pointer which is
>   inconsitent with other rculist interface.  As a result, all three
>   in-kernel users - net/core/dev.c, macvlan, cgroup - are buggy.  They
>   dereference the pointer w/o going through read barrier.
> 
> * While ->next dereference passes through list_next_rcu(), the
>   compiler is still free to fetch ->next more than once and thus
>   nullify the "__ptr != __next" condition check.
> 
> Fix it by making list_first_or_null_rcu() dereference ->next directly
> using ACCESS_ONCE() and then use list_entry_rcu() on it like other
> rculist accessors.
> 
> v2: Paul pointed out that the compiler may fetch the pointer more than
>     once nullifying the condition check.  ACCESS_ONCE() added on
>     ->next dereference.
> 
> v3: Restored () around macro param which was accidentally removed.
>     Spotted by Paul.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: stable@vger.kernel.org

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/rculist.h |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index 8089e35..523f13c 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -267,8 +267,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
>   */
>  #define list_first_or_null_rcu(ptr, type, member) \
>  	({struct list_head *__ptr = (ptr); \
> -	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
> -	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL; \
> +	  struct list_head *__next = ACCESS_ONCE(__ptr->next); \
> +	  likely(__ptr != __next) ? \
> +		list_entry_rcu(__next, type, member) : NULL; \
>  	})
> 
>  /**
> 

