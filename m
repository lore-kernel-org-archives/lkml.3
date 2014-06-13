Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaFMJOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:14:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaFMJOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:14:45 -0400
Date: Fri, 13 Jun 2014 11:14:41 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFC v2] printk: allow increasing the ring buffer depending on
 the number of CPUs
Message-ID: <20140613091441.GO7772@pathway.suse.cz>
References: <1402611369-4811-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402611369-4811-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-12 15:16:09, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> The default size of the ring buffer is too small for machines
> with a large amount of CPUs under heavy load. What ends up
> happening when debugging is the ring buffer overlaps and chews
> up old messages making debugging impossible unless the size is
> passed as a kernel parameter. An idle system upon boot up will
> on average spew out only about one or two extra lines but where
> this really matters is on heavy load and that will vary widely
> depending on the system and environment.
> 
> There are mechanisms to help increase the kernel ring buffer
> for tracing through debugfs, and those interfaces even allow growing
> the kernel ring buffer per CPU. We also have a static value which
> can be passed upon boot. Relying on debugfs however is not ideal
> for production, and relying on the value passed upon bootup is
> can only used *after* an issue has creeped up. Instead of being
> reactive this adds a proactive measure which lets you scale the
> amount of contributions you'd expect to the kernel ring buffer
> under load by each CPU in the worst case scenerio.
					   ^^^^^^^^
s/scenerio/scenario/

> 
> We use num_possible_cpus() to avoid complexities which could be
> introduced by dynamically changing the ring buffer size at run
> time, num_possible_cpus() lets us use the upper limit on possible
> number of CPUs therefore avoiding having to deal with hotplugging
> CPUs on and off. This introduces the kernel configuration option
> LOG_CPU_MIN_BUF_SHIFT which is used to specify the maximum amount
> of contributions to the kernel ring buffer in the worst case before
> the kernel ring buffer flips over, the size is specified as a power
> of 2. The total amount of contributions made by each CPU must be
> greater than half of the default kernel ring buffer size
> (1 << LOG_BUF_SHIFT bytes) in order to trigger an increase upon
> bootup. For example if LOG_BUF_SHIFT is 18 (256 KB) you'd require at
> least 128 KB contributions by other CPUs in order to trigger an
> increase. With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require at
> least anything over > 64 possible CPUs to trigger an increase. If
> you had 128 possible CPUs your kernel buffer size would be:
> 
>    ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB
> 
> This value is ignored when "log_buf_len" kernel parameter is used
> as it forces the exact size of the ring buffer to an expected value.
> 
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Petr Mladek <pmladek@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Arun KS <arunks.linux@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Davidlohr Bueso <davidlohr@hp.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  Documentation/kernel-parameters.txt | 16 +++++++++++++++-
>  init/Kconfig                        | 38 +++++++++++++++++++++++++++++++++++++
>  kernel/printk/printk.c              | 12 ++++++++++++
>  3 files changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 30a8ad0d..98ec002 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1647,7 +1647,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	log_buf_len=n[KMG]	Sets the size of the printk ring buffer,
>  			in bytes.  n must be a power of two.  The default
> -			size is set in the kernel config file.
> +			size is set in the kernel config file. If you want
> +			a more proactive solution on *large* production systems
> +			consider using CONFIG_LOG_CPU_MIN_BUF_SHIFT which
> +			can be used to increase the kernel ring buffer
> +			under the assumption that each CPU will contribute
> +			a CONFIG_LOG_CPU_MIN_BUF_SHIFT << 1 bytes to the kernel
> +			ring buffer in the worst case scenario. The kernel
> +			ring buffer will be increased upon bootup if and only
> +			if the amount of extra logging expected to be
> +			contributed by all CPUs will be greater than half of
> +			CONFIG_LOG_BUF_SHIFT << 1 bytes. With defaults of
> +			LOG_BUF_SHIFT of 18 and LOG_CPU_MIN_BUF_SHIFT at 12
> +			a system would require more than 64 possible CPUs to
> +			trigger an increase over the default kernel ring buffer
> +			at bootup.

I would more explicitly say here that it forces the exact size of
the ring buffer. Also I think that we do not need to duplicate the
all the details about CONFIG_LOG_CPU_MIN_BUF_SHIFT here. What about
the following text?

	log_buf_len=n[KMG]	Set the exact size of the printk ring buffer,
			in bytes. "n" must be a power of two and greater
			than the minimal size. The minimal size is defined
			by LOG_BUF_SHIFT kernel config parameter. There is
			also CONFIG_LOG_CPU_MIN_BUF_SHIFT config parameter
			that allows to increase the default size depending on
			the number of CPUs. See init/Kconfig for more details.

>  	logo.nologo	[FB] Disables display of the built-in Linux logo.
>  			This may be used to provide more screen space for
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3585b..2e425d7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -806,6 +806,44 @@ config LOG_BUF_SHIFT
>  		     13 =>  8 KB
>  		     12 =>  4 KB
>  
> +config LOG_CPU_MIN_BUF_SHIFT
> +	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
> +	range 0 21
> +	default 12
> +	depends on SMP
> +	depends on !BASE_SMALL
> +	help
> +	  The kernel ring buffer will get additional data logged onto it
> +	  when multiple CPUs are supported. Typically the contributions are
> +	  only a few lines when idle however under under load this can vary
> +	  and in the worst case it can mean losing logging information. You
> +	  can use this to set the maximum expected mount of amount of logging
> +	  contribution under load by each CPU in the worst case scenerio, as
								^^^^^^^^

s/scenerio/scenario/

> +	  a power of 2. The total amount of contributions made by each CPU
> +	  must be greater than half of the default kernel ring buffer size
> +	  (1 << LOG_BUF_SHIFT bytes) in order to trigger an increase upon
> +	  bootup. For example if LOG_BUF_SHIFT is 18 (256 KB) you're require
> +	  at least 128 KB contributions by other CPUs in order to trigger
> +	  an increase. With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require
> +	  at least anything over > 64 possible CPUs to trigger an increase.
> +	  If you had 128 possible CPUs your kernel buffer size would be:
> +
> +	     ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB
> +
> +	  This value is ignored when "log_buf_len" kernel parameter is used
> +	  as it forces the exact size of the ring buffer to an
> expected value.

I would add empty line here to make it better readable.

> +	  The number of possible CPUs is used for this computation ignoring
> +	  hotplugging making the compuation optimal for the the worst case
> +	  scenerio while allowing a simple algorithm to be used from bootup.
> +
> +	  Examples shift values and their meaning:
> +		     17 => 128 KB for each CPU
> +		     16 =>  64 KB for each CPU
> +	             15 =>  32 KB for each CPU
	^^^^^^^^ here are spaces intead of TAB :-)
> +	             14 =>  16 KB for each CPU
	^^^^^^^^ same here :-)
> +		     13 =>   8 KB for each CPU
> +		     12 =>   4 KB for each CPU
> +

It would be great to also update the description of the LOG_BUF_SHIFT
parameter. What about?

config LOG_BUF_SHIFT
	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
	range 12 21
	default 17
	help
	  Select the minimal kernel log buffer size as a power of 2.
	  The final size is affected by LOG_CPU_MIN_BUF_SHIFT config
	  parameter, see below. Any higher size also might be forced
	  by "log_buf_len" boot parameter.

	  Examples:
		17 => 128 KB
		...


>  #
>  # Architectures with an unreliable sched_clock() should select this:
>  #
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 7228258..3f3356b 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -246,6 +246,7 @@ static u32 clear_idx;
>  #define LOG_ALIGN __alignof__(struct printk_log)
>  #endif
>  #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
> +#define __LOG_CPU_MIN_BUF_LEN (1 << CONFIG_LOG_CPU_MIN_BUF_SHIFT)
>  static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
>  static char *log_buf = __log_buf;
>  static u32 log_buf_len = __LOG_BUF_LEN;
> @@ -752,6 +753,17 @@ void __init setup_log_buf(int early)
>  	unsigned long flags;
>  	char *new_log_buf;
>  	int free;
> +	int cpu_extra = (num_possible_cpus() - 1) *  __LOG_CPU_MIN_BUF_LEN;
> +
> +	/*
> +	 * If you set log_buf_len=n kernel parameter LOG_CPU_MIN_BUF_SHIFT will
> +	 * be ignored. LOG_CPU_MIN_BUF_SHIFT is a proactive measure for large
> +	 * systems. With a LOG_BUF_SHIFT of 18 and LOG_CPU_MIN_BUF_SHIFT 12 at
> +	 * we'd require more than 64 CPUs to trigger an increase from the
> +	 * default.
> +	 */
> +	if (!new_log_buf_len && (cpu_extra > __LOG_BUF_LEN / 2))
> +		new_log_buf_len = __LOG_BUF_LEN + cpu_extra;
>  
>  	if (!new_log_buf_len)
>  		return;
> -- 
> 2.0.0.rc3.18.g00a5b79

Beside the cosmetic changes, I really like the patch. It solves the
problem an elegant way.

Best Regards,
Petr
