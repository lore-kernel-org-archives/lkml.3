Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab3IDCBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:01:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934213Ab3IDCBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:01:17 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6vL9NhcTi7YA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Lu4-lkDicUYA:10 a=VnNF1IyMAAAA:8 a=756R-ZW2Qle6l11XYvwA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 3 Sep 2013 22:01:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 01/18 v2] ftrace: Add hash list to save RCU unsafe
 functions
Message-ID: <20130903220115.1018d8f4@gandalf.local.home>
In-Reply-To: <20130904012404.GI3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	<20130831051700.601365837@goodmis.org>
	<20130903171516.16290c47@gandalf.local.home>
	<20130903221808.GH3871@linux.vnet.ibm.com>
	<20130903195705.3ba3442f@gandalf.local.home>
	<20130904012404.GI3871@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013 18:24:04 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> >  static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
> > @@ -588,15 +593,14 @@ static void
> >  ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
> >  		       struct ftrace_ops *op, struct pt_regs *pt_regs)
> >  {
> > -	int bit;
> > -
> > +	/* Make sure we see disabled or not first */
> > +	smp_rmb();
> 
> 	smp_mb__before_atomic_inc()?
> 

Ah, but this is before an atomic_read(), and not an atomic_inc(), thus
the normal smp_rmb() is still required.

-- Steve

> >  	if (atomic_read(&ftrace_unsafe_rcu_disabled))
> >  		return;
> > 
> >  	preempt_disable_notrace();
> > 
