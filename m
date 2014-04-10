Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030844AbaDJNE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:04:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:48934 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030583AbaDJNEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:04:54 -0400
Date: Thu, 10 Apr 2014 09:04:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RESEND 1/2] tracing: syscall_*regfunc() can race with
 copy_process()
Message-ID: <20140410090452.6b7677fc@gandalf.local.home>
In-Reply-To: <20140409170542.GB27638@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
	<1397059882-23063-3-git-send-email-fweisbec@gmail.com>
	<360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
	<20140409124249.4081e665@gandalf.local.home>
	<20140409170505.GA27638@redhat.com>
	<20140409170542.GB27638@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014 19:05:42 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> syscall_regfunc() and syscall_unregfunc() should set/clear
> TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> with copy_process() and miss the new child which was not added to
> init_task.tasks list yet.
> 
> Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> under tasklist.
> 
> While at it,
> 
> 	- remove _irqsafe from syscall_regfunc/syscall_unregfunc,
> 	  read_lock(tasklist) doesn't need to disable irqs.
> 
> 	- change syscall_unregfunc() to check PF_KTHREAD to skip
> 	  the kernel threads, ->mm != NULL is the common mistake.
> 
> 	  Note: probably this check should be simply removed, needs
> 	  another patch.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

BTW, how important is this fix? Something we should aim for the current
merge window? stable? Or can it wait till 3.16?

-- Steve
