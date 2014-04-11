Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaDKMDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbaDKMDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:03:47 -0400
Date: Fri, 11 Apr 2014 14:03:47 +0200
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
Message-ID: <20140411120347.GA19753@redhat.com>
References: <20140410092842.1f9a8760@gandalf.local.home> <20140410133855.GC12228@redhat.com> <20140410102816.24337ffe@gandalf.local.home> <20140410144655.GA25316@redhat.com> <20140410110848.64c3f25e@gandalf.local.home> <20140410175705.GB32332@redhat.com> <20140410181417.GA2104@redhat.com> <20140410151340.7d24aafd@gandalf.local.home> <20140410193820.GA15624@redhat.com> <20140410155554.44f88536@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410155554.44f88536@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Steven Rostedt wrote:
>
> On Thu, 10 Apr 2014 21:38:20 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > I _think_ that the kernel thread can only return from "call *%rbx" if
> > it is no longer a kernel thread, iow, do_execve() was called.
>
> Ah right. But only in special cases.
>
> Actually, it only returns if the function in kernel_thread() returns,
> and in the case of ____call_usermodehelper, it does an exec and
> returns on success. But if it fails, it needs to call do_exit().

Yes. If it simply returns the kernel will crash, without start_thread/etc
"int_ret_from_sys_call" can do nothing good.

So we can conclude that "there is only one case when a kernel thread can
reach the usual syscall exit tracing path:" from cc3b13c11c567c69 is no
longer valid and we can kille the PF_KTHREAD check in regfuncs.

> Thus, it's not sufficient to just say "only if do_execve is called" but
> to say, if the handler that is called is only allowed to return iff it
> did a execve first and succeeded.

I do remember, I already told you are pedant!

Oleg.

