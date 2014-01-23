Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaAWOVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:21:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbaAWOVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:21:44 -0500
Subject: Re: [PATCH v6 7/8] x86: patch all traced function calls using the
 int3-based framework
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <1390396845.16203.58.camel@pathway.suse.cz>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	 <1386690140-19941-8-git-send-email-pmladek@suse.cz>
	 <20140115104741.2d78cee4@gandalf.local.home>
	 <1390396845.16203.58.camel@pathway.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jan 2014 15:21:42 +0100
Message-ID: <1390486902.16203.161.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 14:20 +0100, Petr Mladek wrote:
> On Wed, 2014-01-15 at 10:47 -0500, Steven Rostedt wrote:
> > On Tue, 10 Dec 2013 16:42:19 +0100
> > Petr Mladek <pmladek@suse.cz> wrote:
> > 
> > > 
> > > diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> > > index 03abf9abf681..e5c02af3a8cc 100644
> > > --- a/arch/x86/kernel/alternative.c
> > > +++ b/arch/x86/kernel/alternative.c
> > > @@ -613,7 +613,7 @@ void __kprobes text_poke_or_die(void *addr, const void *opcode, size_t len)
> > >   * responsible for setting the patched code read-write. This is more effective
> > >   * only when you patch many addresses at the same time.
> > >   */
> > > -static int text_poke_part(void *addr, const void *opcode, size_t len)
> > > +static int notrace text_poke_part(void *addr, const void *opcode, size_t len)
> > 
> > I can understand why you want to not trace any of these, but again, I
> > hate using notrace unless it is absolutely necessary. That's what the
> > set_ftrace_notrace is for. If you don't want to trace it, simply tell
> > the kernel not to.
> 
> I removed "notrace" from all locations, except for "poke_int3_handler".
> Then I tried to switch between 7 tracers, enable and disable tracing,
> and repeated this 100 times. It slowed down from:
> 
> real    3m25.837s    3m29.280s    3m27.408s
> user    0m0.004s     0m0.004s     0m0.000s
> sys     0m3.532s     0m3.460s     0m3.416s
> 
> to 
> 
> real    5m23.294s    5m24.944s    5m28.056s
> user    0m0.004s     0m0.004s	  0m0.004s
> sys     0m3.076s     0m3.180s	  0m3.396s
> 
> It means a change by 60%. As you know indeed, the reason is that the
> functions used during patching are called via the int3 handler once the
> breakpoint is added.
> 
> I thought about patching these functions separately, e.g. using separate
> list or extra filters with two round patching. But I think that it is
> not worth the extra complexity.
> 
> I agree that it might be worth to keep the functions traceable. So, if
> the slowness is acceptable for you, I am fine with it as well.

I updated numbers in commit messages for the patchset v7. I am slightly
in doubts now. I wonder if the complex iterator-based text_poke_bp_list
is still worth the effort.

I tried to switch between 7 tracers: blk, branch, function_graph,
wakeup_rt, irqsoff, function, and nop. Every tracer has also been
enabled and disabled. I tested it on idle system with Intel(R) Core(TM)2
Duo CPU E8400  @ 3.00GHz. With 500 cycles I got these times:

1. original code (without the patch set):

real    18m4.545s    18m11.568s    18m14.396s
user    0m0.004s     0m0.008s	   0m0.004s
sys     0m17.176s    0m16.940s	   0m16.664s


2. with patchset v7 ; notrace used only for poke_int3_handler; the
   slowness is caused by heavy using poke_int3_handler during patching

real    27m11.690s    27m18.176s    27m13.844s
user    0m0.008s      0m0.008s	    0m0.008s
sys     0m15.916s     0m15.956s	    0m15.860s


3. using text_poke_bp instead of text_poke_bp_list; every address
   is patched separately; the slowness is caused by heavy using of
   run_sync()

real    34m8.042s    34m15.584s    34m5.008s
user    0m0.004s     0m0.004s	   0m0.004s
sys     0m16.296s    0m16.268s	   0m16.048s


It means that the slowness caused by tracing "text_poke*" stuff is
comparable with the slowness caused by "run_sync()". It might mean that
"text_poke_bp_list" is not worth the added complexity.

Well, the iterator-based implementation is complex but still faster.
Also the many sync calls might be more painful for a busy system that
heavy use of the int3 handler. So, "text_poke_bp_list" still might be
useful.


Best Regards,
Petr

