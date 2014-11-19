Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaKSNDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:03:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbaKSNC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:02:58 -0500
Date: Wed, 19 Nov 2014 14:02:50 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC][PATCH 3/3] x86/nmi: Perform a safe NMI stack trace on all
 CPUs
Message-ID: <20141119130250.GA5007@dhcp128.suse.cz>
References: <20141119043917.578498291@goodmis.org>
 <20141119045556.084787418@goodmis.org>
 <20141119104114.GA5684@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119104114.GA5684@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-19 11:41:14, Borislav Petkov wrote:
> On Tue, Nov 18, 2014 at 11:39:20PM -0500, Steven Rostedt wrote:
> >  static int
> >  arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
> >  {
> > @@ -78,12 +157,14 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
> >  	cpu = smp_processor_id();
> >  
> >  	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
> > -		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
> > +		printk_func_t printk_func_save = this_cpu_read(printk_func);
> >  
> > -		arch_spin_lock(&lock);
> > +		/* Replace printk to write into the NMI seq */
> > +		this_cpu_write(printk_func, nmi_vprintk);
> >  		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
> >  		show_regs(regs);
> > -		arch_spin_unlock(&lock);
> > +		this_cpu_write(printk_func, printk_func_save);
> 
> I'm wondering if this could be used in a generic manner throughout code
> where we could say "ok, I'm in an NMI context, so lemme switch printk's
> and do some printing" so that NMI and NMI-like atomic contexts could use
> printk. Lemme do an mce example:
> 
> do_machine_check(..)
> {
> 	printk_func_t printk_func_save = this_cpu_read(printk_func);
> 
> 	...
> 
> 	/* in #MC handler, switch printks */
> 	this_cpu_write(printk_func, nmi_vprintk);
> 
> 	printk("This is a hw error, details: ...\n");
> 
> 	/* more bla */
> 
> 	this_cpu_write(printk_func, printk_func_save);
> }
> 
> or should we change that in entry.S, before we call the handler?
> 
> Because, if we could do something like that, then we finally get to use
> printk in an NMI context which would be a good thing.

Unfortunately, the problem is more complicated. The alternative
printk_func() just stores the string into the seq_buf. Then someone
needs to move the data to the main ring buffer, see print_seq_line()
and the related cycle in this patch.

The copying needs to be done in the normal context because it will
need to take the lock for the main ring buffer. Then it will need to
somehow protect the seq_buf against other accesses from NMI context.

By other words, any serious generic solution would end up with implementing
an alternative ring buffer and lockless operations. It would be
something similar to my older patch set, see
https://lkml.org/lkml/2014/5/9/118. It was not
accepted and it triggered this solution for NMI backtraces.

Note that this patch works because arch_trigger_all_cpu_backtrace() is
called from normal context and any further calls are ignored until the
current call is finished. So, there is a safe place to copy the data.


I have another idea for the generic solution. Linus was against using
printk() in NMI context, see https://lkml.org/lkml/2014/6/10/388.
The backtraces are the only serious usage. Other than
that there are only few warnings. My proposal is to handle the
warnings similar way like recursive printk() warning. The recursive
printk() just sets a flag, the message is dropped, warning about lost
message is printed within the next printk() call.

Best Regards,
Petr
