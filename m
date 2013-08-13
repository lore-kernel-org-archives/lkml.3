Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab3HMPOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:14:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573Ab3HMPOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:14:46 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=KpzchuzAFZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ce-1e7Iquy0A:10 a=Tty9oNO6AAAA:8 a=IP2yQMkz8mZKPo8lfH8A:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 11:14:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
Message-ID: <20130813111442.632f3421@gandalf.local.home>
In-Reply-To: <877hc64klm.fsf@rustcorp.com.au>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
	<877hc64klm.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011 10:03:09 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

[ Resurrection from the dead! ]

> On Tue, 08 Mar 2011 17:18:04 -0500, Steven Rostedt <rostedt@goodmis.org> wrote:
> > A few months ago it was suggested to have a way to enable tracepoints in
> > a module when it is loaded. I tried various methods, but this one seems
> > to be the least intrusive. In fact, it requires no modification to the
> > module code.
> 
> This seems quite nice!
> 
> Importantly, do you like it better than the previous version?  I like it
> because it doesn't touch my code, but that's not a fair test.
> 
> A few minor things:
> 1) Can we document this somewhere more persistent too? ftrace.txt?

I'll need to update this.

> 2) Your documentation should probably just use "trace_foo_bar" and omit
>    the "=1".  Because we can :)

And it does.

> 3) Can we share more with param_set_bool?  Nice to have it in one place
>    when someone decides the kernel really needs to accept "=true" or
>    whatever.

I'll look into this.

> 4) =n should really unset the flag, so args fight correctly.
> 
> eg (wildly untested):
> 
> int ftrace_mod_param_set(const char *val, const struct kernel_param *kp)
> {
> 	struct ftrace_event_call *call = kp->arg;
>         struct kernel_param bool_kp;
>         bool set;
>         int err;
> 
>         /* We work exactly like param_set_bool. */
>         bool_kp.arg = &set;
>         bool_kp.flags = KPARAM_ISBOOL;
>         err = param_set_bool(val, &bool_kp);
>         if (err)
>                 return err;
> 
>        	/* Set flag to tell ftrace to enable this event on init */
>         if (set)
>                 call->flags = TRACE_EVENT_FL_MOD_ENABLE;
>         else
>                 call->flags &= ~TRACE_EVENT_FL_MOD_ENABLE;
> 
> 	return 0;
> }

I can add this too.

But the thing about this that bothers me is that there's no way to say,
"Enable all tracepoints in this module on load". I would like a way to
do that, but I don't know of a way to do that without modifying the
module code. Have any ideas? Basically, I would love to have:

insmod foo tracepoints=all

or something and have all tracepoints enabled.

I started playing with tricks in the include/trace/ftrace.h file to
automatically create a general module parameter, but modules like KVM
include multiple trace headers which means anything I make will be
duplicated in the module and wont work.

Well, I'll go back to this original patch set (as I've been asked three
times within the last few months if there's a way to have tracepoints
enabled on module load).

-- Steve
