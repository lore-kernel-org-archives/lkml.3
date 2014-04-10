Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbaDJSOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:14:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758716AbaDJSOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:14:15 -0400
Date: Thu, 10 Apr 2014 20:14:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 2/2] tracing: syscall_regfunc() should not skip
	kernel threads
Message-ID: <20140410181417.GA2104@redhat.com>
References: <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home> <20140409170505.GA27638@redhat.com> <20140409170616.GC27638@redhat.com> <20140410092842.1f9a8760@gandalf.local.home> <20140410133855.GC12228@redhat.com> <20140410102816.24337ffe@gandalf.local.home> <20140410144655.GA25316@redhat.com> <20140410110848.64c3f25e@gandalf.local.home> <20140410175705.GB32332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410175705.GB32332@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Oleg Nesterov wrote:
>
> On 04/10, Steven Rostedt wrote:
> >
> > Hendrik, we are debating about removing
> > cc3b13c11c567c69a6356be98d0c03ff11541d5c as it stops
> > call_usermodehelper tasks from tracing their syscalls.
> >
> > If Hendrik has no problems with this, neither do I.
>
> OK.
>
> cc3b13c11c567 mentions ret_from_fork, today copy_thread(PF_KTHREAD) uses
> ret_from_kernel_thread on 32bit, and still ret_from_fork on 64 bit but
> in the last case it checks PF_KTHREAD... I am wondering why they both
> (ret_from_kernel_thread and "1: " label in ret_from_fork) can't simply
> call do_exit() at the end?

probably because we need to change all architectures...

> And, since they do not, every kernel_thread's function (fn argument of
> kernel_thread) must call do_exit itself?

Hmm yes. See fb45550d76bb5 "make sure that kernel_thread() callbacks call
do_exit() themselves".

> Looks a bit strange, I guess I missed something obvious.

And I forgot to mention, given that the kernel_thread() callback should
call do_exit() itself, then this part of cc3b13c11c567c69a63

	one case when a kernel thread can reach the
	usual syscall exit tracing path: when we create a kernel thread, the
	child comes to ret_from_fork

is no longer relevant? A PF_KTHREAD child should never return from the
callback and thus it should never do "jmp syscall_exit" ?

Or I am totally confused?

Oleg.

