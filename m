Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbbAZRVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:21:09 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35659 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbbAZRVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:21:07 -0500
Message-ID: <54C67781.5070602@linaro.org>
Date: Mon, 26 Jan 2015 17:21:05 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
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
References: <1422022952-31552-1-git-send-email-daniel.thompson@linaro.org> <1422022952-31552-6-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1501242105230.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501242105230.5526@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/15 21:44, Thomas Gleixner wrote:
> On Fri, 23 Jan 2015, Daniel Thompson wrote:
>> +#ifdef CONFIG_ARCH_WANT_NMI_PRINTK
>> +extern __printf(1, 0) int nmi_vprintk(const char *fmt, va_list args);
>> +
>> +struct cpumask;
>> +extern int prepare_nmi_printk(struct cpumask *cpus);
>> +extern void complete_nmi_printk(struct cpumask *cpus);
>> +
>> +/*
>> + * Replace printk to write into the NMI seq.
>> + *
>> + * To avoid include hell this is a macro rather than an inline function
>> + * (printk_func is not declared in this header file).
>> + */
>> +#define this_cpu_begin_nmi_printk() ({ \
>> +	printk_func_t __orig = this_cpu_read(printk_func); \
>> +	this_cpu_write(printk_func, nmi_vprintk); \
>> +	__orig; \
>> +})
>> +#define this_cpu_end_nmi_printk(fn) this_cpu_write(printk_func, fn)
> 
> Why can't we just make it a proper function in printk.c and make
> DEFINE_PER_CPU(printk_func_t, printk_func) static once x86 is
> converted over, thereby getting rid of the misplaced declaration in
> percpu.h?
> 
> It's really not performance critical at all. If you do system wide
> backtraces a function call is the least of your worries.

Yes. I'll make this a proper function.

Not sure about tidying up printk_func though. I had hoped to use that to
get rid of CONFIG_KGGB_KDB ifdef's that are currently found in printk.c .


>> +#ifdef CONFIG_ARCH_WANT_NMI_PRINTK
> 
> Why can't this simply be CONFIG_PRINTK_NMI and live at the same place
> as the other printk related options?

Will do.


>> +int nmi_vprintk(const char *fmt, va_list args)
>> +{
>> +	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
>> +	unsigned int len = seq_buf_used(&s->seq);
>> +
>> +	seq_buf_vprintf(&s->seq, fmt, args);
>> +	return seq_buf_used(&s->seq) - len;
>> +}
>> +EXPORT_SYMBOL_GPL(nmi_vprintk);
> 
> What's the point of these exports? This stuff is really not supposed
> to be used inside random modules.

Will do.


>> +/*
>> + * Check for concurrent usage and set up per_cpu seq_buf buffers that the NMIs
>> + * running on the other CPUs will write to. Provides the mask of CPUs it is
>> + * safe to write from (i.e. a copy of the online mask).
>> + */
>> +int prepare_nmi_printk(struct cpumask *cpus)
> 
> Can we please make all this proper prefixed? , i.e. printk_nmi_*

Will do.


>> +{
>> +	struct nmi_seq_buf *s;
>> +	int cpu;
>> +
>> +	if (test_and_set_bit(0, &nmi_print_flag)) {
>> +		/*
>> +		 * If something is already using the NMI print facility we
>> +		 * can't allow a second one...
>> +		 */
>> +		return -EBUSY;
> 
> So what's the point of saving and restoring the printk_func pointer at
> the call site?
> 
> void printk_nmi_begin()
> {
> 	if (__this_cpu_inc_return(nmi_printk_nest_level) == 1)
> 	      this_cpu_write(printk_func, nmi_vprintk);
> }
> 
> void printk_nmi_end()
> {
> 	if (__this_cpu_dec_return(nmi_printk_nest_level) > 0)
> 	        return;
>         this_cpu_write(printk_func, default_vprintk);

Looks good to here.


> 	if (in_nmi())
> 		irq_work_schedule();
>         else
> 		printk_nmi_complete();
> }

Not sure about using irq_work here. arch_trigger_all_cpu_backtrace is
generally called when something's gone bad meaning there's a good chance
the interrupts are masked.


> 
>> +	}
>> +
>> +	cpumask_copy(cpus, cpu_online_mask);
> 
> Why do you need external storage for this if nesting is not allowed?
> What's wrong with having a printk_nmi_mask? It's protected by the
> nmi_print_flag, so the call sites do not have to take care about
> protecting it until printk_nmi_complete() has been invoked.

It was used to tell the caller which CPUs are initialized and allowed to
trace...

On reflection though that's a rather pointless optimization. Given the
quantity of data we're about to throw on the console I can't really see
any reason not to use for_each_possible_cpu() for initialization and
leave the caller to figure out which cores to send IPIs to.


>> +	for_each_cpu(cpu, cpus) {
>> +		s = &per_cpu(nmi_print_seq, cpu);
>> +		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);
> 
> Why do you want to do this here? The buffers should be initialized
> before the first NMI can hit and the complete code should reinit them
> before the next printk_nmi_prepare() sees the nmi_print_flag cleared.

To be honest I inherited the just-in-time initialization from Steven's code.

Assuming Steven didn't have a special reason to do it like that then I'm
happy to change this.


>> +static void print_seq_line(struct nmi_seq_buf *s, int start, int end)
>> +{
>> +	const char *buf = s->buffer + start;
>> +
>> +	printk("%.*s", (end - start) + 1, buf);
>> +}
>> +
>> +void complete_nmi_printk(struct cpumask *cpus)
>> +{
>> +	struct nmi_seq_buf *s;
>> +	int len;
>> +	int cpu;
>> +	int i;
> 
> Please condense all ints to a single line, but what's worse is the
> completely inconsistency versus scopes.
> 
> len and i are only used in the for_each loop. Either we put all of
> them at the top of the function or we do it right.

Will do.
