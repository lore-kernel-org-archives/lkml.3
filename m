Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3FNR1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:27:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40782 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab3FNR1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:27:03 -0400
Date: Fri, 14 Jun 2013 10:25:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] tracing/uprobes: Support ftrace_event_file base
 multibuffer
Message-ID: <20130614172516.GP5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <51BA7578.4080108@huawei.com>
 <51BB18EB.9080307@hitachi.com>
 <1371223918.9844.324.camel@gandalf.local.home>
 <20130614162112.GO5146@linux.vnet.ibm.com>
 <1371227607.9844.335.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371227607.9844.335.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061417-5806-0000-0000-000021B6C4D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:33:27PM -0400, Steven Rostedt wrote:
> On Fri, 2013-06-14 at 09:21 -0700, Paul E. McKenney wrote:
> 
> > > > > @@ -548,15 +556,35 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
> > > > >  /* uprobe handler */
> > > > >  static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
> > > > >  {
> > > > > -	if (!is_ret_probe(tu))
> > > > > -		uprobe_trace_print(tu, 0, regs);
> > > > > +	struct ftrace_event_file **file;
> > > > > +
> > > > > +	if (is_ret_probe(tu))
> > > > > +		return 0;
> > > > > +
> > > > > +	file = rcu_dereference_raw(tu->files);
> > > 
> > > Why are you using rcu_dereference_raw() and not rcu_dereference(). The
> > > _raw() is a bit special, and unless you know what you are doing with RCU
> > > here, don't use it.
> > > 
> > > As I see you using rcu_dereference_raw() all over this patch, along with
> > > mutexes, I believe that you are not using RCU correctly here.
> > 
> > If irqs and preempt are disabled, I suggest using rcu_dereference_sched().
> > That is what it is there for.  ;-)
> 
> I believe this just copied what kprobes did, where irqs and preemption
> is disabled. I don't believe that these probes have that same luxury.
> 
> But that begs the question. Should we convert the rcu_dereference_raw()
> in the kprobe code to rcu_dereference_sched()?

It makes a lot of sense to me, at least assuming no issues with the
interrupts being disabled, but the checks not spotting this.  Here
is the check:

	preempt_count() != 0 || irqs_disabled()

(With additional elaboration for if lockdep is enabled.)

							Thanx, Paul

