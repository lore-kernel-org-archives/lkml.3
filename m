Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3BRPCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:02:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3BRPCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:02:05 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1taZYQiZ_WsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=0H2JTn8J8XcA:10 a=whJf14y56VyULO2p4oQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361199721.23152.145.camel@gandalf.local.home>
Subject: Re: [PATCH 04/16] rcu: rcutiny: Prevent RCU stall
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 18 Feb 2013 10:02:01 -0500
In-Reply-To: <20130216205909.GB3094@linux.vnet.ibm.com>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
	 <1360771932-27150-5-git-send-email-bigeasy@linutronix.de>
	 <20130216205909.GB3094@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-16 at 12:59 -0800, Paul E. McKenney wrote:
>  
> > diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> > index 2b0484a..bac1906 100644
> > --- a/kernel/rcutiny_plugin.h
> > +++ b/kernel/rcutiny_plugin.h
> > @@ -552,7 +552,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
> >  		rcu_preempt_cpu_qs();
> > 
> >  	/* Hardware IRQ handlers cannot block. */
> > -	if (in_irq()) {
> > +	if (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_OFFSET)) {
> 
> For whatever it is worth, in mainline this is:
> 
> 	if (in_irq() || in_serving_softirq()) {
> 
> The definition of in_serving_softirq() is a bit different:
> 
> #define in_serving_softirq()    (softirq_count() & SOFTIRQ_OFFSET)
> 
> This might be due to differences between mainline and -rt, but thought
> it worth calling attention to.
> 

Right, and we should avoid open coding HARDIRQ_MASK and SOFTIRQ_OFFSET. 
And note, -rt is slowly creeping into mainline. It's better to have
things like this nicely tidied up.

-- Steve


