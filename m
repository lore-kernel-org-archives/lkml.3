Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaFWQM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:12:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45808 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbaFWQMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:12:20 -0400
Date: Mon, 23 Jun 2014 09:12:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 3/3] x86/nmi: Perform a safe NMI stack trace on all
 CPUs
Message-ID: <20140623161216.GB23817@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140619213329.478113470@goodmis.org>
 <20140619213952.360076309@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619213952.360076309@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062316-6688-0000-0000-000002C38CAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 05:33:32PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When trigger_all_cpu_backtrace() is called on x86, it will trigger an
> NMI on each CPU and call show_regs(). But this can lead to a hard lock
> up if the NMI comes in on another printk().
> 
> In order to avoid this, when the NMI triggers, it switches the printk
> routine for that CPU to call a NMI safe printk function that records the
> printk in a per_cpu trace_seq descriptor. After all NMIs have finished
> recording its data, the trace_seqs are printed in a safe context.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

I do like the idea of safe printk from NMI, so given the changes later
in this thread:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/apic/hw_nmi.c | 66 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 62 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index c3fcb5de5083..6731604bb1cd 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -18,6 +18,7 @@
>  #include <linux/nmi.h>
>  #include <linux/module.h>
>  #include <linux/delay.h>
> +#include <linux/trace_seq.h>
>  
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  u64 hw_nmi_get_sample_period(int watchdog_thresh)
> @@ -30,11 +31,30 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh)
>  /* For reliability, we're prepared to waste bits here. */
>  static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
>  
> +/* Safe printing in NMI context */
> +static DEFINE_PER_CPU(struct trace_seq, nmi_print_seq);
> +
>  /* "in progress" flag of arch_trigger_all_cpu_backtrace */
>  static unsigned long backtrace_flag;
>  
> +static void print_seq_line(struct trace_seq *s, int last, int pos)
> +{
> +	const char *buf = s->buffer + last;
> +
> +	/* Chop off the saved log level and update the length */
> +	if (printk_get_level(buf)) {
> +		buf += 2;
> +		last += 2;
> +	}
> +
> +	pr_emerg("%.*s", (pos - last) + 1, buf);
> +}
> +
>  void arch_trigger_all_cpu_backtrace(void)
>  {
> +	struct trace_seq *s;
> +	int len;
> +	int cpu;
>  	int i;
>  
>  	if (test_and_set_bit(0, &backtrace_flag))
> @@ -44,6 +64,11 @@ void arch_trigger_all_cpu_backtrace(void)
>  		 */
>  		return;
>  
> +	for_each_possible_cpu(i) {
> +		s = &per_cpu(nmi_print_seq, i);
> +		trace_seq_init(s);
> +	}
> +
>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>  
>  	printk(KERN_INFO "sending NMI to all CPUs:\n");
> @@ -56,8 +81,39 @@ void arch_trigger_all_cpu_backtrace(void)
>  		mdelay(1);
>  	}
>  
> +	for_each_possible_cpu(cpu) {
> +		int last_i = 0;
> +
> +		s = &per_cpu(nmi_print_seq, cpu);
> +		len = s->len;
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
> +	return true;
> +}
> +
> +static int nmi_vprintk(const char *fmt, va_list args)
> +{
> +	struct trace_seq *s = this_cpu_ptr(&nmi_print_seq);
> +	int len = s->len;
> +
> +	trace_seq_vprintf(s, fmt, args);
> +	return s->len - len;
>  }
>  
>  static int
> @@ -68,12 +124,14 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
>  	cpu = smp_processor_id();
>  
>  	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
> -		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
> +		printk_func_t printk_func_save = this_cpu_read(printk_func);
>  
> -		arch_spin_lock(&lock);
> -		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
> +		/* Replace printk to write into the NMI seq */
> +		this_cpu_write(printk_func, nmi_vprintk);
> +		printk("NMI backtrace for cpu %d\n", cpu);
>  		show_regs(regs);
> -		arch_spin_unlock(&lock);
> +		this_cpu_write(printk_func, printk_func_save);
> +
>  		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
>  		return NMI_HANDLED;
>  	}
> -- 
> 2.0.0.rc2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

