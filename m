Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaKSIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:16:59 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44211 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaKSIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:16:58 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        williams@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/2] ftrace/x86/extable: Add is_ftrace_trampoline() function
References: <20141119033331.689278545@goodmis.org>
	<20141119034829.497125839@goodmis.org>
Date: Wed, 19 Nov 2014 17:16:55 +0900
In-Reply-To: <20141119034829.497125839@goodmis.org> (Steven Rostedt's message
	of "Tue, 18 Nov 2014 22:33:33 -0500")
Message-ID: <87mw7nppu0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Tue, 18 Nov 2014 22:33:33 -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
> Stack traces that happen from function tracing check if the address
> on the stack is a __kernel_text_address(). That is, is the address
> kernel code. This calls core_kernel_text() which returns true
> if the address is part of the builtin kernel code. It also calls
> is_module_text_address() which returns true if the address belongs
> to module code.
>
> But what is missing is ftrace dynamically allocated trampolines.
> These trampolines are allocated for individual ftrace_ops that
> call the ftrace_ops callback functions directly. But if they do a
> stack trace, the code checking the stack wont detect them as they
> are neither core kernel code nor module address space.
>
> Adding another field to ftrace_ops that also stores the size of
> the trampoline assigned to it we can create a new function called
> is_ftrace_trampoline() that returns true if the address is a
> dynamically allocate ftrace trampoline. Note, it ignores trampolines
> that are not dynamically allocated as they will return true with
> the core_kernel_text() function.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


[SNIP]
> @@ -102,6 +103,8 @@ int __kernel_text_address(unsigned long addr)
>  		return 1;
>  	if (is_module_text_address(addr))
>  		return 1;
> +	if (is_ftrace_trampoline(addr))
> +		return 1;

What about kernel_text_address()?  It seems some archs like ARM use it
instead of __kernel_text_address() although trampoline is only enabled
on x86 for now.

Thanks,
Namhyung

