Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaKFSmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:42:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaKFSmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:42:02 -0500
Date: Thu, 6 Nov 2014 19:41:55 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 12/12 v3] x86/nmi: Perform a safe NMI stack trace on
 all CPUs
Message-ID: <20141106184155.GB28294@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160223.310714394@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104160223.310714394@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-04 10:52:49, Steven Rostedt wrote:
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
> ---
>  arch/x86/kernel/apic/hw_nmi.c | 90 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 85 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index 6a1e71bde323..6e7bb0bc6fcd 100644
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
> @@ -29,14 +30,35 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh)
>  #ifdef arch_trigger_all_cpu_backtrace
>  /* For reliability, we're prepared to waste bits here. */
>  static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
> +static cpumask_var_t printtrace_mask;
> +
> +#define NMI_BUF_SIZE		4096
> +
> +struct nmi_seq_buf {
> +	unsigned char		buffer[NMI_BUF_SIZE];
> +	struct seq_buf		seq;
> +};
> +
> +/* Safe printing in NMI context */
> +static DEFINE_PER_CPU(struct nmi_seq_buf, nmi_print_seq);
>  
>  /* "in progress" flag of arch_trigger_all_cpu_backtrace */
>  static unsigned long backtrace_flag;
>  
> +static void print_seq_line(struct nmi_seq_buf *s, int last, int pos)

I would rename the arguments:

	"last -> first"
	"pos -> last"

or maybe better would be to pass first positon and len.

> +{
> +	const char *buf = s->buffer + last;
> +
> +	printk("%.*s", (pos - last) + 1, buf);
> +}


> +{
> +	const char *buf = s->buffer + last;
> +
> +	printk("%.*s", (pos - last) + 1, buf);
> +}
> +
>  void arch_trigger_all_cpu_backtrace(bool include_self)
>  {
> +	struct nmi_seq_buf *s;
> +	int len;
> +	int cpu;
>  	int i;
> -	int cpu = get_cpu();
> +	int this_cpu = get_cpu();
>  
>  	if (test_and_set_bit(0, &backtrace_flag)) {
>  		/*
> @@ -49,7 +71,17 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
>  
>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>  	if (!include_self)
> -		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
> +		cpumask_clear_cpu(this_cpu, to_cpumask(backtrace_mask));
> +
> +	cpumask_copy(printtrace_mask, to_cpumask(backtrace_mask));
> +	/*
> +	 * Set up per_cpu seq_buf buffers that the NMIs running on the other
> +	 * CPUs will write to.
> +	 */
> +	for_each_cpu(cpu, to_cpumask(backtrace_mask)) {
> +		s = &per_cpu(nmi_print_seq, cpu);
> +		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);
> +	}
 >  
>  	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
>  		pr_info("sending NMI to %s CPUs:\n",
> @@ -65,11 +97,57 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
>  		touch_softlockup_watchdog();
>  	}
>  
> +	/*
> +	 * Now that all the NMIs have triggered, we can dump out their
> +	 * back traces safely to the console.
> +	 */
> +	for_each_cpu(cpu, printtrace_mask) {
> +		int last_i = 0;
> +
> +		s = &per_cpu(nmi_print_seq, cpu);
> +		len = s->seq.len;

If there is an seq_buf overflow, the len might be size + 1, so we need to do:

		len = min(s->seq.len, s->size);

Well, we should create a function for this in seq_buf.h.
Alternatively, we might reconsider the overflow state,
use len == size and extra "overflow" flag in the seq_buf struct.


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
>
> +		if (last_i < i - 1) {

IMHO, this should be:

		if (last_i < i)

because last_i = i + 1. Otherwise, we would ignore state when there is
one character after a new line. For example, imagine the following:

	buffer = "a\nb";
	len = 3;

it will end with:

	last_i = 2;
	i = 3;

and we still need to print the "b".

> +			print_seq_line(s, last_i, i);

If I get it correctly, (i == len) here and "printk_seq_line"
print_seq_line() prints the characters including "pos" value.
So, we should call:

			print_seq_line(s, last_i, i - 1)

> +			pr_cont("\n");
> +		}
> +	}
> +

I hope that I have got it correctly. It is getting late here and I
feel tired to see the off-by-one problems clearly ;-)

Best Regards,
Petr
