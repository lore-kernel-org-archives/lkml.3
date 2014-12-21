Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaLVDvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 22:51:50 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51383 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaLVDvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 22:51:49 -0500
Date: Sun, 21 Dec 2014 09:46:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rcu_sched stall detected, but no state dump
Message-ID: <20141221174617.GA32307@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1412101334380.22639@pobox.suse.cz>
 <20141210162823.GT25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412111024010.17929@pobox.suse.cz>
 <20141211165010.GI25340@linux.vnet.ibm.com>
 <20141211190957.GA28172@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412121431450.6587@pobox.suse.cz>
 <20141212165829.GQ25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412151400090.17292@pobox.suse.cz>
 <alpine.LNX.2.00.1412191154260.14243@pobox.suse.cz>
 <20141219153220.GR11609@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141219153220.GR11609@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122203-0005-0000-0000-0000075DBC13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 07:32:20AM -0800, Paul E. McKenney wrote:
> On Fri, Dec 19, 2014 at 12:09:48PM +0100, Miroslav Benes wrote:
> > On Mon, 15 Dec 2014, Miroslav Benes wrote:

[ . . . ]

> > But I'm not sure whether it is possible that the list of pending callback 
> > is empty. Maybe the bug is elsewhere. My understanding of RCU is limited 
> > but I'll try to look around. Also the commit log might be imprecise :/
> 
> You found the problem, good show!  However, we do need a slightly
> different fix, please see below.

And, as I should have said the first time, please update your patch
as mentioned below so that I can add it to the -rcu tree.

								Thanx, Paul

> > Best regards,
> > Miroslav
> > 
> > -- >8 --
> > >From be3495519513356daa366517bb458bc4f05ecf9b Mon Sep 17 00:00:00 2001
> > From: Miroslav Benes <mbenes@suse.cz>
> > Date: Fri, 19 Dec 2014 11:11:04 +0100
> > Subject: [PATCH] rcu: fix rcu stall detection in tiny implementation
> 
> The first word following a ":" needs to be capitalized.
> 
> > The current tiny RCU stall detection depends on presence of pending callbacks in
> > the list (*rcp->curtail et al.). But they are none even in case of real CPU
> > stalls prohibiting the detection. When the check for callback presence is
> > removed, INFO about the stall is correctly printed.
> 
> As you say, this needs to be reworked, but first please see below.
> 
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > ---
> >  kernel/rcu/tiny_plugin.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/rcu/tiny_plugin.h b/kernel/rcu/tiny_plugin.h
> > index 858c565..3f743fa 100644
> > --- a/kernel/rcu/tiny_plugin.h
> > +++ b/kernel/rcu/tiny_plugin.h
> > @@ -145,7 +145,7 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
> >  	rcp->ticks_this_gp++;
> >  	j = jiffies;
> >  	js = ACCESS_ONCE(rcp->jiffies_stall);
> > -	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
> > +	if (ULONG_CMP_GE(j, js)) {
> 
> The problem is that ->curtail is a tail pointer, and thus always points
> to a NULL pointer, so the expression is always false.  However, we don't
> want to give RCU CPU stall warnings if there are no callbacks, because
> this can result in spurious stall warnings after long idle periods.
> 
> So we need to check the header pointer as follows:
> 
> +	if (rcp->rcucblist && ULONG_CMP_GE(j, js)) {
> 
> But what do you do if your test module happens to start spinning when
> there is no callback?
> 
> One approach is to do a call_rcu() just after starting your loop.
> Alternatively, do several just before starting your loop.
> 
> 							Thanx, Paul
> 
> >  		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
> >  		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
> >  		       jiffies - rcp->gp_start, rcp->qlen);
> > -- 
> > 2.1.2
> > 

