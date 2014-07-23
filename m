Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921AbaGWMHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:07:02 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41442 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaGWMHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:07:00 -0400
Date: Wed, 23 Jul 2014 05:06:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/16] rcu: Check return value for cpumask allocation
Message-ID: <20140723120654.GF11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-3-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406092194-13004-3-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072312-0928-0000-0000-0000039B100A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:09:39AM -0400, Pranith Kumar wrote:
> This commit add a check for return value of zalloc_cpumask_var() used while
> allocating cpumask for rcu_nocb_mask.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/rcu/tree_plugin.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index f07b643..bac9797 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -88,7 +88,10 @@ static void __init rcu_bootup_announce_oddness(void)
>  #ifdef CONFIG_RCU_NOCB_CPU
>  #ifndef CONFIG_RCU_NOCB_CPU_NONE
>  	if (!have_rcu_nocb_mask) {
> -		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
> +		if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
> +			pr_info("rcu_nocb_mask allocation failed\n");
> +			return;

Good catch, but this "return" is an accident waiting to happen.  The
accident will happen as soon as another RCU option appears, and the
person adding it quite naturally adds it at the end of this function.
The cleanest approach is to make an rcu_bootup_announce_oddness_nocb()
as one commit that does -only- code motion, and the make this change
as another commit.

							Thanx, Paul

> +		}
>  		have_rcu_nocb_mask = true;
>  	}
>  #ifdef CONFIG_RCU_NOCB_CPU_ZERO
> -- 
> 2.0.0.rc2
> 

