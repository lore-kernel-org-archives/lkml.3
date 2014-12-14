Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaLNRPC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 12:15:02 -0500
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:34561 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751018AbaLNRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 12:15:00 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4385:5007:6119:6261:7875:7903:8660:9010:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13148:13161:13229:13230:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sheet88_2b7dc476be750
X-Filterd-Recvd-Size: 2911
Date: Sun, 14 Dec 2014 12:14:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
Message-ID: <20141214121457.59b22354@gandalf.local.home>
In-Reply-To: <1556965801.27338.1418576749817.JavaMail.zimbra@efficios.com>
References: <20141214164104.307127356@goodmis.org>
	<20141214164803.991954802@goodmis.org>
	<1556965801.27338.1418576749817.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 17:05:49 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> >  #ifdef CONFIG_MODULES
> >  /*
> >   * Tracepoint module list mutex protects the local module list.
> > @@ -76,7 +85,16 @@ static inline void release_probes(struct tracepoint_func
> > *old)
> >  	if (old) {
> >  		struct tp_probes *tp_probes = container_of(old,
> >  			struct tp_probes, probes[0]);
> > -		call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
> > +		/*
> > +		 * Tracepoints can be enabled before RCU is initialized
> > +		 * at boot up. If that is the case, do not bother using
> > +		 * call_rcu() (because that will fail), but instead just
> > +		 * free directly.
> > +		 */
> > +		if (likely(tracepoint_rcu_is_safe))
> > +			call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
> > +		else
> > +			rcu_free_old_probes(&tp_probes->rcu);
> 
> Would it makes sense to have call_rcu() and call_rcu_sched()
> provide this "direct call" fallback at early boot instead
> of having this in the caller ?
> 

That was my original thought, and I even started down that path. But
then I realized that tracepoints are very unique, and this is really
special for tracepoints. Then I thought, why touch a complex system like
RCU for the one off case of tracepoints? I don't really see any other
user needing this feature (well, maybe lockdep, perf or ftrace, but
still they too are special). I decided the simplest and safest approach
was to just touch the tracepoint code. Other users shouldn't need this.

If IRQ setup, or other core pieces of code can use this, then I would
agree that rcu should be changed. But until then, I rather not add
another conditional to the core RCU code.

-- Steve
