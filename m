Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbbANQzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:55:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56117 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbbANQzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:55:41 -0500
Date: Wed, 14 Jan 2015 17:55:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, vvs@sw.ru,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86-ml <x86@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] ftrace/jprobes/x86: Fix conflict between jprobes and
 function graph tracing
Message-ID: <20150114165537.GB6902@pd.tnic>
References: <20150114153958.931152836@goodmis.org>
 <20150114154329.552437962@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150114154329.552437962@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 10:40:01AM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> If the function graph tracer traces a jprobe callback, the system will
> crash. This can easily be demonstrated by compiling the jprobe
> sample module that is in the kernel tree, loading it and running the
> function graph tracer.
> 
>  # modprobe jprobe_example.ko
>  # echo function_graph > /sys/kernel/debug/tracing/current_tracer
>  # ls
> 
> The first two commands end up in a nice crash after the first fork.
> (do_fork has a jprobe attached to it, so "ls" just triggers that fork)
> 
> The problem is caused by the jprobe_return() that all jprobe callbacks
> must end with. The way jprobes works is that the function a jprobe
> is attached to has a breakpoint placed at the start of it (or it uses
> ftrace if fentry is supported). The breakpoint handler (or ftrace callback)
> will copy the stack frame and change the ip address to return to the
> jprobe handler instead of the function. The jprobe handler must end
> with jprobe_return() which swaps the stack and does an int3 (breakpoint).
> This breakpoint handler will then put back the saved stack frame,
> simulate the instruction at the beginning of the function it added
> a breakpoint to, and then continue on.
> 
> For function tracing to work, it hijakes the return address from the
> stack frame, and replaces it with a hook function that will trace
> the end of the call. This hook function will restore the return
> address of the function call.
> 
> If the function tracer traces the jprobe handler, the hook function
> for that handler will not be called, and its saved return address
> will be used for the next function. This will result in a kernel crash.
> 
> To solve this, pause function tracing before the jprobe handler is called
> and unpause it before it returns back to the function it probed.

Err, stupid question: marking the jprobe handler "notrace" doesn't help?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
