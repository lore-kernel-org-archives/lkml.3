Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3FNQda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:33:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab3FNQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:33:29 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=OSMTF_Hz3HYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-sklomi2UD4A:10 a=Flxb3JMGdelzj-TmgnQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371227607.9844.335.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing/uprobes: Support ftrace_event_file base
 multibuffer
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Date: Fri, 14 Jun 2013 12:33:27 -0400
In-Reply-To: <20130614162112.GO5146@linux.vnet.ibm.com>
References: <51BA7578.4080108@huawei.com> <51BB18EB.9080307@hitachi.com>
	 <1371223918.9844.324.camel@gandalf.local.home>
	 <20130614162112.GO5146@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 09:21 -0700, Paul E. McKenney wrote:

> > > > @@ -548,15 +556,35 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
> > > >  /* uprobe handler */
> > > >  static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
> > > >  {
> > > > -	if (!is_ret_probe(tu))
> > > > -		uprobe_trace_print(tu, 0, regs);
> > > > +	struct ftrace_event_file **file;
> > > > +
> > > > +	if (is_ret_probe(tu))
> > > > +		return 0;
> > > > +
> > > > +	file = rcu_dereference_raw(tu->files);
> > 
> > Why are you using rcu_dereference_raw() and not rcu_dereference(). The
> > _raw() is a bit special, and unless you know what you are doing with RCU
> > here, don't use it.
> > 
> > As I see you using rcu_dereference_raw() all over this patch, along with
> > mutexes, I believe that you are not using RCU correctly here.
> 
> If irqs and preempt are disabled, I suggest using rcu_dereference_sched().
> That is what it is there for.  ;-)
> 

I believe this just copied what kprobes did, where irqs and preemption
is disabled. I don't believe that these probes have that same luxury.

But that begs the question. Should we convert the rcu_dereference_raw()
in the kprobe code to rcu_dereference_sched()?

-- Steve


