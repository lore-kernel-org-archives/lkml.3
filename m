Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaGDOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:25:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:26379 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751804AbaGDOZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:25:27 -0400
Date: Fri, 4 Jul 2014 10:25:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 1/3] ftrace/x86: Add dynamic allocated trampoline
 for ftrace_ops
Message-ID: <20140704102525.3fc3d4b1@gandalf.local.home>
In-Reply-To: <53B6ACFC.3090300@hitachi.com>
References: <20140703200750.648550267@goodmis.org>
	<20140703202324.832135644@goodmis.org>
	<53B6ACFC.3090300@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2014 22:32:44 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/07/04 5:07), Steven Rostedt wrote:
> > +
> > +void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
> > +{
> > +	unsigned char *new;
> > +	unsigned long start_offset;
> > +	unsigned long call_offset;
> > +	unsigned long offset;
> > +	unsigned long ip;
> > +	int ret;
> > +
> > +	if (ops->trampoline) {
> > +		/*
> > +		 * The ftrace_ops caller may set up its own trampoline.
> > +		 * In such a case, this code must not modify it.
> > +		 */
> > +		if (!(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
> > +			return;
> 
> Just a question, what happen if the ftrace_ops caller sets up a trampoline which is
> not compatible to the ftrace's trampoline, and the ftrace_ops conflicts on a IP with other
> ftrace_ops? I guess in that case ftrace will use the loop callback on the IP, but since
> the trampoline is not compatible, the result will not be same, is that right? :)

If the caller sets up a trampoline, it must not set the ALLOC_TRAMP
flag. If you look at the comment about that flag it states this:

+ * ALLOC_TRAMP - A dynamic trampoline was allocated by the core code.
+ *            The arch specific code sets this flag when it allocated a
+ *            trampoline. This lets the arch know that it can update the
+ *            trampoline in case the callback function changes.
+ *            The ftrace_ops trampoline can be set by the ftrace users, and
+ *            in such cases the arch must not modify it. Only the arch ftrace
+ *            core code should set this flag.


That last line is important. Only the arch ftrace code (the one that
may modify it with arch_ftrace_update_trampoline should set the
ALLOC_TRAMP flag. That's how it knows if it can modify it or not.

The function_graph tracer sets up its own trampoline. Although it needs
to go through some hoops there because it shares the ftrace_ops with
the function tracer. Thus, it has to store the trampoline and this flag
before registering ftrace ops, and then it has to restore it when it
unregisters.

-- Steve

