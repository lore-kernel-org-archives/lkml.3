Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3H0XlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:41:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3H0XlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:41:14 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=xQxuxMh46K0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RZDpadHLlpEA:10 a=QyXUC8HyAAAA:8 a=6k7WYqUOyLrVfXpJfHkA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 27 Aug 2013 19:41:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 01/10] tracing: Add support for SOFT_DISABLE to
 syscall events
Message-ID: <20130827194112.3b5d509c@gandalf.local.home>
In-Reply-To: <1377646146.15688.52.camel@empanada>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
	<a21a85892674dedf8ded3b2f0e83bd8106f5c22f.1377631572.git.tom.zanussi@linux.intel.com>
	<20130827160150.36f10869@gandalf.local.home>
	<1377646146.15688.52.camel@empanada>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 18:29:06 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> On Tue, 2013-08-27 at 16:01 -0400, Steven Rostedt wrote:
> > On Tue, 27 Aug 2013 14:40:13 -0500
> > Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> > 
> >   		return;
> > > -	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
> > > +
> > > +	/* Here we're inside the tp handler's rcu_read_lock (__DO_TRACE()) */
> > > +	ftrace_file = rcu_dereference_raw(tr->enter_syscall_files[syscall_nr]);
> > 
> > What's the reason for using rcu_dereference_raw() and not normal
> > rcu_dereference?
> > 
> 
> This is because we know the tracepoint handler has rcu_read_lock_held()
> and so we don't need to do the rcu_dereference_check().
> 

That's not the point of raw(). What happens if in the future we modify
the code and this is called without rcu_read_lock held? Then we just
took away the debug check. Please do not circumvent any debug unless
there's a reason for it. The function tracer does circumvent these
checks because the debug checks can cause the function tracer to hang
the box. Kind of killing the point of debug checks ;-)

Anyway, this should be rcu_derefence() not rcu_dereference_raw().

-- Steve
