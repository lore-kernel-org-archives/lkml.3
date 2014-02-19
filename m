Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaBSEeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:34:50 -0500
Received: from mail1.windriver.com ([147.11.146.13]:55423 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaBSEet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:34:49 -0500
Date: Tue, 18 Feb 2014 23:35:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: fix sparse warning for rcu_expedited from
 kernel/ksysfs.c
Message-ID: <20140219043536.GG5799@windriver.com>
References: <1392153012-14378-1-git-send-email-paul.gortmaker@windriver.com>
 <20140214003207.GN4250@linux.vnet.ibm.com>
 <20140217203618.GA24824@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140217203618.GA24824@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] rcu: fix sparse warning for rcu_expedited from kernel/ksysfs.c] On 17/02/2014 (Mon 12:36) Paul E. McKenney wrote:

> On Thu, Feb 13, 2014 at 04:32:07PM -0800, Paul E. McKenney wrote:
> > On Tue, Feb 11, 2014 at 04:10:12PM -0500, Paul Gortmaker wrote:
> > > To fix:
> > > 
> > > kernel/ksysfs.c:143:5: warning: symbol 'rcu_expedited' was not declared. Should it be static?
> > > 
> > > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > 
> > Queued, thank you!
> 
> Upon further review, I moved the rcu_expedited declaration to
> include/linux/rcupdate.h in order to avoid including RCU-specific
> kernel/rcu/rcu.h into non-RCU files.  This resulted in the patch below.
> Please let me know if you have any objections to this change.

I should learn to read my mailbox from oldest to newest after a holiday!
Looks good to me. [I compiled it by eye, without speculative writes ;) ]

I think we should still use the other rcu.h / trace header fix I'd
sent in response to Fengguang's report even with this change though.

Thanks,
Paul.
--
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Fix sparse warning for rcu_expedited from kernel/ksysfs.c
> 
> This commit fixes the follwoing warning:
> 
> kernel/ksysfs.c:143:5: warning: symbol 'rcu_expedited' was not declared. Should it be static?
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> [ paulmck: Moved the declaration to include/linux/rcupdate.h to avoid
>    including the RCU-internal rcu.h file outside of RCU. ]
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 55b605b49315..e4be6263807e 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -46,6 +46,7 @@
>  #include <linux/compiler.h>
>  #include <asm/barrier.h>
>  
> +extern int rcu_expedited; /* for sysctl */
>  #ifdef CONFIG_RCU_TORTURE_TEST
>  extern int rcutorture_runnable; /* for sysctl */
>  #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
> diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> index d945a949760f..e660964086e2 100644
> --- a/kernel/ksysfs.c
> +++ b/kernel/ksysfs.c
> @@ -19,6 +19,8 @@
>  #include <linux/sched.h>
>  #include <linux/capability.h>
>  
> +#include <linux/rcupdate.h>	/* rcu_expedited */
> +
>  #define KERNEL_ATTR_RO(_name) \
>  static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
>  
> diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
> index 1bd787fddcb2..af2e60a8425d 100644
> --- a/kernel/rcu/rcu.h
> +++ b/kernel/rcu/rcu.h
> @@ -116,8 +116,6 @@ static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
>  	}
>  }
>  
> -extern int rcu_expedited;
> -
>  #ifdef CONFIG_RCU_STALL_COMMON
>  
>  extern int rcu_cpu_stall_suppress;
> 
