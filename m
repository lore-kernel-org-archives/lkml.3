Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3FJWKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:10:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39795 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3FJWKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:10:35 -0400
Date: Mon, 10 Jun 2013 15:10:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: Another RCU trace. (3.10-rc5)
Message-ID: <20130610221031.GV5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130610195145.GA26068@redhat.com>
 <20130610203355.GO5146@linux.vnet.ibm.com>
 <20130610210123.GA27154@redhat.com>
 <20130610211803.GR5146@linux.vnet.ibm.com>
 <1370900256.9844.128.camel@gandalf.local.home>
 <20130610215421.GA31251@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610215421.GA31251@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061022-7606-0000-0000-00000C598402
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 05:54:21PM -0400, Dave Jones wrote:
> On Mon, Jun 10, 2013 at 05:37:36PM -0400, Steven Rostedt wrote:
>  > On Mon, 2013-06-10 at 14:18 -0700, Paul E. McKenney wrote:
>  > > On Mon, Jun 10, 2013 at 05:01:23PM -0400, Dave Jones wrote:
>  > > > On Mon, Jun 10, 2013 at 01:33:55PM -0700, Paul E. McKenney wrote:
>  > > > 
>  > > >  > > I saw some of Steven's patches get merged on Friday, is there anything else
>  > > >  > > outstanding that didn't make it in yet that I could test ?
>  > > >  > > Or is this another new bug ?
>  > > >  > 
>  > > >  > I have three fixes queued up at:
>  > > >  > 
>  > > >  > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent
>  > > >  > 
>  > > >  > Kind of hard to tell whether they are relevant given the interleaved
>  > > >  > stack traces, but can't hurt to try them out.
>  > > > 
>  > > > Here's another. Looks different.
>  > > 
>  > > I bet that commit d6284099 (trace: Allow idle-safe tracepoints to be
>  > > called from irq) from the above git archive fixes this one.  Just don't
>  > > ask how much I am willing to bet.  ;-)
>  > 
>  > Don't bet much ;-)  This has nothing to do with tracepoints. It's due to
>  > the function tracer. 
> 
> dammit, 20 minutes after I finally cloned the repo.
> Can we go back to posting diffs instead of hashes please ?
> 
> So while updating my list of bugs I've found this cycle, I noticed
> I'd already posted this one a month ago on -rc2.
> https://lkml.org/lkml/2013/5/21/327
> which led us to this patch https://lkml.org/lkml/2013/5/24/379
> After which I hit a bunch of what seem to be other RCU related bugs.
> 
> So maybe that patch was a winner after all and got dropped ?

Please see below for the patch that I was thinking of.

It has not been dropped, I was on travel and a bit slow about pushing
things.

							Thanx, Paul

------------------------------------------------------------------------

trace: Allow idle-safe tracepoints to be called from irq

__DECLARE_TRACE_RCU() currently creates an _rcuidle() tracepoint which
may safely be invoked from what RCU considers to be an idle CPU.
However, these _rcuidle() tracepoints may -not- be invoked from the
handler of an irq taken from idle, because rcu_idle_enter() zeroes
RCU's nesting-level counter, so that the rcu_irq_exit() returning to
idle will trigger a WARN_ON_ONCE().

This commit therefore substitutes rcu_irq_enter() for rcu_idle_exit()
and rcu_irq_exit() for rcu_idle_enter() in order to make the _rcuidle()
tracepoints usable from irq handlers as well as from process context.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2f322c3..f8e084d 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -145,8 +145,8 @@ static inline void tracepoint_synchronize_unregister(void)
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
 				TP_CONDITION(cond),			\
-				rcu_idle_exit(),			\
-				rcu_idle_enter());			\
+				rcu_irq_enter(),			\
+				rcu_irq_exit());			\
 	}
 #else
 #define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)

