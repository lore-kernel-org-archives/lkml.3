Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaBJU3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:29:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaBJU3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:29:12 -0500
Date: Mon, 10 Feb 2014 21:29:11 +0100
From: Jan Kara <jack@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 08/11] smp: Move __smp_call_function_single() below its
 safe version
Message-ID: <20140210202911.GD16642@quack.suse.cz>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
 <1391876320-25068-9-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391876320-25068-9-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 08-02-14 17:18:37, Frederic Weisbecker wrote:
> Move this function closer to __smp_call_function_single(). These functions
> have very similar behavior and should be displayed in the same block
> for clarity.
  Whatever :). You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/smp.c | 64 ++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 64bb0d4..fa04ab9 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -237,6 +237,38 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
>  }
>  EXPORT_SYMBOL(smp_call_function_single);
>  
> +/**
> + * __smp_call_function_single(): Run a function on a specific CPU
> + * @cpu: The CPU to run on.
> + * @csd: Pre-allocated and setup data structure
> + * @wait: If true, wait until function has completed on specified CPU.
> + *
> + * Like smp_call_function_single(), but allow caller to pass in a
> + * pre-allocated data structure. Useful for embedding @data inside
> + * other structures, for instance.
> + */
> +int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait)
> +{
> +	int err = 0;
> +	int this_cpu;
> +
> +	this_cpu = get_cpu();
> +	/*
> +	 * Can deadlock when called with interrupts disabled.
> +	 * We allow cpu's that are not yet online though, as no one else can
> +	 * send smp call function interrupt to this cpu and as such deadlocks
> +	 * can't happen.
> +	 */
> +	WARN_ON_ONCE(cpu_online(this_cpu) && wait && irqs_disabled()
> +		     && !oops_in_progress);
> +
> +	err = generic_exec_single(cpu, csd, csd->func, csd->info, wait);
> +	put_cpu();
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(__smp_call_function_single);
> +
>  /*
>   * smp_call_function_any - Run a function on any of the given cpus
>   * @mask: The mask of cpus it can run on.
> @@ -281,38 +313,6 @@ call:
>  EXPORT_SYMBOL_GPL(smp_call_function_any);
>  
>  /**
> - * __smp_call_function_single(): Run a function on a specific CPU
> - * @cpu: The CPU to run on.
> - * @csd: Pre-allocated and setup data structure
> - * @wait: If true, wait until function has completed on specified CPU.
> - *
> - * Like smp_call_function_single(), but allow caller to pass in a
> - * pre-allocated data structure. Useful for embedding @data inside
> - * other structures, for instance.
> - */
> -int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait)
> -{
> -	int err = 0;
> -	int this_cpu;
> -
> -	this_cpu = get_cpu();
> -	/*
> -	 * Can deadlock when called with interrupts disabled.
> -	 * We allow cpu's that are not yet online though, as no one else can
> -	 * send smp call function interrupt to this cpu and as such deadlocks
> -	 * can't happen.
> -	 */
> -	WARN_ON_ONCE(cpu_online(this_cpu) && wait && irqs_disabled()
> -		     && !oops_in_progress);
> -
> -	err = generic_exec_single(cpu, csd, csd->func, csd->info, wait);
> -	put_cpu();
> -
> -	return err;
> -}
> -EXPORT_SYMBOL_GPL(__smp_call_function_single);
> -
> -/**
>   * smp_call_function_many(): Run a function on a set of other CPUs.
>   * @mask: The set of cpus to run on (only runs on online subset).
>   * @func: The function to run. This must be fast and non-blocking.
> -- 
> 1.8.3.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
