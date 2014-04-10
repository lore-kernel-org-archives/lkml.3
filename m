Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbaDJPIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:08:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:31660 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751225AbaDJPIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:08:50 -0400
Date: Thu, 10 Apr 2014 11:08:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 2/2] tracing: syscall_regfunc() should not skip
 kernel threads
Message-ID: <20140410110848.64c3f25e@gandalf.local.home>
In-Reply-To: <20140410144655.GA25316@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
	<1397059882-23063-3-git-send-email-fweisbec@gmail.com>
	<360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
	<20140409124249.4081e665@gandalf.local.home>
	<20140409170505.GA27638@redhat.com>
	<20140409170616.GC27638@redhat.com>
	<20140410092842.1f9a8760@gandalf.local.home>
	<20140410133855.GC12228@redhat.com>
	<20140410102816.24337ffe@gandalf.local.home>
	<20140410144655.GA25316@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 16:46:55 +0200
Oleg Nesterov <oleg@redhat.com> wrote:


> > I mean, the tracepoint is
> > activated usually by humans, and if they enabled it just as a usermode
> > helper is activated, and those are really fast to run, do we even care
> > if it is missed?
> 
> A user space task spawned by call_usermodehelper() can do everything, it
> can run forever.

Sounds nasty ;-)

> 
> > Now, if tracing is on and we need to set the flag, that should take the
> > task list lock to make sure that we don't miss clearing it. Missing the
> > set isn't a big deal, but missing the clearing of the flag is.
> >
> > void tracepoint_check_syscalls(void)
> > {
> > 	if (!sys_tracepoint_refcount)
> > 		return;
> >
> > 	read_lock(&tasklist_lock);
> > 	/* Make sure it wasn't cleared since taking the lock */
> > 	if (sys_tracepoint_refcount)
> > 		set_tsk_thread_flag(current, TIF_SYSCALL_TRACEPOINT);
> > 	read_unlock(&tasklist_lock);
> > }
> 
> And how this can help to avoid the race? We need write_lock_irq().

But you chopped off the last part. Where I replaced tasklist_lock with
a tracepoint specific lock that would synchronize
sys_tracepoint_refcount with the setting of the flags.


> 
> Perhaps I missed something... and I simply do not understand why do you
> want to do this.

Because I'm being an ass ;-)

The real reason I'm doing this debate is more to find out exactly what
the problems are. A learning exercise if you will. I just don't want to
add a regression, as Hendrik (which I just Cc'd) added the commit for a
reason. Perhaps you are correct that we should just go back to the way
things were.

Hendrik, we are debating about removing
cc3b13c11c567c69a6356be98d0c03ff11541d5c as it stops
call_usermodehelper tasks from tracing their syscalls.

If Hendrik has no problems with this, neither do I.

-- Steve
