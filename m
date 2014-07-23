Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbaGWSxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:53:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:4024 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932846AbaGWSxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:53:22 -0400
Date: Wed, 23 Jul 2014 14:53:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: kill global_start_up
Message-ID: <20140723145319.78722824@gandalf.local.home>
In-Reply-To: <20140723182911.GA19253@redhat.com>
References: <20140720151814.GA32439@redhat.com>
	<20140721094706.60eb3877@gandalf.local.home>
	<20140721095046.4343746d@gandalf.local.home>
	<20140723182911.GA19253@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014 20:29:11 +0200
Oleg Nesterov <oleg@redhat.com> wrote:


> > Nevermind, seems that Namhyung Kim beat you to it (and it's already in
> > my for-next branch).
> >
> > http://lkml.kernel.org/r/1402584972-17824-1-git-send-email-namhyung@kernel.org
> 
> Thanks for your report Steven, I updated my ~/people-i-hate file.

Is that for me or Namhyung? Silly question, it has to be for Namhyung,
as I'm sure I'm one of the first people already in that list.

> 
> 
> This motivated me to try to find something else unused. And it seems that
> almost all code in kernel/trace/trace_sched_switch.c is dead? Hmm, and

sched_switch? Move along, nothing to see here...

OK, there was a time we had a bunch of "tracers" (those things in
the available_tracers file). And since events and perf came along,
there was a push to remove them all. We never got rid of function,
function_graph, mmiotrace and the latency tracers as they are quite
different from events (function is close, but they need special care).

One of the casualties to that tracer purge was the sched_switch tracer.
But it wasn't such a simple removal, as that code was in charge of the
trace_find_cmdline() logic. Well, to get people away from using it, we
removed it from the "available_tracers" file, but kept most of the code
as clean up for another day.

As with most things on a TODO list, they get pushed down to the bottom,
crushed by the many things above it, and finally swept under the rug
until some nosy developer decides to take a peek under that carpet and
point to the maintainer of said code with his white glove on and the
smudge at the end of his finger and say "WHAT'S THIS!".

Well, here's a broom and dustpan, have at it!

> probably even event_context_switch... I'll recheck and send the patch.
> 
> But is there any documentation about /sys/kernel/debug/tracing/events/ftrace/*
> files ?

No, they are mostly internal, and only there for the format files for
things like trace-cmd and perf to be able to parse it.

> 
> OK, as I just figured out ftrace/function is special, it is visible to
> perf and thus "record ftrace:function" should work.
> 
> But what a user can do with other files? You obviously can't enable, say,
> ftrace/bputs, if I understand correctly this is for trace_puts().
> 

Yeah, as trace_printk() can turn into a trace_puts() we still want
those to be read by trace-cmd. To do that, the formats for those files
are exported.

See kernel/trace/trace_export.c and trace_entries.h


> Confused...

Aren't we all?

-- Steve

