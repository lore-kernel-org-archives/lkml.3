Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab3APCH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:07:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905Ab3APCHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:07:55 -0500
Date: Wed, 16 Jan 2013 03:07:53 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        chavey@google.com, fengguang.wu@intel.com, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] writeback: mark sysctl vm.block_dump for removal
Message-ID: <20130116020753.GB25806@quack.suse.cz>
References: <1357938397-5413-1-git-send-email-tj@kernel.org>
 <20130114140227.GB2441@kernel.dk>
 <20130114174318.GD27942@mtj.dyndns.org>
 <20130114182203.GE27942@mtj.dyndns.org>
 <20130115162813.GB2668@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115162813.GB2668@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-01-13 08:28:13, Tejun Heo wrote:
> vm.block_dump is nasty in that it dumps IO traces directly to printk.
> It isn't scalable and can easily lead to looping behavior - IO
> generating kernel message which in turn genreates log IO, ad
> infinitum.
> 
> Now that proper tracepoints are in place, vm.block_dump isn't
> necessary.  Generate a warning if used so that it can be removed down
> the road.
> 
> Cc: Added contact info as suggested by Jan.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
  Thanks. The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  include/linux/writeback.h |    3 +++
>  kernel/sysctl.c           |    2 +-
>  mm/page-writeback.c       |   15 +++++++++++++++
>  patches/series            |    1 +
>  4 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index b82a83a..678ee6d 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -143,6 +143,9 @@ extern int dirty_ratio_handler(struct ctl_table *table, int write,
>  extern int dirty_bytes_handler(struct ctl_table *table, int write,
>  		void __user *buffer, size_t *lenp,
>  		loff_t *ppos);
> +extern int block_dump_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp,
> +		loff_t *ppos);
>  
>  struct ctl_table;
>  int dirty_writeback_centisecs_handler(struct ctl_table *, int,
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index c88878d..9e7f7b5 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1288,7 +1288,7 @@ static struct ctl_table vm_table[] = {
>  		.data		= &block_dump,
>  		.maxlen		= sizeof(block_dump),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= block_dump_handler,
>  		.extra1		= &zero,
>  	},
>  	{
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 6f42712..605632d 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -390,6 +390,21 @@ int dirty_bytes_handler(struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> +int block_dump_handler(struct ctl_table *table, int write,
> +		       void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	static bool warned = false;
> +	int ret;
> +
> +	ret = proc_dointvec(table, write, buffer, lenp, ppos);
> +	if (!warned && block_dump) {
> +		pr_warning("sysctl: vm.block_dump is scheduled for removal. Use tracepoints instead.\n");
> +		pr_warning("sysctl: Please contact Jens Axboe <axboe@kernel.dk> if you require this.\n");
> +		warned = true;
> +	}
> +	return ret;
> +}
> +
>  static unsigned long wp_next_time(unsigned long cur_time)
>  {
>  	cur_time += VM_COMPLETIONS_PERIOD_LEN;
> diff --git a/patches/series b/patches/series
> index 9fb9bfe..b2582cb 100644
> --- a/patches/series
> +++ b/patches/series
> @@ -18,3 +18,4 @@ kill-pool-gcwq
>  remove-gcwq
>  rename-nr_running
>  cleanup-leftovers
> +dbg
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
