Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbaFQPfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:35:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932999AbaFQPfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:35:10 -0400
Date: Tue, 17 Jun 2014 17:35:07 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: hpa@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Michal Hocko <mhocko@suse.cz>, Joe Perches <joe@perches.com>,
        Arun KS <arunks.linux@gmail.com>, Kees Cook <keescook@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFT v5h printk: allow increasing the ring buffer depending on
 the number of CPUs
Message-ID: <20140617153507.GB634@pathway.suse.cz>
References: <1402965464-11202-1-git-send-email-mcgrof@do-not-panic.com>
 <20140617145200.GA634@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140617145200.GA634@pathway.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-06-17 16:52:00, Petr Mládek wrote:
> On Mon 2014-06-16 17:37:44, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > The default size of the ring buffer is too small for machines
> > with a large amount of CPUs under heavy load. What ends up
> > happening when debugging is the ring buffer overlaps and chews
> > up old messages making debugging impossible unless the size is
> > passed as a kernel parameter. An idle system upon boot up will
> > on average spew out only about one or two extra lines but where
> > this really matters is on heavy load and that will vary widely
> > depending on the system and environment.
> > 
> > There are mechanisms to help increase the kernel ring buffer
> > for tracing through debugfs, and those interfaces even allow growing
> > the kernel ring buffer per CPU. We also have a static value which
> > can be passed upon boot. Relying on debugfs however is not ideal
> > for production, and relying on the value passed upon bootup is
> > can only used *after* an issue has creeped up. Instead of being
> > reactive this adds a proactive measure which lets you scale the
> > amount of contributions you'd expect to the kernel ring buffer
> > under load by each CPU in the worst case scenario.
> > 
> > We use num_possible_cpus() to avoid complexities which could be
> > introduced by dynamically changing the ring buffer size at run
> > time, num_possible_cpus() lets us use the upper limit on possible
> > number of CPUs therefore avoiding having to deal with hotplugging
> > CPUs on and off. This introduces the kernel configuration option
> > LOG_CPU_MIN_BUF_SHIFT which is used to specify the maximum amount
> > of contributions to the kernel ring buffer in the worst case before
> > the kernel ring buffer flips over, the size is specified as a power
> > of 2. The total amount of contributions made by each CPU must be
> > greater than half of the default kernel ring buffer size
> > (1 << LOG_BUF_SHIFT bytes) in order to trigger an increase upon
> > bootup. The kernel ring buffer is increased to the next power of
> > two that would fit the required minimum kernel ring buffer size
> > plus the additional CPU contribution. For example if LOG_BUF_SHIFT
> > is 18 (256 KB) you'd require at least 128 KB contributions by
> > other CPUs in order to trigger an increase of the kernel ring buffer.
> > With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require at least
> > anything over > 64 possible CPUs to trigger an increase. If you
> > had 128 possible CPUs the amount of minimum required kernel ring
> > buffer bumps to:
> > 
> >    ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB
> > 
> > Since we require the ring buffer to be a power of two this would
> > the new required size would be 1024 KB.
> > 
> > This CPU contributions are ignored when the "log_buf_len" kernel parameter
> > is used as it forces the exact size of the ring buffer to an expected power
> > of two value.
> > 
> > In order to make this code a bit more legible, add a small enum to keep
> > track of when the reasons of setting the ring buffer, and extend the
> > documentation quite a bit to make all this clear.
> > 
> > Cc: Michal Hocko <mhocko@suse.cz>
> > Cc: Petr Mladek <pmladek@suse.cz>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Joe Perches <joe@perches.com>
> > Cc: Arun KS <arunks.linux@gmail.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Davidlohr Bueso <davidlohr@hp.com>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> > 
> > I've modified the computation to just go to the next power of two. All
> > other implementations do that, and although its not well documented 
> > I rather follow that logic. Without the enum stuff this code can get
> > ugly easy, while at it I also extended the documentation a bit more.
> > 
> >  Documentation/kernel-parameters.txt |   8 ++-
> >  init/Kconfig                        |  53 +++++++++++++++++-
> >  kernel/printk/printk.c              | 108 ++++++++++++++++++++++++++++++++++--
> >  3 files changed, 162 insertions(+), 7 deletions(-)

[...]

> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index ea2d5f6..54632a0c 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c

[...]
 
> >  /* human readable text of the record */
> >  static char *log_text(const struct printk_log *msg)
> > @@ -842,20 +905,56 @@ static int __init log_buf_len_setup(char *str)
> >  }
> >  early_param("log_buf_len", log_buf_len_setup);
> >  
> > +static unsigned __init compute_cpu_contrib(void)
> 
> The function name is slightly misleading. It does not compute the
> extra space but the whole length of the ring buffer. What about using
> default_len_by_cpu_num() or so?
> 
> > +{
> > +	int cpu_extra;
> > +	unsigned extra_cpu_log_size;
> > +
> > +	/*
> > +	 * archs should set up cpu_possible_bits properly with
> > +	 * set_cpu_possible() after setup_arch() but just in
> > +	 * case lets ensure this is valid.
> > +	 */
> > +	if (num_possible_cpus() <= 1)
> > +		return 0;
> > +
> > +	cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MIN_BUF_LEN;
> > +	extra_cpu_log_size = roundup_pow_of_two(cpu_extra +
> > __LOG_BUF_LEN);
> 
> Great catch. Well, I am not sure if this is really
> needed. memblock_virt_alloc() is called on another locations with "any" size.
> 
> It might be enough to make sure that the size is aligned to
> LOG_ALIGN. This is how the messages are aligned. I would do:
> 
> 	cpu_extra %= LOG_ALIGN;

Shame on me :-) I have added this computation just before sending the
mail wihtout enough thingking and testing. Better solution would be:

	cpu_extra &= ~(LOG_ALIGN - 1);

If we would want to round up, we could use a similar trick that is used in
msg_used_size(). But I think that it is not really needed here.


> Another possibility would be to set the minimal size of
> LOG_CPU_MIN_BUF_SHIFT to "6" or so. I hope that the alignment of the
> "struct printk_log" newer would be bigger than 64 bytes. Well, we
> could add a compile check if we want to be sure.
> 
> Anyway, I do not have any strong opinion here. I might be too careful
> and the roundup_pow_of_two() is perfectly fine.
> 
> > +
> > +	if (cpu_extra <= __LOG_BUF_LEN / 2)
> > +		return 0;
> > +
> > +	pr_info("log_buf_len cpu_extra contribution: %d\n", cpu_extra);
> > +	pr_info("log_buf_len min size: %d\n", __LOG_BUF_LEN);
> > +
> > +	return extra_cpu_log_size;
> > +}
> > +
> >
> >  void __init setup_log_buf(int early)
> >  {
> >  	unsigned long flags;
> >  	char *new_log_buf;
> >  	int free;
> > -
> > -	if (!new_log_buf_len)
> > -		return;
> > +	enum klog_setup_state new_klog_state;
> >  
> >  	if (early) {
> > +		if (!new_log_buf_len)
> > +			return;
> >  		new_log_buf =
> >  			memblock_virt_alloc(new_log_buf_len, PAGE_SIZE);
> > +		new_klog_state = KLOG_PARAM;
> >  	} else {
> > -		new_log_buf = memblock_virt_alloc_nopanic(new_log_buf_len, 0);
> > +		if (klog_state == KLOG_PARAM)
> > +			return;
> > +		if (new_log_buf_len)
> > +			new_klog_state = KLOG_PARAM;
> > +		else {
> > +			new_log_buf_len = compute_cpu_contrib();
> > +			new_klog_state = KLOG_CPU_EXTRA;
> > +		}
> > +		if (!new_log_buf_len)
> > +			return;
> > +		new_log_buf = memblock_virt_alloc(new_log_buf_len,
> > PAGE_SIZE);
> 
> We should call memblock_virt_allocc_nopanic() in this else part.
> 
> 
> Well, I am not sure if the new klog states make the code really better
> readable. I wonder where we lost the simplicity from v3 of this patch ;-)
> 
> What about replacing the above changes in kernel/printk/printk.c with
> the following ones:
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index ea2d5f6962ed..e00a9600f5fa 100644
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
> @@ -842,12 +843,52 @@ static int __init log_buf_len_setup(char *str)
>  }
>  early_param("log_buf_len", log_buf_len_setup);
>  
> +static unsigned __init default_len_by_cpu_num(void)
> +{
> +	int cpu_extra;
> +	unsigned extra_cpu_log_size;
> +
> +	/*
> +	 * archs should set up cpu_possible_bits properly with
> +	 * set_cpu_possible() after setup_arch() but just in
> +	 * case lets ensure this is valid.
> +	 */
> +	if (num_possible_cpus() <= 1)
> +		return 0;
> +
> +	cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MIN_BUF_LEN;
> +	/* make sure that the buffer is aligned */
> +	cpu_extra %= LOG_ALIGN;
> +	extra_cpu_log_size = roundup_pow_of_two(cpu_extra + __LOG_BUF_LEN);

The correct lines are:

+	cpu_extra &= ~(LOG_ALIGN - 1);
+	extra_cpu_log_size = __LOG_BUF_LEN + cpu_extra;

Best Regards,
Petr

> +
> +	if (cpu_extra <= __LOG_BUF_LEN / 2)
> +		return 0;
> +
> +	pr_info("log_buf_len cpu_extra contribution: %d\n", cpu_extra);
> +	pr_info("log_buf_len min size: %d\n", __LOG_BUF_LEN);
> +
> +	return extra_cpu_log_size;
> +}
> +
>  void __init setup_log_buf(int early)
>  {
>  	unsigned long flags;
>  	char *new_log_buf;
>  	int free;
>  
> +	/* nope when already allocated earlier */
> +	if (log_buf != __log_buf)
> +		return;
> +
> +	/*
> +	 * The default size need to be increased on systems with many CPUs.
> +	 * It is done only when an exact size is not forced by log_buf_len=n
> +	 * kernel parameter.
> +	 */
> +	if (!new_log_buf_len)
> +		new_log_buf_len = default_len_by_cpu_num();
> +
> +	/* nope when nobody wants to increase the size after all */
>  	if (!new_log_buf_len)
>  		return;
>  
> -- 
> 1.8.4
> 
> 
> I think that it is better readable than the two level if-magic with
> the three new flags. The long description of the three flags looked
> scary in itself ;-)
> 
> Best Regards,
> Petr
