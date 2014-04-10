Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbaDJTNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:13:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54153 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753367AbaDJTNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:13:43 -0400
Date: Thu, 10 Apr 2014 15:13:40 -0400
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
Message-ID: <20140410151340.7d24aafd@gandalf.local.home>
In-Reply-To: <20140410181417.GA2104@redhat.com>
References: <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
	<20140409124249.4081e665@gandalf.local.home>
	<20140409170505.GA27638@redhat.com>
	<20140409170616.GC27638@redhat.com>
	<20140410092842.1f9a8760@gandalf.local.home>
	<20140410133855.GC12228@redhat.com>
	<20140410102816.24337ffe@gandalf.local.home>
	<20140410144655.GA25316@redhat.com>
	<20140410110848.64c3f25e@gandalf.local.home>
	<20140410175705.GB32332@redhat.com>
	<20140410181417.GA2104@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 20:14:17 +0200
Oleg Nesterov <oleg@redhat.com> wrote:


> And I forgot to mention, given that the kernel_thread() callback should
> call do_exit() itself, then this part of cc3b13c11c567c69a63
> 
> 	one case when a kernel thread can reach the
> 	usual syscall exit tracing path: when we create a kernel thread, the
> 	child comes to ret_from_fork
> 
> is no longer relevant? A PF_KTHREAD child should never return from the
> callback and thus it should never do "jmp syscall_exit" ?
> 

Are you sure. On set up of the kthread, create_kthread() calls
kernel_thread() with "kthread()" as its first parameter.

kernel_thread() then calls do_fork() passing the "kthread" function as
the stack_start parameter, which if you follow where that goes, it gets
to copy_thread() in process_[63][42].c which assigns sp (the function)
to the bx register for the PF_KTHREAD case. But more importantly, it
sets up the stack to have ip pointing to ret_from_kernel_thread (32 bit
version).

The jmp syscall_exit when it goes to return to "userspace" will in
actuality return to ret_from_kernel_thread (32 bit). Which this does:

	call *PT_EBX(%esp)

which calls your handler. But then again, this calls syscall_exit when
done, which probably will never be hit as kthread() calls do_exit()
itself. Perhaps if something goes wrong, syscall_exit can handle any
faults that can happen?

For 64 bit, the check for kernel thread is in ret_from_fork itself.
which does the call *%rbx, but again, if it fails, it then calls
int_ret_from_sys_call, which it may also handle faults.

Looks like kernel threads on 32bit call syscall exit at least once, to
get to ret_from_kernel_thread. Not sure why it does that. Perhaps this
could be another 32bit clean up to make it more like x86_64.

-- Steve
