Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3CRQft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:35:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab3CRQfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:35:46 -0400
Date: Mon, 18 Mar 2013 17:33:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: syscall_*regfunc() can race with
	copy_process()
Message-ID: <20130318163338.GB20313@redhat.com>
References: <20130317182831.GA22986@redhat.com> <1363546123.25967.125.camel@gandalf.local.home> <20130317190023.GA24023@redhat.com> <1363548855.25967.135.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363548855.25967.135.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Steven Rostedt wrote:
>
> On Sun, 2013-03-17 at 20:00 +0100, Oleg Nesterov wrote:
> > On 03/17, Steven Rostedt wrote:
> > >
> > > > Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> > > > under tasklist.
> > >
> > > Is this because "p = dup_task_struct(current);" is outside the lock?
> > > Probably should state this in the change log.
> >
> > Not only, syscall_regfunc/syscall_unregfunc can miss the new child.
> >
> > Just suppose that syscall_regfunc() takes tasklist right before the
> > forking task tries to take it for writing and and the child to the
> > list.
>
> I'm a bit confused by the above. Maybe it's the typo with the "and and"
> that's confusing me.

Yes, "and and" was supposed to be "and add".

But probably I misunderstood you before... Well yes, this is because
"p = dup_task_struct(current)" copies TIF_SYSCALL_TRACEPOINT outside
of the tasklist-protected section which also makes the new task visible
for do_each_thread().

IOW, the state of TIF_SYSCALL_TRACEPOINT bit can be correct after
dup_task_struct(), but it can't be updated until copy_process() add
the child to the list.

> > OK, thanks, will do. But perhaps tracepoint_fork() would be better?
>
> tracepoint_fork() is similar to being called trace_fork() which would be
> considered a tracepoint. Seeing tracepoint_fork() would make me think it
> has something to do with the fork tracepoint.
>
> Do we plan on doing anything other than updating the syscall tracepoint
> flag here? I find the "syscall_tracepoint_update()" very descriptive to
> what is actually happening. While reading the fork code, seeing
> 'syscall_tracepoint_update()' would tell me that this has something to
> do with syscall tracepoints, which it does. But tracepoint_fork() would
> have me think something completely different.

OK, thanks, I am sending v2 in reply to v1.

Oleg.

