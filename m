Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaFZQb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:31:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbaFZQb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:31:26 -0400
Date: Thu, 26 Jun 2014 18:29:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christopher Covington <cov@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RFC: Add signal command to trace events
Message-ID: <20140626162943.GA9970@redhat.com>
References: <1403791044-2214-1-git-send-email-cov@codeaurora.org> <20140626111749.3234d4d4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626111749.3234d4d4@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Steven Rostedt wrote:
>
> [ Added Oleg who is the guru of signals ;-) ]

Thanks,

I didn't see the patch, so I can only guess what it does,

> On Thu, 26 Jun 2014 09:57:21 -0400
> Christopher Covington <cov@codeaurora.org> wrote:
>
> > This stops a process after an event has been triggered a given
> > number of times. For example:
> >
> > [[ -d /sys/kernel/debug/tracing ]] || \
> >   mount -t debugfs none /sys/kernel/debug
> > echo "p:myevent $(which myapp):0x700" > /sys/kernel/debug/tracing/uprobe_events
> > echo 1 > /sys/kernel/debug/tracing/events/uprobes/myevent/enable
> > echo 'signal:3' > /sys/kernel/debug/tracing/events/uprobes/myevent/trigger
> > myapp
> > myapp
> > myapp &
> >
> > Here, the 0x700 offset is the entry to main(). On the third
> > invocation of the program, the process is stopped.
> >
>
> Interesting trigger. I can see this being useful.

Yes. I thought about this too.

> > +//ifdef CONFIG_TRACER_SIGNAL
> > +static void
> > +signal_trigger(struct event_trigger_data *data)
> > +{
> > +	force_sig(SIGSTOP, current);

Well, I don't like this. Imho, it would be nice to avoid signals here.

And SIGSTOP in particular. It can interfere with the "real" SIGSTOP
sent by user, with ptrace, with tty.

I think we need something else... "STOP" is actually simple, but we need
some interface which allows to wakeup a task sleeping in TASK_KILLABLE
after it hits ETT_FREEZE.

Oleg.

