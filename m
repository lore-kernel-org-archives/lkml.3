Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbaGWSBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:01:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43305 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbaGWSBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:01:44 -0400
Date: Wed, 23 Jul 2014 11:01:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/16] rcu: Check return value for cpumask allocation
Message-ID: <20140723180138.GC11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-3-git-send-email-bobby.prani@gmail.com>
 <20140723120654.GF11241@linux.vnet.ibm.com>
 <CAJhHMCA_K8qH7pspzfRb15L7=p2rdngmi3XoH35gR9kWjo8EnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCA_K8qH7pspzfRb15L7=p2rdngmi3XoH35gR9kWjo8EnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072318-0928-0000-0000-000003949C20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:14:19PM -0400, Pranith Kumar wrote:
> On Wed, Jul 23, 2014 at 8:06 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >> --- a/kernel/rcu/tree_plugin.h
> >> +++ b/kernel/rcu/tree_plugin.h
> >> @@ -88,7 +88,10 @@ static void __init rcu_bootup_announce_oddness(void)
> >>  #ifdef CONFIG_RCU_NOCB_CPU
> >>  #ifndef CONFIG_RCU_NOCB_CPU_NONE
> >>       if (!have_rcu_nocb_mask) {
> >> -             zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
> >> +             if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
> >> +                     pr_info("rcu_nocb_mask allocation failed\n");
> >> +                     return;
> >
> > Good catch, but this "return" is an accident waiting to happen.  The
> > accident will happen as soon as another RCU option appears, and the
> > person adding it quite naturally adds it at the end of this function.
> > The cleanest approach is to make an rcu_bootup_announce_oddness_nocb()
> > as one commit that does -only- code motion, and the make this change
> > as another commit.
> >
> 
> Hi Paul,
> 
> Looking at this, I think the following is simpler without having to
> introduce a new function. What do you think?
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index c31eb28..f2ed342 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -88,8 +88,10 @@ static void __init rcu_bootup_announce_oddness(void)
>  #ifdef CONFIG_RCU_NOCB_CPU
>  #ifndef CONFIG_RCU_NOCB_CPU_NONE
>         if (!have_rcu_nocb_mask) {
> -               zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
> -               have_rcu_nocb_mask = true;
> +               if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL))
> +                       pr_info("rcu_nocb_mask allocation failed");
> +               else
> +                       have_rcu_nocb_mask = true;
>         }
>  #ifdef CONFIG_RCU_NOCB_CPU_ZERO
>         pr_info("\tOffload RCU callbacks from CPU 0\n");

I suspect that if zalloc_cpumask_var() fails, bad things will happen
if we get here, at least in the CONFIG_CPUMASK_OFFSTACK=y.

							Thanx, Paul

> 
> 
> -- 
> Pranith
> 

