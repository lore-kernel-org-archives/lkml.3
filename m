Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaF0Ocv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:32:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF0Oct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:32:49 -0400
Date: Fri, 27 Jun 2014 16:32:46 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 5/5 v2] x86/nmi: Perform a safe NMI stack trace on
 all CPUs
Message-ID: <20140627143246.GE23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
 <20140626220130.764213722@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140626220130.764213722@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-26 17:49:06, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When trigger_all_cpu_backtrace() is called on x86, it will trigger an
> NMI on each CPU and call show_regs(). But this can lead to a hard lock
> up if the NMI comes in on another printk().
> 
> In order to avoid this, when the NMI triggers, it switches the printk
> routine for that CPU to call a NMI safe printk function that records the
> printk in a per_cpu seq_buf descriptor. After all NMIs have finished
> recording its data, the trace_seqs are printed in a safe context.
> 
> Link: http://lkml.kernel.org/p/20140619213952.360076309@goodmis.org
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

It seems to work very well.

Tested-by: Petr Mladek <pmladek@suse.cz>

See one comment below.

> ---
> V2 - updated to use seq_buf instead of trace_seq.
>    - Keep original printk loglevel, do not strip it, but use it.
>      (suggested by Petr Mládek)
>    - Updated comments
>    - Removed return of true (noticed by Petr Mládek)
> ---
>  arch/x86/kernel/apic/hw_nmi.c | 84 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 81 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index c3fcb5de5083..91ddba672839 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -18,6 +18,7 @@
>  #include <linux/nmi.h>
>  #include <linux/module.h>
>  #include <linux/delay.h>
> +#include <linux/seq_buf.h>
>  
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  u64 hw_nmi_get_sample_period(int watchdog_thresh)
> @@ -30,11 +31,31 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh)
>  /* For reliability, we're prepared to waste bits here. */
>  static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
>  
> +#define NMI_BUF_SIZE		4096
> +
> +struct nmi_seq_buf {
> +	unsigned char		buffer[NMI_BUF_SIZE];
> +	struct seq_buf		seq;
> +};
> +
> +/* Safe printing in NMI context */
> +static DEFINE_PER_CPU(struct nmi_seq_buf, nmi_print_seq);
> +
>  /* "in progress" flag of arch_trigger_all_cpu_backtrace */
>  static unsigned long backtrace_flag;
>  
> +static void print_seq_line(struct nmi_seq_buf *s, int last, int pos)
> +{
> +	const char *buf = s->buffer + last;
> +
> +	printk("%.*s", (pos - last) + 1, buf);
> +}
> +
>  void arch_trigger_all_cpu_backtrace(void)
>  {
> +	struct nmi_seq_buf *s;
> +	int len;
> +	int cpu;
>  	int i;
>  
>  	if (test_and_set_bit(0, &backtrace_flag))
> @@ -44,6 +65,15 @@ void arch_trigger_all_cpu_backtrace(void)
>  		 */
>  		return;
>  
> +	/*
> +	 * Set up per_cpu seq_buf buffers that the NMIs running on the other
> +	 * CPUs will write to.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		s = &per_cpu(nmi_print_seq, cpu);
> +		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);
> +	}
> +
>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>  
>  	printk(KERN_INFO "sending NMI to all CPUs:\n");
> @@ -56,10 +86,56 @@ void arch_trigger_all_cpu_backtrace(void)
>  		mdelay(1);
>  	}
>  
> +	/*
> +	 * Now that all the NMIs have triggered, we can dump out their
> +	 * back traces safely to the console.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		int last_i = 0;
> +
> +		s = &per_cpu(nmi_print_seq, cpu);
> +		len = s->seq.len;
> +		if (!len)
> +			continue;
> +
> +		/* Print line by line. */
> +		for (i = 0; i < len; i++) {
> +			if (s->buffer[i] == '\n') {
> +				print_seq_line(s, last_i, i);
> +				last_i = i + 1;
> +			}
> +		}
> +		if (last_i < i - 1) {
> +			print_seq_line(s, last_i, i);
> +			pr_cont("\n");
> +		}
> +	}
> +
>  	clear_bit(0, &backtrace_flag);
>  	smp_mb__after_atomic();
>  }
>  
> +/*
> + * It is not safe to call printk() directly from NMI handlers.
> + * It may be fine if the NMI detected a lock up and we have no choice
> + * but to do so, but doing a NMI on all other CPUs to get a back trace
> + * can be done with a sysrq-l. We don't want that to lock up, which
> + * can happen if the NMI interrupts a printk in progress.
> + *
> + * Instead, we redirect the vprintk() to this nmi_vprintk() that writes
> + * the content into a per cpu seq_buf buffer. Then when the NMIs are
> + * all done, we can safely dump the contents of the seq_buf to a printk()
> + * from a non NMI context.
> + */

I would move this comment above #define NMI_BUF_SIZE
It should be on top because it helps to understand many other tricks that are
used above.

Regards,
Petr

> +static int nmi_vprintk(const char *fmt, va_list args)
> +{
> +	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
> +	unsigned int len = s->seq.len;
> +
> +	seq_buf_vprintf(&s->seq, fmt, args);
> +	return s->seq.len - len;
> +}
> +
>  static int
>  arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
>  {
> @@ -68,12 +144,14 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
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
> +
>  		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
>  		return NMI_HANDLED;
>  	}
> -- 
> 2.0.0
> 
> 
