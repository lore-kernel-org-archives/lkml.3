Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaAVNVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:21:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbaAVNUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:20:47 -0500
Subject: Re: [PATCH v6 7/8] x86: patch all traced function calls using the
 int3-based framework
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <20140115104741.2d78cee4@gandalf.local.home>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	 <1386690140-19941-8-git-send-email-pmladek@suse.cz>
	 <20140115104741.2d78cee4@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jan 2014 14:20:45 +0100
Message-ID: <1390396845.16203.58.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 10:47 -0500, Steven Rostedt wrote:
> On Tue, 10 Dec 2013 16:42:19 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > 
> > diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> > index 03abf9abf681..e5c02af3a8cc 100644
> > --- a/arch/x86/kernel/alternative.c
> > +++ b/arch/x86/kernel/alternative.c
> > @@ -613,7 +613,7 @@ void __kprobes text_poke_or_die(void *addr, const void *opcode, size_t len)
> >   * responsible for setting the patched code read-write. This is more effective
> >   * only when you patch many addresses at the same time.
> >   */
> > -static int text_poke_part(void *addr, const void *opcode, size_t len)
> > +static int notrace text_poke_part(void *addr, const void *opcode, size_t len)
> 
> I can understand why you want to not trace any of these, but again, I
> hate using notrace unless it is absolutely necessary. That's what the
> set_ftrace_notrace is for. If you don't want to trace it, simply tell
> the kernel not to.

I removed "notrace" from all locations, except for "poke_int3_handler".
Then I tried to switch between 7 tracers, enable and disable tracing,
and repeated this 100 times. It slowed down from:

real    3m25.837s    3m29.280s    3m27.408s
user    0m0.004s     0m0.004s     0m0.000s
sys     0m3.532s     0m3.460s     0m3.416s

to 

real    5m23.294s    5m24.944s    5m28.056s
user    0m0.004s     0m0.004s	  0m0.004s
sys     0m3.076s     0m3.180s	  0m3.396s

It means a change by 60%. As you know indeed, the reason is that the
functions used during patching are called via the int3 handler once the
breakpoint is added.

I thought about patching these functions separately, e.g. using separate
list or extra filters with two round patching. But I think that it is
not worth the extra complexity.

I agree that it might be worth to keep the functions traceable. So, if
the slowness is acceptable for you, I am fine with it as well.

> >  {
> >  	int ret;
> >  
> > @@ -662,7 +662,7 @@ static void *bp_int3_handler, *bp_int3_addr;
> >  static size_t bp_int3_len;
> >  static void *(*bp_int3_is_handled)(const unsigned long ip);
> >  
> > -int poke_int3_handler(struct pt_regs *regs)
> > +int notrace poke_int3_handler(struct pt_regs *regs)
> >  {
> >  	/* bp_patching_in_progress */
> >  	smp_rmb();
[...]
> > @@ -192,44 +162,10 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
> >  	old = ftrace_nop_replace();
> >  	new = ftrace_call_replace(ip, addr);
> >  
> > -	/* Should only be called when module is loaded */
> > -	return ftrace_modify_code_direct(rec->ip, old, new);
> > +	return ftrace_modify_code(ip, old, new);
> >  }
> >  
> >  /*
> > - * The modifying_ftrace_code is used to tell the breakpoint
> > - * handler to call ftrace_int3_handler(). If it fails to
> > - * call this handler for a breakpoint added by ftrace, then
> > - * the kernel may crash.
> > - *
> > - * As atomic_writes on x86 do not need a barrier, we do not
> > - * need to add smp_mb()s for this to work. It is also considered
> > - * that we can not read the modifying_ftrace_code before
> > - * executing the breakpoint. That would be quite remarkable if
> > - * it could do that. Here's the flow that is required:
> > - *
> > - *   CPU-0                          CPU-1
> > - *
> > - * atomic_inc(mfc);
> > - * write int3s
> > - *				<trap-int3> // implicit (r)mb
> > - *				if (atomic_read(mfc))
> > - *					call ftrace_int3_handler()
> > - *
> > - * Then when we are finished:
> > - *
> > - * atomic_dec(mfc);
> > - *
> > - * If we hit a breakpoint that was not set by ftrace, it does not
> > - * matter if ftrace_int3_handler() is called or not. It will
> > - * simply be ignored. But it is crucial that a ftrace nop/caller
> > - * breakpoint is handled. No other user should ever place a
> > - * breakpoint on an ftrace nop/caller location. It must only
> > - * be done by this code.
> > - */
> 
> The above is a nice comment. It should be copied over to the
> alternative.c file for the explanation of bp_patching_in_progress.

Well, text_poke is using barriers instead of the atomic variable. I
think that the barriers have two functions in text_poke stuff:

1) make sure that "bp_patching_in_progress" is enabled before the
breakpoint is added; it means that "poke_int3_handler" is opened to
handle the address before the related trap happens.

2) make sure that the variables, e.g. bp_int3_handler, bp_int3_add, have
correct values before they are accessed in "poke_int3_handler".

I think that the atomic variable has only the 1st function. It does not
solve synchronization of the other variables. I thin that it was not a
problem in ftrace because it patched almost static list of addresses
but it might be problem in the generic text_poke_bp.

> > -atomic_t modifying_ftrace_code __read_mostly;
> > -
> > -/*
> >   * Should never be called:
> >   *  As it is only called by __ftrace_replace_code() which is called by
> >   *  ftrace_replace_code() that x86 overrides, and by ftrace_update_code()


Best Regards,
Petr


