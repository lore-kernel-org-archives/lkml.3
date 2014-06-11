Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaFKJey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:34:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbaFKJew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:34:52 -0400
Date: Wed, 11 Jun 2014 11:34:47 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC] printk: allow increasing the ring buffer depending on the
 number of CPUs
Message-ID: <20140611093447.GL7772@pathway.suse.cz>
References: <1402448685-30634-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402448685-30634-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-06-10 18:04:45, Luis R. Rodriguez wrote:
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

Thanks for looking at this. It is a pity to lose stracktrace when a huge
machine Oopses just because the default ring buffer is too small.


> There are mechanisms to help increase the kernel ring buffer
> for tracing through debugfs, and those interfaces even allow growing
> the kernel ring buffer per CPU. We also have a static value which
> can be passed upon boot. Relying on debugfs however is not ideal
> for production, and relying on the value passed upon bootup is
> can only used *after* an issue has creeped up. Instead of being
> reactive this adds a proactive measure which lets you scale the
> amount of contributions you'd expect to the kernel ring buffer
> under load by each CPU in the worst case scenerio.
> 
> We use num_possible_cpus() to avoid complexities which could be
> introduced by dynamically changing the ring buffer size at run
> time, num_possible_cpus() lets us use the upper limit on possible
> number of CPUs therefore avoiding having to deal with hotplugging
> CPUs on and off. This option is diabled by default, and if used
> the kernel ring buffer size then can be computed as follows:
> 
> size = __LOG_BUF_LEN + (num_possible_cpus() - 1 ) *  __LOG_CPU_BUF_LEN
> 
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Petr Mladek <pmladek@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Arun KS <arunks.linux@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  init/Kconfig           | 28 ++++++++++++++++++++++++++++
>  kernel/printk/printk.c |  6 ++++--
>  2 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3585b..1814436 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -806,6 +806,34 @@ config LOG_BUF_SHIFT
>  		     13 =>  8 KB
>  		     12 =>  4 KB
>  
> +config LOG_CPU_BUF_SHIFT
> +	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
> +	range 0 21
> +	default 0
> +	help
> +	  The kernel ring buffer will get additional data logged onto it
> +	  when multiple CPUs are supported. Typically the contributions is a
> +	  few lines when idle however under under load this can vary and in the
> +	  worst case it can mean loosing logging information. You can use this
> +	  to set the maximum expected mount of amount of logging contribution
> +	  under load by each CPU in the worst case scenerio. Select a size as
> +	  a power of 2. For example if LOG_BUF_SHIFT is 18 and if your
> +	  LOG_CPU_BUF_SHIFT is 12 your kernel ring buffer size will be as
> +	  follows having 16 CPUs as possible.
> +
> +	     ((1 << 18) + ((16 - 1) * (1 << 12))) / 1024 = 316 KB

It might be better to use the CPU_NUM-specific value as a minimum of
the needed space. Linux distributions might want to distribute kernel
with non-zero value and still use the static "__log_buf" on reasonable
small systems.

> +	  Where as typically you'd only end up with 256 KB. This is disabled
> +	  by default with a value of 0.

I would add:

	This value is ignored when "log_buf_len" commandline parameter
	is used. It forces the exact size of the ring buffer.

> +	  Examples:
> +		     17 => 128 KB
> +		     16 => 64 KB
> +	             15 => 32 KB
> +	             14 => 16 KB
> +		     13 =>  8 KB
> +		     12 =>  4 KB

I think that we should make it more cleat that it is per-CPU here,
for example:

		17 => 128 KB for each CPU
		16 =>  64 KB for each CPU
		15 =>  32 KB for each CPU
		14 =>  16 KB for each CPU
		13 =>   8 KB for each CPU
		12 =>   4 KB for each CPU


>  #
>  # Architectures with an unreliable sched_clock() should select this:
>  #
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 7228258..2023424 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -246,6 +246,7 @@ static u32 clear_idx;
>  #define LOG_ALIGN __alignof__(struct printk_log)
>  #endif
>  #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
> +#define __LOG_CPU_BUF_LEN (1 << CONFIG_LOG_CPU_BUF_SHIFT)
>  static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
>  static char *log_buf = __log_buf;
>  static u32 log_buf_len = __LOG_BUF_LEN;
> @@ -752,9 +753,10 @@ void __init setup_log_buf(int early)
>  	unsigned long flags;
>  	char *new_log_buf;
>  	int free;
> +	int cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_BUF_LEN;
>  
> -	if (!new_log_buf_len)
> -		return;
> +	if (!new_log_buf_len && cpu_extra > 1)
> +		new_log_buf_len = __LOG_BUF_LEN + cpu_extra;

We still should return when both new_log_buf_len and cpu_extra are
zero and call here:

	if (!new_log_buf_len)
		return;

Also I would feel more comfortable if we somehow limit the maximum
size of cpu_extra. I wonder if there might be a crazy setup with a lot
of possible CPUs and possible memory but with some minimal amount of
CPUs and memory at the boot time.

The question is how to do it. I am still not much familiar with the
memory subsystem. I wonder if 10% of memory defined by the
"total_rampages" variable would be a reasonable limit.

>  	if (early) {
>  		new_log_buf =
> -- 
> 2.0.0.rc3.18.g00a5b79
> 

>  LocalWords:  buf len cpu boottime
