Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935639AbaDJO2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:28:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:27961 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934688AbaDJO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:28:18 -0400
Date: Thu, 10 Apr 2014 10:28:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RESEND 2/2] tracing: syscall_regfunc() should not skip
 kernel threads
Message-ID: <20140410102816.24337ffe@gandalf.local.home>
In-Reply-To: <20140410133855.GC12228@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
	<1397059882-23063-3-git-send-email-fweisbec@gmail.com>
	<360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
	<20140409124249.4081e665@gandalf.local.home>
	<20140409170505.GA27638@redhat.com>
	<20140409170616.GC27638@redhat.com>
	<20140410092842.1f9a8760@gandalf.local.home>
	<20140410133855.GC12228@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 15:38:55 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/10, Steven Rostedt wrote:
> >
> > On Wed, 9 Apr 2014 19:06:16 +0200
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > syscall_regfunc() ignores the kernel thread because "it has
> > > no effect", see cc3b13c1 "Don't trace kernel thread syscalls".
> > >
> > > However, this means that a user-space task spawned by
> > > call_usermodehelper() won't report the system calls if
> > > kernel_execve() is called when sys_tracepoint_refcount != 0.
> >
> > What about doing the set there? That is, we could add a check in the
> > call_userspacehelper() just before it does the do_execve, that if
> > sys_tracepoint_refcount is set, we set the TIF flag.
> 
> But for what?

Isn't call_usermodehelper() the reason you added this?

> 
> And if we do this, ____call_usermodehelper() needs write_lock_irq(tasklist)
> to serialize with syscall_*regfunc().

You mean for the slight race between checking if its set and when the
tracepoint is actually activated?

I don't think we really care about that race. I mean, the tracepoint is
activated usually by humans, and if they enabled it just as a usermode
helper is activated, and those are really fast to run, do we even care
if it is missed?

Now, if tracing is on and we need to set the flag, that should take the
task list lock to make sure that we don't miss clearing it. Missing the
set isn't a big deal, but missing the clearing of the flag is.

void tracepoint_check_syscalls(void)
{
	if (!sys_tracepoint_refcount)
		return;

	read_lock(&tasklist_lock);
	/* Make sure it wasn't cleared since taking the lock */
	if (sys_tracepoint_refcount)
		set_tsk_thread_flag(current, TIF_SYSCALL_TRACEPOINT);
	read_unlock(&tasklist_lock);
}

Hmm, probably need to use another lock than tasklist_lock as the
updating of sys_tracepoint_refcount is not done under it. But as this
is all local to tracepoint.c we could easily add something to do the
job

s/read_lock(&tasklist_lock)/spin_lock(&tracepoint_sys_lock)/

-- Steve
