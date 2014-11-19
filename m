Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbaKSKlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:41:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53257 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbaKSKlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:41:19 -0500
Date: Wed, 19 Nov 2014 11:41:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC][PATCH 3/3] x86/nmi: Perform a safe NMI stack trace on all
 CPUs
Message-ID: <20141119104114.GA5684@pd.tnic>
References: <20141119043917.578498291@goodmis.org>
 <20141119045556.084787418@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141119045556.084787418@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:39:20PM -0500, Steven Rostedt wrote:
>  static int
>  arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
>  {
> @@ -78,12 +157,14 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
>  	cpu = smp_processor_id();
>  
>  	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
> -		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
> +		printk_func_t printk_func_save = this_cpu_read(printk_func);
>  
> -		arch_spin_lock(&lock);
> +		/* Replace printk to write into the NMI seq */
> +		this_cpu_write(printk_func, nmi_vprintk);
>  		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
>  		show_regs(regs);
> -		arch_spin_unlock(&lock);
> +		this_cpu_write(printk_func, printk_func_save);

I'm wondering if this could be used in a generic manner throughout code
where we could say "ok, I'm in an NMI context, so lemme switch printk's
and do some printing" so that NMI and NMI-like atomic contexts could use
printk. Lemme do an mce example:

do_machine_check(..)
{
	printk_func_t printk_func_save = this_cpu_read(printk_func);

	...

	/* in #MC handler, switch printks */
	this_cpu_write(printk_func, nmi_vprintk);

	printk("This is a hw error, details: ...\n");

	/* more bla */

	this_cpu_write(printk_func, printk_func_save);
}

or should we change that in entry.S, before we call the handler?

Because, if we could do something like that, then we finally get to use
printk in an NMI context which would be a good thing.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
