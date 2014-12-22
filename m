Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaLVTkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:40:23 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:40869 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaLVTkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:40:21 -0500
Date: Mon, 22 Dec 2014 11:40:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rcu_sched stall detected, but no state dump
Message-ID: <20141222194011.GV11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141210162823.GT25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412111024010.17929@pobox.suse.cz>
 <20141211165010.GI25340@linux.vnet.ibm.com>
 <20141211190957.GA28172@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412121431450.6587@pobox.suse.cz>
 <20141212165829.GQ25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412151400090.17292@pobox.suse.cz>
 <alpine.LNX.2.00.1412191154260.14243@pobox.suse.cz>
 <20141219153220.GR11609@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412221334060.16432@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412221334060.16432@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122219-0033-0000-0000-0000031A458A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 01:42:14PM +0100, Miroslav Benes wrote:
> On Fri, 19 Dec 2014, Paul E. McKenney wrote:
> > On Fri, Dec 19, 2014 at 12:09:48PM +0100, Miroslav Benes wrote:

[ . . . ]

> > But what do you do if your test module happens to start spinning when
> > there is no callback?
> > 
> > One approach is to do a call_rcu() just after starting your loop.
> > Alternatively, do several just before starting your loop.
> 
> Yes, that would be the way if I understand it correctly. Fortunately there 
> is always some pending RCU callback during my test. I wonder where it 
> comes from (probably module handling. I'll try to find out just to be 
> sure.). 
> 
> So, is the following patch correct? I tested it and it seems ok. And sorry 
> for the delay, I took the weekend off. Thank you for your patience.

Good!  I forward ported it to -rcu, merged the two "if" statements,
queued it, and have started testing.  Thank you!!!

							Thanx, Paul

> Miroslav
> 
> -- >8 --
> >From 0dccc8e322e1a38016422be8f4af110eb7a405fc Mon Sep 17 00:00:00 2001
> From: Miroslav Benes <mbenes@suse.cz>
> Date: Mon, 22 Dec 2014 13:24:44 +0100
> Subject: [PATCH] rcu: Fix RCU CPU stall detection in tiny implementation
> 
> The tiny RCU CPU stall detection depends on *rcp->curtail not being
> NULL. It is however a tail pointer and thus NULL by definition. Instead we
> should check rcp->rcucblist for the presence of pending callbacks which need to
> be processed. With this fix INFO about the stall is printed and jiffies_stall
> (jiffies at next stall) correctly updated.
> 
> Note that the check for pending callback is necessary to avoid spurious warnings
> if there are no pendings callbacks.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> ---
>  kernel/rcu/tiny_plugin.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tiny_plugin.h b/kernel/rcu/tiny_plugin.h
> index 858c565..868e132 100644
> --- a/kernel/rcu/tiny_plugin.h
> +++ b/kernel/rcu/tiny_plugin.h
> @@ -145,13 +145,13 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
>  	rcp->ticks_this_gp++;
>  	j = jiffies;
>  	js = ACCESS_ONCE(rcp->jiffies_stall);
> -	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
> +	if (rcp->rcucblist && ULONG_CMP_GE(j, js)) {
>  		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
>  		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
>  		       jiffies - rcp->gp_start, rcp->qlen);
>  		dump_stack();
>  	}
> -	if (*rcp->curtail && ULONG_CMP_GE(j, js))
> +	if (rcp->rcucblist && ULONG_CMP_GE(j, js))
>  		ACCESS_ONCE(rcp->jiffies_stall) = jiffies +
>  			3 * rcu_jiffies_till_stall_check() + 3;
>  	else if (ULONG_CMP_GE(j, js))
> -- 
> 2.1.2
> 

