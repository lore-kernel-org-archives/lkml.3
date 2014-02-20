Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaBTPjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:39:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:34786 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752575AbaBTPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:39:11 -0500
Date: Thu, 20 Feb 2014 10:39:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/6] ftrace: cleanup of global variables
Message-ID: <20140220103908.0deda0d1@gandalf.local.home>
In-Reply-To: <1392892387-26826-1-git-send-email-jslaby@suse.cz>
References: <1392892387-26826-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 11:33:02 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

>  kernel/trace/ftrace.c | 31 ++++++++-----------------------
>  1 file changed, 8 insertions(+), 23 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index cd7f76d1eb86..c321fed01e91 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1172,8 +1172,6 @@ struct ftrace_page {
>  	int			size;
>  };
>  
> -static struct ftrace_page *ftrace_new_pgs;
> -
>  #define ENTRY_SIZE sizeof(struct dyn_ftrace)
>  #define ENTRIES_PER_PAGE (PAGE_SIZE / ENTRY_SIZE)
>  
> @@ -2243,8 +2241,6 @@ static void ftrace_shutdown_sysctl(void)
>  		ftrace_run_update_code(FTRACE_DISABLE_CALLS);
>  }
>  
> -static cycle_t		ftrace_update_time;
> -static unsigned long	ftrace_update_cnt;
>  unsigned long		ftrace_update_tot_cnt;
>  
>  static inline int ops_traces_mod(struct ftrace_ops *ops)
> @@ -2300,11 +2296,11 @@ static int referenced_filters(struct dyn_ftrace *rec)
>  	return cnt;
>  }
>  
> -static int ftrace_update_code(struct module *mod)
> +static int ftrace_update_code(struct module *mod, struct ftrace_page *new_pgs)
>  {
>  	struct ftrace_page *pg;
>  	struct dyn_ftrace *p;
> -	cycle_t start, stop;
> +	unsigned long update_cnt = 0;
>  	unsigned long ref = 0;
>  	bool test = false;
>  	int i;
> @@ -2329,10 +2325,7 @@ static int ftrace_update_code(struct module *mod)
>  		}
>  	}
>  
> -	start = ftrace_now(raw_smp_processor_id());
> -	ftrace_update_cnt = 0;
> -

I've been waiting for someone to notice this. Actually, I do use it
once in a while to see how long the updates take. Instead of nuking it,
perhaps the info should be exported in a debugfs file for info only.

[ separate patch please ]

> -	for (pg = ftrace_new_pgs; pg; pg = pg->next) {
> +	for (pg = new_pgs; pg; pg = pg->next) {
>  
>  		for (i = 0; i < pg->index; i++) {
>  			int cnt = ref;
> @@ -2353,7 +2346,7 @@ static int ftrace_update_code(struct module *mod)
>  			if (!ftrace_code_disable(mod, p))
>  				break;
>  
> -			ftrace_update_cnt++;
> +			update_cnt++;
>  
>  			/*
>  			 * If the tracing is enabled, go ahead and enable the record.
> @@ -2372,11 +2365,7 @@ static int ftrace_update_code(struct module *mod)
>  		}
>  	}
>  
> -	ftrace_new_pgs = NULL;
> -
> -	stop = ftrace_now(raw_smp_processor_id());
> -	ftrace_update_time = stop - start;
> -	ftrace_update_tot_cnt += ftrace_update_cnt;
> +	ftrace_update_tot_cnt += update_cnt;
>  
>  	return 0;
>  }
> @@ -4238,9 +4227,6 @@ static int ftrace_process_locs(struct module *mod,
>  	/* Assign the last page to ftrace_pages */
>  	ftrace_pages = pg;
>  
> -	/* These new locations need to be initialized */
> -	ftrace_new_pgs = start_pg;
> -
>  	/*
>  	 * We only need to disable interrupts on start up
>  	 * because we are modifying code that an interrupt
> @@ -4251,7 +4237,7 @@ static int ftrace_process_locs(struct module *mod,
>  	 */
>  	if (!mod)
>  		local_irq_save(flags);
> -	ftrace_update_code(mod);
> +	ftrace_update_code(mod, start_pg);

Ah, there was a time when this was done via stop_machine(). I still had
that in my mind, that it did. OK, thanks for cleaning this up.

Note, Soon I'll be posting a set of patches to my for-next repo. You
might need to rebase it on that.

Thanks,

-- Steve

>  	if (!mod)
>  		local_irq_restore(flags);
>  	ret = 0;
> @@ -4360,11 +4346,10 @@ struct notifier_block ftrace_module_exit_nb = {
>  	.priority = INT_MIN,	/* Run after anything that can remove kprobes */
>  };
>  
> -extern unsigned long __start_mcount_loc[];
> -extern unsigned long __stop_mcount_loc[];
> -
>  void __init ftrace_init(void)
>  {
> +	extern unsigned long __start_mcount_loc[];
> +	extern unsigned long __stop_mcount_loc[];
>  	unsigned long count, addr, flags;
>  	int ret;
>  

