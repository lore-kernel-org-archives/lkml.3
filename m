Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaAUNu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:50:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbaAUNuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:50:17 -0500
Subject: Re: [PATCH v6 3/8] x86: add generic function to modify more calls
 using int3 framework
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <20140114193338.4375f205@gandalf.local.home>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	 <1386690140-19941-4-git-send-email-pmladek@suse.cz>
	 <20140114193338.4375f205@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jan 2014 14:50:15 +0100
Message-ID: <1390312215.14199.60.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 19:33 -0500, Steven Rostedt wrote:
> On Tue, 10 Dec 2013 16:42:15 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> > index 6436beec7b0c..8e57ac03a0e8 100644
> > --- a/arch/x86/kernel/alternative.c
> > +++ b/arch/x86/kernel/alternative.c
> > @@ -621,14 +625,23 @@ int poke_int3_handler(struct pt_regs *regs)
> >  	if (likely(!bp_patching_in_progress))
> >  		return 0;
> >  
> > -	if (user_mode_vm(regs) || regs->ip != (unsigned long)bp_int3_addr)
> > +	if (user_mode_vm(regs))
> >  		return 0;
> >  
> > -	/* set up the specified breakpoint handler */
> > -	regs->ip = (unsigned long) bp_int3_handler;
> > +	/* Check if address is handled by text_poke_bp */
> > +	if (bp_int3_handler && regs->ip == (unsigned long)bp_int3_addr) {
> > +		regs->ip = (unsigned long)bp_int3_handler;
> > +		return 1;
> > +	}
> >  
> > -	return 1;
> > +	/* Check if address is handled by text_poke_bp_list */
> > +	if (bp_int3_is_handled && bp_int3_is_handled(regs->ip)) {
> > +		/* just skip the instruction */
> > +		regs->ip += bp_int3_len - 1;
> > +		return 1;
> > +	}
> >  
> > +	return 0;
> >  }
> >  
> >  /**
> > @@ -655,11 +668,13 @@ int poke_int3_handler(struct pt_regs *regs)
> >   */
> >  int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
> >  {
> > -	unsigned char int3 = 0xcc;
> > -	int ret = 0;
> > +	int ret;
> >  
> > +	bp_int3 = 0xcc;
> 
> We could remove this as it should be constant.
> 
> >  	bp_int3_handler = handler;
> > -	bp_int3_addr = (u8 *)addr + sizeof(int3);
> > +	bp_int3_addr = (u8 *)addr + sizeof(bp_int3);
> > +	bp_int3_len = len;
> > +	bp_int3_is_handled = NULL;
> >  	bp_patching_in_progress = true;
> >  	/*
> >  	 * Corresponding read barrier in int3 notifier for
> > @@ -668,20 +683,20 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
> >  	 */
> >  	smp_wmb();
> >  
> > -	ret = text_poke(addr, &int3, sizeof(int3));
> > +	ret = text_poke(addr, &bp_int3, sizeof(bp_int3));
> >  	if (unlikely(ret))
> >  		goto fail;
> >  
> >  	run_sync();
> >  
> > -	if (len - sizeof(int3) > 0) {
> > +	if (len - sizeof(bp_int3) > 0) {
> >  		/*
> >  		 * Patch all but the first byte. We do not know how to recover
> >  		 * from an error at this stage.
> >  		 */
> > -		text_poke_or_die((char *)addr + sizeof(int3),
> > -				 (const char *) opcode + sizeof(int3),
> > -				 len - sizeof(int3));
> > +		text_poke_or_die((char *)addr + sizeof(bp_int3),
> > +				 (const char *) opcode + sizeof(bp_int3),
> > +				 len - sizeof(bp_int3));
> >  		/*
> >  		 * According to Intel, this core syncing is very likely
> >  		 * not necessary and we'd be safe even without it. But
> > @@ -691,7 +706,7 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
> >  	}
> >  
> >  	/* Patch the first byte. We do not know how to recover from an error. */
> > -	text_poke_or_die(addr, opcode, sizeof(int3));
> > +	text_poke_or_die(addr, opcode, sizeof(bp_int3));
> >  
> >  	run_sync();
> 
> Shouldn't we be setting the bp_int3_handler back to NULL here?

It might be cleaner but it is not really needed. "poke_int3_handler()"
checks "bp_int3_handler" only when "bp_patching_in_progress" is enabled.
The "in_progress" variable is disabled right after the above mentioned
"run_sync()", so we are on the safe side.

Note that the original "text_poke_bp()" implementation disabled only the
"in_progress" variable at the end as well.


> > +static int add_iter_breakpoint(struct text_poke_bp_iter *iterator,
> > +				       void *iter)
> > +{
> > +	void *addr;
> > +	const void *old_opcode;
> > +	int ret = 0;
> > +
> > +	/* nope if the code is not defined */
> 
> The above comment does not make sense.

It is here to handle the situation when "ftrace_test_record(rec,
enable)" returns FTRACE_UPDATE_IGNORE. In this case, even the original
implementation does not add the breakpoint.

I did not want to confuse the universal implementation with extra flags.
Instead, I passed NULL "old_code" pointer when the patching was not
needed for this particular address.

I agree that it might be a bit confusing. The question is whether it is
enough to improve documentation or rather use an extra flag or so.

I am going to improve the comments unless you say otherwise.

> 
> > +	old_opcode = iterator->get_old_opcode(iter);
> > +	if (!old_opcode)
> > +		return 0;
> > +
> > +	addr = iterator->get_addr(iter);
> > +	ret = text_poke_check(addr, old_opcode, bp_int3_len);
> > +
> > +	if (likely(!ret))
> > +		/* write the breakpoint */
> 
> Comment is redundant and can be removed.
> 
> > +		ret = text_poke(addr, &bp_int3, sizeof(bp_int3));
> > +
> > +	return ret;
> > +}
> > +
> > +static int update_iter_code(struct text_poke_bp_iter *iterator,
> > +				   void *iter)
> > +{
> > +	void *addr;
> > +	const void *opcode;
> > +
> > +	/* nope if the code is not defined */
> 
> Still does not make sense :-)

It is the same reason/trick that is used in "add_iter_breakpoint()".
NULL code pointer means that we actually do not want to patch this
particular address.

The rest of your comments is clear. I am updating the patch set. Thanks
a lot for feedback.


Best Regards,
Petr

