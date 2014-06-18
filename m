Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113AbaFRIbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:31:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182AbaFRIbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:31:07 -0400
Date: Wed, 18 Jun 2014 10:31:02 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Joe Perches <joe@perches.com>,
        Arun KS <arunks.linux@gmail.com>, Kees Cook <keescook@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFT v5h printk: allow increasing the ring buffer depending on
 the number of CPUs
Message-ID: <20140618083102.GF634@pathway.suse.cz>
References: <1402965464-11202-1-git-send-email-mcgrof@do-not-panic.com>
 <20140617145200.GA634@pathway.suse.cz>
 <20140618001816.GK4841@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140618001816.GK4841@wotan.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-06-18 02:18:16, Luis R. Rodriguez wrote:
> On Tue, Jun 17, 2014 at 04:52:01PM +0200, Petr Mládek wrote:
> > On Mon 2014-06-16 17:37:44, Luis R. Rodriguez wrote:
> > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > > index ea2d5f6..54632a0c 100644
> > > --- a/kernel/printk/printk.c
> > > +++ b/kernel/printk/printk.c
> > > @@ -842,20 +905,56 @@ static int __init log_buf_len_setup(char *str)
> > >  }
> > >  early_param("log_buf_len", log_buf_len_setup);
> > >  
> > > +static unsigned __init compute_cpu_contrib(void)
> > 
> > The function name is slightly misleading. It does not compute the
> > extra space but the whole length of the ring buffer. What about using
> > default_len_by_cpu_num() or so?
> 
> Sure.
> 
> > > +{
> > > +	int cpu_extra;
> > > +	unsigned extra_cpu_log_size;
> > > +
> > > +	/*
> > > +	 * archs should set up cpu_possible_bits properly with
> > > +	 * set_cpu_possible() after setup_arch() but just in
> > > +	 * case lets ensure this is valid.
> > > +	 */
> > > +	if (num_possible_cpus() <= 1)
> > > +		return 0;
> > > +
> > > +	cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MIN_BUF_LEN;
> > > +	extra_cpu_log_size = roundup_pow_of_two(cpu_extra +
> > > __LOG_BUF_LEN);
> > 
> > Great catch. Well, I am not sure if this is really
> > needed. memblock_virt_alloc() is called on another locations with "any" size.
> 
> Ok, on the other hand using roundup_pow_of_two() would guarantee both general
> alignment and upkeeping the tradition of having a ring buffer as a power of
> two. I think the implicit trick here was that alignment is ensured by
> becauase __LOG_BUF_LEN would be aligned to the architecture already as its
> an architecture specific value, furthermore no value smaller than this would
> be allowed and since we're doing power of two's any further extra multiplication
> by two should be aligned to the architecture. That should also mean that we
> wouldn't have to care for the size of log_buf_add_cpu in consideration for
> the archicture alignment as its already done for us.
> 
> cpu_extra &= ~(LOG_ALIGN - 1); seems fair to me as well if we want to save
> some bytes, it probably does no harm if we bumped to the next power of two
> and and we could shared aligning code to make this explicit.
> 
> I'll let you make the call as you'd know more than me of the requirements
> here I'm sure.

I do not have any strong opinion here. Let's use roundup_pow_of_two()
for now. It is easier and should not cause any harm.

[...]

> > > +
> > > +	if (cpu_extra <= __LOG_BUF_LEN / 2)
> > > +		return 0;
> > > +
> > > +	pr_info("log_buf_len cpu_extra contribution: %d\n", cpu_extra);
> > > +	pr_info("log_buf_len min size: %d\n", __LOG_BUF_LEN);
> > > +
> > > +	return extra_cpu_log_size;
> > > +}
> > > +
> > >
> > >  void __init setup_log_buf(int early)
> > >  {
> > >  	unsigned long flags;
> > >  	char *new_log_buf;
> > >  	int free;
> > > -
> > > -	if (!new_log_buf_len)
> > > -		return;
> > > +	enum klog_setup_state new_klog_state;
> > >  
> > >  	if (early) {
> > > +		if (!new_log_buf_len)
> > > +			return;
> > >  		new_log_buf =
> > >  			memblock_virt_alloc(new_log_buf_len, PAGE_SIZE);
> > > +		new_klog_state = KLOG_PARAM;
> > >  	} else {
> > > -		new_log_buf = memblock_virt_alloc_nopanic(new_log_buf_len, 0);
> > > +		if (klog_state == KLOG_PARAM)
> > > +			return;
> > > +		if (new_log_buf_len)
> > > +			new_klog_state = KLOG_PARAM;
> > > +		else {
> > > +			new_log_buf_len = compute_cpu_contrib();
> > > +			new_klog_state = KLOG_CPU_EXTRA;
> > > +		}
> > > +		if (!new_log_buf_len)
> > > +			return;
> > > +		new_log_buf = memblock_virt_alloc(new_log_buf_len,
> > > PAGE_SIZE);
> > 
> > We should call memblock_virt_allocc_nopanic() in this else part.
> 
> Oops, sorry yes.
> 
> > Well, I am not sure if the new klog states make the code really better
> > readable. I wonder where we lost the simplicity from v3 of this patch ;-)
> 
> The issue came up after I realized that an architecture that uses the early
> call will end up on this path twice, the trick that the last developer did for
> this situation was to use the kernel parameter as an indicator of whether or
> not the parameter was treated already or not. Towards the end of the call it
> uses:
> 
> 	new_log_buf_len = 0;
> 
> Upon entry on the second call when the kernel parameter was set we bail
> as its now 0. The issue I had not addressed was three fold:
> 
>  *  if an architecture had used the early call new_log_buf_len would
>     be 0 now, and so the so check in place on v3 would not have
>     worked well, instead you'd have to check for log_buf_len as
>     Davidlohr had suspected but only for the non-early case, but only
>     if new_log_buf_len was 0 as an early call could have been issued.
> 
>  *  we want to ensure that for archs that don't use the early call
>     but did pass the kernel parameter that its respected and the extra
>     cpu stuff is ignored
> 
>  *  num_possible_cpus() setup_arch() requirement
> 
> After realizing the double entry issue, as well as the num_possible_cpus()
> requirement to be done later, the above was the cleanest solution I could come
> up with without having to repurpose new_log_buf_len and setting it to some
> magic value, or adding just a bool. I decided a simpler hacky solution would
> would work but considered the lack of documentation on all this nasty enough to
> merit an enum and some clarification.

I see the point. I have solved this by

	if (log_buf != __log_buf)
		return;

You have even used this in some earlier version of the patch. It is much
easier, and better readable. IMHO, it solves the reentrancy pretty
clear way.

[...]
> > 
> > I think that it is better readable than the two level if-magic with
> > the three new flags. The long description of the three flags looked
> > scary in itself ;-)
> 
> Yeah, true, do we want to share the alignment code with log_buf_len_setup() ?
> 
> How about this then?
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index ea2d5f6..da57f6f 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -266,6 +266,7 @@ static u32 clear_idx;
>  #define LOG_ALIGN __alignof__(struct printk_log)
>  #endif
>  #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
> +#define __LOG_CPU_MIN_BUF_LEN (1 << CONFIG_LOG_CPU_MIN_BUF_SHIFT)
>  static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
>  static char *log_buf = __log_buf;
>  static u32 log_buf_len = __LOG_BUF_LEN;
> @@ -828,29 +829,68 @@ void log_buf_kexec_setup(void)
>  /* requested log_buf_len from kernel cmdline */
>  static unsigned long __initdata new_log_buf_len;
>  
> -/* save requested log_buf_len since it's too early to process it */
> -static int __init log_buf_len_setup(char *str)
> +/*
> + * CONFIG_LOG_BUF_SHIFT would be architecture aligned, anything > than it and
> + * a multiple of two of it upkeeps the alignment.
> + */
> +static void __init log_buf_len_align(unsigned size)
>  {
> -	unsigned size = memparse(str, &str);
> -
>  	if (size)
>  		size = roundup_pow_of_two(size);
>  	if (size > log_buf_len)
>  		new_log_buf_len = size;
> +}
> +
> +/* save requested log_buf_len since it's too early to process it */
> +static int __init log_buf_len_setup(char *str)
> +{
> +	unsigned size = memparse(str, &str);
> +
> +	log_buf_len_align(size);
>  
>  	return 0;
>  }
>  early_param("log_buf_len", log_buf_len_setup);
>  
> +static void __init log_buf_add_cpu(void)
> +{
> +	int cpu_extra;
> +
> +	/*
> +	 * archs should set up cpu_possible_bits properly with
> +	 * set_cpu_possible() after setup_arch() but just in
> +	 * case lets ensure this is valid. During an early
> +	 * call before setup_arch()() this will be 1.
> +	 */
> +	if (num_possible_cpus() <= 1)
> +		return;
> +
> +	cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MIN_BUF_LEN;
> +
> +	/* by default this will only continue through for large > 64 CPUs */
> +	if (cpu_extra <= __LOG_BUF_LEN / 2)
> +		return;
> +
> +	pr_info("log_buf_len cpu_extra contribution: %d\n", cpu_extra);
> +	pr_info("log_buf_len min size: %d\n", __LOG_BUF_LEN);
> +
> +	log_buf_len_align(cpu_extra + __LOG_BUF_LEN);
> +}
> +
>  void __init setup_log_buf(int early)
>  {
>  	unsigned long flags;
>  	char *new_log_buf;
>  	int free;
>  
> -	if (!new_log_buf_len)
> +	if (log_buf != __log_buf)
>  		return;
>  
> +	if (!early && !new_log_buf_len)
> +		log_buf_add_cpu();
> +
> +	if (!new_log_buf_len)
> +		return;

I would add empty line here.

>  	if (early) {
>  		new_log_buf =
>  			memblock_virt_alloc(new_log_buf_len, PAGE_SIZE);


I am happy with this solution. And I agree that it is better to split
log_buf_len_align() in a separate patch as you suggested in the other
mail.

Best Regards,
Petr
