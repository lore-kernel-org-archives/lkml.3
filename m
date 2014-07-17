Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaGQA07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:26:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34285 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbaGQA06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:26:58 -0400
Date: Wed, 16 Jul 2014 17:26:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Matt Turner <mattst88@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?utf-8?B?6JSh5q2j6b6Z?= <zhenglong.cai@cs2c.com.cn>,
        Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>,
        Fabian Frederick <fabf@skynet.be>, David Howells <dhowells@redhat.com>,
        Peter Foley <pefoley2@pefoley.com>, Eric Paris <eparis@redhat.com>,
        Dwight Engen <dwight.engen@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: Allow user to ovveride RCU_NOCB_CPU_ALL at
 boot time
Message-ID: <20140717002651.GJ8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405550289-18020-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405550289-18020-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071700-0928-0000-0000-00000373C54C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 06:38:08PM -0400, Pranith Kumar wrote:
> A kernel built with RCU_NOCB_CPU_ALL build time option will offload callbacks
> from all CPUs. The user cannot override this behavior without recompiling the
> kernel with the RCU_NOCB_CPU_ALL option turned off. 
> 
> This commit allows the user to override the build-time option by using the
> rcu_nocbs= boot time option without needing to recompile the kernel.
> 
> Please note that this is how NO_HZ_FULL_ALL build time option works and this
> commit makes it work similar to that.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

I cannot accept this patch.  For one thing, tick_nohz_init_all() looks
a bit on the unconditional side when CONFIG_NO_HZ_FULL_ALL=y.  For
another thing, we really do not want to be handing the user a tool that
allows CPUs that are nohz_full to not be no-CBs CPUs.  For another thing,
if we add this and it turns out to be a bad idea, it will be difficult
to take it back -- someone somewhere will no doubt have scripted the
boot parameter.

							Thanx, Paul

> ---
>  init/Kconfig             | 14 +++++++-------
>  kernel/rcu/tree_plugin.h |  8 ++++----
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 41066e4..7d363a4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -768,13 +768,13 @@ config RCU_NOCB_CPU_ALL
>  	bool "All CPUs are build_forced no-CBs CPUs"
>  	depends on RCU_NOCB_CPU
>  	help
> -	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
> -	  boot parameter will be ignored.  All CPUs' RCU callbacks will
> -	  be executed in the context of per-CPU rcuo kthreads created for
> -	  this purpose.  Assuming that the kthreads whose names start with
> -	  "rcuo" are bound to "housekeeping" CPUs, this reduces OS jitter
> -	  on the remaining CPUs, but might decrease memory locality during
> -	  RCU-callback invocation, thus potentially degrading throughput.
> +	  If the user doesn't pass the rcu_nocbs= boot option, force all CPUs
> +	  to be no-CBs CPUs.  All CPUs' RCU callbacks will be executed in the
> +	  context of per-CPU rcuo kthreads created for this purpose. Assuming
> +	  that the kthreads whose names start with "rcuo" are bound to
> +	  "housekeeping" CPUs, this reduces OS jitter on the remaining CPUs, but
> +	  might decrease memory locality during RCU-callback invocation, thus
> +	  potentially degrading throughput.
> 
>  	  Select this if all CPUs need to be no-CBs CPUs for real-time
>  	  or energy-efficiency reasons.
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index a2113f6..b97a939 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -92,15 +92,15 @@ static void __init rcu_bootup_announce_oddness(void)
>  	if (!have_rcu_nocb_mask) {
>  		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
>  		have_rcu_nocb_mask = true;
> +#ifdef CONFIG_RCU_NOCB_CPU_ALL
> +		pr_info("\tOffload RCU callbacks from all CPUs\n");
> +		cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
> +#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
>  	}
>  #ifdef CONFIG_RCU_NOCB_CPU_ZERO
>  	pr_info("\tOffload RCU callbacks from CPU 0\n");
>  	cpumask_set_cpu(0, rcu_nocb_mask);
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
> -#ifdef CONFIG_RCU_NOCB_CPU_ALL
> -	pr_info("\tOffload RCU callbacks from all CPUs\n");
> -	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
> -#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
>  #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
>  	if (have_rcu_nocb_mask) {
>  		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
> -- 
> 1.9.1
> 

