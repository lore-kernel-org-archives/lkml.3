Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966425AbaFTKX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:23:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44418 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934326AbaFTKX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:23:56 -0400
Date: Fri, 20 Jun 2014 11:22:59 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ricky Zhou <rickyz@google.com>
Subject: Re: [PATCH] arm: ptrace: fix syscall modification under
 PTRACE_O_TRACESECCOMP
Message-ID: <20140620102258.GA26626@arm.com>
References: <20140618202748.GA9022@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618202748.GA9022@www.outflux.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

I'm struggling to see the bug in the current code, so apologies if my
questions aren't helpful.

On Wed, Jun 18, 2014 at 09:27:48PM +0100, Kees Cook wrote:
> An x86 tracer wanting to change the syscall uses PTRACE_SETREGS
> (stored to regs->orig_ax), and an ARM tracer uses PTRACE_SET_SYSCALL
> (stored to current_thread_info()->syscall). When this happens, the
> syscall can change across the call to secure_computing(), since it may
> block on tracer notification, and the tracer can then make changes
> to the process, before we return from secure_computing(). This
> means the code must respect the changed syscall after the
> secure_computing() call in syscall_trace_enter(). The same is true
> for tracehook_report_syscall_entry() which may also block and change
> the syscall.

I don't think I understand what you mean by `the code must respect the
changed syscall'. The current code does indeed issue the new syscall, so are
you more concerned with secure_computing changing ->syscall, then the
debugger can't see the new syscall when it sees the trap from tracehook?
Are these even supposed to inter-operate?

> The x86 code handles this (it expects orig_ax to always be the
> desired syscall). In the ARM case, this means we should not be touching
> current_thread_info()->syscall after its initial assignment. All failures
> should result in a -1 syscall, though.

The only time we explicitly touch ->syscall is when we're aborting the call
(i.e. writing -1), which I think is fine.

Will
