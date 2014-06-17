Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbaFQQdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:33:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965093AbaFQQdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:33:10 -0400
Date: Tue, 17 Jun 2014 18:33:06 +0200
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
Message-ID: <20140617163306.GD634@pathway.suse.cz>
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

Also I forgot to explain that default_len_by_cpu_num()
could be called even in the early stage. In this case
it returns zero because num_possible_cpus() returns 1. It means that
the buffer wont be allocated at this stage. I think that it is pretty
safe.

If you want to avoid this speculative call, you might use:

	if (!new_log_buf_len && !early)
		new_log_buf_len = default_len_by_cpu_num();


> +	/* nope when nobody wants to increase the size after all */
>  	if (!new_log_buf_len)
>  		return;
>  
> -- 
> 1.8.4

Best Regards,
Petr
