Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3FJWZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:25:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27556 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3FJWZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:25:38 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eB9Tj_0eLcoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=XIlBwW5Cg4gA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=MkM9E93eg-OsmwSmzVwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370903137.9844.133.camel@gandalf.local.home>
Subject: Re: Another RCU trace. (3.10-rc5)
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Date: Mon, 10 Jun 2013 18:25:37 -0400
In-Reply-To: <20130610221031.GV5146@linux.vnet.ibm.com>
References: <20130610195145.GA26068@redhat.com>
	 <20130610203355.GO5146@linux.vnet.ibm.com>
	 <20130610210123.GA27154@redhat.com>
	 <20130610211803.GR5146@linux.vnet.ibm.com>
	 <1370900256.9844.128.camel@gandalf.local.home>
	 <20130610215421.GA31251@redhat.com>
	 <20130610221031.GV5146@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 15:10 -0700, Paul E. McKenney wrote:

> > So maybe that patch was a winner after all and got dropped ?
> 
> Please see below for the patch that I was thinking of.
> 
> It has not been dropped, I was on travel and a bit slow about pushing
> things.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> trace: Allow idle-safe tracepoints to be called from irq
> 
> __DECLARE_TRACE_RCU() currently creates an _rcuidle() tracepoint which
> may safely be invoked from what RCU considers to be an idle CPU.
> However, these _rcuidle() tracepoints may -not- be invoked from the
> handler of an irq taken from idle, because rcu_idle_enter() zeroes
> RCU's nesting-level counter, so that the rcu_irq_exit() returning to
> idle will trigger a WARN_ON_ONCE().
> 
> This commit therefore substitutes rcu_irq_enter() for rcu_idle_exit()
> and rcu_irq_exit() for rcu_idle_enter() in order to make the _rcuidle()
> tracepoints usable from irq handlers as well as from process context.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 2f322c3..f8e084d 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -145,8 +145,8 @@ static inline void tracepoint_synchronize_unregister(void)
>  				TP_PROTO(data_proto),			\
>  				TP_ARGS(data_args),			\
>  				TP_CONDITION(cond),			\
> -				rcu_idle_exit(),			\
> -				rcu_idle_enter());			\
> +				rcu_irq_enter(),			\
> +				rcu_irq_exit());			\

Still wont fix the splat that Dave saw. As the splat has nothing to do
with tracepoints, but has to do with function tracing, which is a whole
'nother beast.

-- Steve

>  	}
>  #else
>  #define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)


