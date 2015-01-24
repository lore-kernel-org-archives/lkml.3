Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbbAXVog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 16:44:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:41335 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbbAXVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 16:44:34 -0500
Date: Sat, 24 Jan 2015 22:44:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>
Subject: Re: [PATCH 3.19-rc2 v15 5/8] printk: Simple implementation for NMI
 backtracing
In-Reply-To: <1422022952-31552-6-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.DEB.2.11.1501242105230.5526@nanos>
References: <1422022952-31552-1-git-send-email-daniel.thompson@linaro.org> <1422022952-31552-6-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Daniel Thompson wrote:
> +#ifdef CONFIG_ARCH_WANT_NMI_PRINTK
> +extern __printf(1, 0) int nmi_vprintk(const char *fmt, va_list args);
> +
> +struct cpumask;
> +extern int prepare_nmi_printk(struct cpumask *cpus);
> +extern void complete_nmi_printk(struct cpumask *cpus);
> +
> +/*
> + * Replace printk to write into the NMI seq.
> + *
> + * To avoid include hell this is a macro rather than an inline function
> + * (printk_func is not declared in this header file).
> + */
> +#define this_cpu_begin_nmi_printk() ({ \
> +	printk_func_t __orig = this_cpu_read(printk_func); \
> +	this_cpu_write(printk_func, nmi_vprintk); \
> +	__orig; \
> +})
> +#define this_cpu_end_nmi_printk(fn) this_cpu_write(printk_func, fn)

Why can't we just make it a proper function in printk.c and make
DEFINE_PER_CPU(printk_func_t, printk_func) static once x86 is
converted over, thereby getting rid of the misplaced declaration in
percpu.h?

It's really not performance critical at all. If you do system wide
backtraces a function call is the least of your worries.

> +#ifdef CONFIG_ARCH_WANT_NMI_PRINTK

Why can't this simply be CONFIG_PRINTK_NMI and live at the same place
as the other printk related options?

> +int nmi_vprintk(const char *fmt, va_list args)
> +{
> +	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
> +	unsigned int len = seq_buf_used(&s->seq);
> +
> +	seq_buf_vprintf(&s->seq, fmt, args);
> +	return seq_buf_used(&s->seq) - len;
> +}
> +EXPORT_SYMBOL_GPL(nmi_vprintk);

What's the point of these exports? This stuff is really not supposed
to be used inside random modules.

> +/*
> + * Check for concurrent usage and set up per_cpu seq_buf buffers that the NMIs
> + * running on the other CPUs will write to. Provides the mask of CPUs it is
> + * safe to write from (i.e. a copy of the online mask).
> + */
> +int prepare_nmi_printk(struct cpumask *cpus)

Can we please make all this proper prefixed? , i.e. printk_nmi_*

> +{
> +	struct nmi_seq_buf *s;
> +	int cpu;
> +
> +	if (test_and_set_bit(0, &nmi_print_flag)) {
> +		/*
> +		 * If something is already using the NMI print facility we
> +		 * can't allow a second one...
> +		 */
> +		return -EBUSY;

So what's the point of saving and restoring the printk_func pointer at
the call site?

void printk_nmi_begin()
{
	if (__this_cpu_inc_return(nmi_printk_nest_level) == 1)
	      this_cpu_write(printk_func, nmi_vprintk);
}

void printk_nmi_end()
{
	if (__this_cpu_dec_return(nmi_printk_nest_level) > 0)
	        return;
        this_cpu_write(printk_func, default_vprintk);
	if (in_nmi())
		irq_work_schedule();
        else
		printk_nmi_complete();
}

> +	}
> +
> +	cpumask_copy(cpus, cpu_online_mask);

Why do you need external storage for this if nesting is not allowed?
What's wrong with having a printk_nmi_mask? It's protected by the
nmi_print_flag, so the call sites do not have to take care about
protecting it until printk_nmi_complete() has been invoked.

> +	for_each_cpu(cpu, cpus) {
> +		s = &per_cpu(nmi_print_seq, cpu);
> +		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);

Why do you want to do this here? The buffers should be initialized
before the first NMI can hit and the complete code should reinit them
before the next printk_nmi_prepare() sees the nmi_print_flag cleared.

> +static void print_seq_line(struct nmi_seq_buf *s, int start, int end)
> +{
> +	const char *buf = s->buffer + start;
> +
> +	printk("%.*s", (end - start) + 1, buf);
> +}
> +
> +void complete_nmi_printk(struct cpumask *cpus)
> +{
> +	struct nmi_seq_buf *s;
> +	int len;
> +	int cpu;
> +	int i;

Please condense all ints to a single line, but what's worse is the
completely inconsistency versus scopes.

len and i are only used in the for_each loop. Either we put all of
them at the top of the function or we do it right.

Thanks,

	tglx
