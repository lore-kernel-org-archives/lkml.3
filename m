Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaFMUhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:37:09 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:46595 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaFMUhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:37:08 -0400
Message-ID: <1402691813.27369.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3] printk: allow increasing the ring buffer depending
 on the number of CPUs
From: Davidlohr Bueso <davidlohr@hp.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: hpa@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Jun 2014 13:36:53 -0700
In-Reply-To: <1402684097-5731-1-git-send-email-mcgrof@do-not-panic.com>
References: <1402684097-5731-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 11:28 -0700, Luis R. Rodriguez wrote:
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
> under load by each CPU in the worst case scenario.
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
>  Documentation/kernel-parameters.txt |  8 +++++--
>  init/Kconfig                        | 45 ++++++++++++++++++++++++++++++++++++-
>  kernel/printk/printk.c              | 12 ++++++++++
>  3 files changed, 62 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 30a8ad0d..23c50eb 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1646,8 +1646,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			7 (KERN_DEBUG)		debug-level messages
>  
>  	log_buf_len=n[KMG]	Sets the size of the printk ring buffer,
> -			in bytes.  n must be a power of two.  The default
> -			size is set in the kernel config file.
> +			in bytes.  n must be a power of two and greater
> +			than the minimal size. The minimal size is defined
> +			by LOG_BUF_SHIFT kernel config parameter. There is
> +			also CONFIG_LOG_CPU_MIN_BUF_SHIFT config parameter
> +			that allows to increase the default size depending on
> +			the number of CPUs. See init/Kconfig for more details.
>  
>  	logo.nologo	[FB] Disables display of the built-in Linux logo.
>  			This may be used to provide more screen space for
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3585b..7e4da9a 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -797,7 +797,11 @@ config LOG_BUF_SHIFT
>  	range 12 21
>  	default 17
>  	help
> -	  Select kernel log buffer size as a power of 2.
> +	  Select the minimal kernel log buffer size as a power of 2.
> +	  The final size is affected by LOG_CPU_MIN_BUF_SHIFT config
> +	  parameter, see below. Any higher size also might be forced
> +	  by "log_buf_len" boot parameter.
> +
>  	  Examples:
>  	  	     17 => 128 KB
>  		     16 => 64 KB
> @@ -806,6 +810,45 @@ config LOG_BUF_SHIFT
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
> +	  contribution under load by each CPU in the worst case scenario, as
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
> +	  as it forces the exact size of the ring buffer to an expected value.
> +
> +	  The number of possible CPUs is used for this computation ignoring
> +	  hotplugging making the compuation optimal for the the worst case
> +	  scenerio while allowing a simple algorithm to be used from bootup.
> +
> +	  Examples shift values and their meaning:
> +		     17 => 128 KB for each CPU
> +		     16 =>  64 KB for each CPU
> +		     15 =>  32 KB for each CPU
> +		     14 =>  16 KB for each CPU
> +		     13 =>   8 KB for each CPU
> +		     12 =>   4 KB for each CPU
> +
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

I think you forgot to drop the - 1 here.

