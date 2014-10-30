Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbaJ3RCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:02:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:13342 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758161AbaJ3RCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:02:42 -0400
Date: Thu, 30 Oct 2014 13:02:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 4/4] ftrace: Add more information to
 ftrace_bug() output
Message-ID: <20141030130239.351d945e@gandalf.local.home>
In-Reply-To: <20141027182948.733905051@goodmis.org>
References: <20141027182702.778680710@goodmis.org>
	<20141027182948.733905051@goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben and H. Peter,

Can you give me your acked-bys for this?

Thanks!

-- Steve


On Mon, 27 Oct 2014 14:27:06 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> With the introduction of the dynamic trampolines, it is useful that if
> things go wrong that ftrace_bug() produces more information about what
> the current state is. This can help debug issues that may arise.
> 
> Ftrace has lots of checks to make sure that the state of the system it
> touchs is exactly what it expects it to be. When it detects an abnormality
> it calls ftrace_bug() and disables itself to prevent any further damage.
> It is crucial that ftrace_bug() produces sufficient information that
> can be used to debug the situation.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/powerpc/kernel/ftrace.c |  2 +-
>  arch/x86/kernel/ftrace.c     |  2 +-
>  include/linux/ftrace.h       |  4 +++-
>  kernel/trace/ftrace.c        | 38 +++++++++++++++++++++++++++++---------
>  4 files changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
> index 390311c0f03d..e66af6d265e8 100644
> --- a/arch/powerpc/kernel/ftrace.c
> +++ b/arch/powerpc/kernel/ftrace.c
> @@ -449,7 +449,7 @@ void ftrace_replace_code(int enable)
>  		rec = ftrace_rec_iter_record(iter);
>  		ret = __ftrace_replace_code(rec, enable);
>  		if (ret) {
> -			ftrace_bug(ret, rec->ip);
> +			ftrace_bug(ret, rec);
>  			return;
>  		}
>  	}
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 4cfeca6ffe11..1aea94d336c7 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -583,7 +583,7 @@ void ftrace_replace_code(int enable)
>  
>   remove_breakpoints:
>  	pr_warn("Failed on %s (%d):\n", report, count);
> -	ftrace_bug(ret, rec ? rec->ip : 0);
> +	ftrace_bug(ret, rec);
>  	for_ftrace_rec_iter(iter) {
>  		rec = ftrace_rec_iter_record(iter);
>  		/*
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 06e3ca5a5083..619e37cc17fd 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -263,7 +263,9 @@ struct ftrace_func_command {
>  int ftrace_arch_code_modify_prepare(void);
>  int ftrace_arch_code_modify_post_process(void);
>  
> -void ftrace_bug(int err, unsigned long ip);
> +struct dyn_ftrace;
> +
> +void ftrace_bug(int err, struct dyn_ftrace *rec);
>  
>  struct seq_file;
>  
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index eab3123a1fbe..4043332f6720 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1738,10 +1738,13 @@ static void print_ip_ins(const char *fmt, unsigned char *p)
>  		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
>  }
>  
> +static struct ftrace_ops *
> +ftrace_find_tramp_ops_any(struct dyn_ftrace *rec);
> +
>  /**
>   * ftrace_bug - report and shutdown function tracer
>   * @failed: The failed type (EFAULT, EINVAL, EPERM)
> - * @ip: The address that failed
> + * @rec: The record that failed
>   *
>   * The arch code that enables or disables the function tracing
>   * can call ftrace_bug() when it has detected a problem in
> @@ -1750,8 +1753,10 @@ static void print_ip_ins(const char *fmt, unsigned char *p)
>   * EINVAL - if what is read at @ip is not what was expected
>   * EPERM - if the problem happens on writting to the @ip address
>   */
> -void ftrace_bug(int failed, unsigned long ip)
> +void ftrace_bug(int failed, struct dyn_ftrace *rec)
>  {
> +	unsigned long ip = rec ? rec->ip : 0;
> +
>  	switch (failed) {
>  	case -EFAULT:
>  		FTRACE_WARN_ON_ONCE(1);
> @@ -1763,7 +1768,7 @@ void ftrace_bug(int failed, unsigned long ip)
>  		pr_info("ftrace failed to modify ");
>  		print_ip_sym(ip);
>  		print_ip_ins(" actual: ", (unsigned char *)ip);
> -		printk(KERN_CONT "\n");
> +		pr_cont("\n");
>  		break;
>  	case -EPERM:
>  		FTRACE_WARN_ON_ONCE(1);
> @@ -1775,6 +1780,24 @@ void ftrace_bug(int failed, unsigned long ip)
>  		pr_info("ftrace faulted on unknown error ");
>  		print_ip_sym(ip);
>  	}
> +	if (rec) {
> +		struct ftrace_ops *ops = NULL;
> +
> +		pr_info("ftrace record flags: %lx\n", rec->flags);
> +		pr_cont(" (%ld)%s", ftrace_rec_count(rec),
> +			rec->flags & FTRACE_FL_REGS ? " R" : "  ");
> +		if (rec->flags & FTRACE_FL_TRAMP_EN) {
> +			ops = ftrace_find_tramp_ops_any(rec);
> +			if (ops)
> +				pr_cont("\ttramp: %pS",
> +					(void *)ops->trampoline);
> +			else
> +				pr_cont("\ttramp: ERROR!");
> +
> +		}
> +		ip = ftrace_get_addr_curr(rec);
> +		pr_cont(" expected tramp: %lx\n", ip);
> +	}
>  }
>  
>  static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
> @@ -2097,7 +2120,7 @@ void __weak ftrace_replace_code(int enable)
>  	do_for_each_ftrace_rec(pg, rec) {
>  		failed = __ftrace_replace_code(rec, enable);
>  		if (failed) {
> -			ftrace_bug(failed, rec->ip);
> +			ftrace_bug(failed, rec);
>  			/* Stop processing */
>  			return;
>  		}
> @@ -2179,17 +2202,14 @@ struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace_rec_iter *iter)
>  static int
>  ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
>  {
> -	unsigned long ip;
>  	int ret;
>  
> -	ip = rec->ip;
> -
>  	if (unlikely(ftrace_disabled))
>  		return 0;
>  
>  	ret = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
>  	if (ret) {
> -		ftrace_bug(ret, ip);
> +		ftrace_bug(ret, rec);
>  		return 0;
>  	}
>  	return 1;
> @@ -2633,7 +2653,7 @@ static int ftrace_update_code(struct module *mod, struct ftrace_page *new_pgs)
>  			if (ftrace_start_up && cnt) {
>  				int failed = __ftrace_replace_code(p, 1);
>  				if (failed)
> -					ftrace_bug(failed, p->ip);
> +					ftrace_bug(failed, p);
>  			}
>  		}
>  	}

