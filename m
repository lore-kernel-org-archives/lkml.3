Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbbAOOSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:18:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:46959 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753190AbbAOORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:17:12 -0500
Date: Thu, 15 Jan 2015 09:17:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, vvs@sw.ru,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86-ml <x86@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] ftrace/jprobes/x86: Fix conflict between jprobes
 and function graph tracing
Message-ID: <20150115091726.6cef244f@grimm.local.home>
In-Reply-To: <54B7AB29.20209@hitachi.com>
References: <20150114153958.931152836@goodmis.org>
	<20150114154329.552437962@goodmis.org>
	<54B7AB29.20209@hitachi.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 20:57:29 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > If the function tracer traces the jprobe handler, the hook function
> > for that handler will not be called, and its saved return address
> > will be used for the next function. This will result in a kernel
> > crash.
> 
> Actually, both jprobe (user-defined) handler and jprobe_return()
> doesn't execute "ret".

Yep I new that. But a notrace on jprobe_return isn't that big of a
deal. It's not a function we really need to trace, as it really doesn't
do anything but being a 'hack' for jprobes to return properly.

> So, right after run out the jprobe handler with function-graph tracer,
> on the top of its hidden stack, there are at least 2(*) unused return
> addresses, one is for jprobe handler (this should be same as the
> probed function's return address) and other is jprobe_return()'s
> return address. (*: this can be more than 2 if jprobe_return is
> called from a function which is called from jprobe handler)
> 
> So, the hidden stack may be as below;
> 
> [jprobe_return() return address]
> [probed function return address]
> [probed function return address]
> 
> After jumping back to the probed function, the function return is
> trapped by the function-graph tracer, and it uses jprobe_return()'s
> return address. Since usually jprobe_return() is called at the end of
> the function, CPU will execute "ret" soon again(if someone puts a BUG
> right after jprobe_return(), the kernel will show that BUG), and it
> returns to the caller of the probed function.
> However, there still be the probed function return address on the
> hidden stack! This means that the next "ret" will go back to the same
> address but with modified register and stacks.

Yep, I discovered all this with my patch that allows function tracing
with jprobes.

> 
> > To solve this, pause function tracing before the jprobe handler is
> > called and unpause it before it returns back to the function it
> > probed.
> 
> Agreed, but it also could drop some NMI events. That is downside.
> 
> > Some other updates:
> > 
> > Used a variable "saved_sp" to hold kcb->jprobe_saved_sp. This makes
> > the code look a bit cleaner and easier to understand (various tries
> > to fix this bug required this change).
> 
> OK.
> 
> > Note, if fentry is being used, jprobes will change the ip address
> > before the function graph tracer runs and it will not be able to
> > trace the function that the jprobe is probing.
> 
> yes, it should be fixed.
> 
> BTW, my last part of IPMODIFY patches (which is not yet merged)
> can solve this a different way. It sets IPMODIFY flag only to jprobe.
> So, if function-graph tracer sets IPMODIFY flag, user can not enable
> function-graph tracer when jprobe is used.

Nah, I don't want to stop jprobes due to function graph tracing or vice
versa.

function graph tracer doesn't change the regs->ip, so it doesn't need
the flag. But I sent out a patch that fixes this for this case. Let me
know what you think of that one.


> 
> https://lkml.org/lkml/2014/10/9/210
> 
> Anyway, this patch is better to go stable trees.
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 

Thanks!

-- Steve
