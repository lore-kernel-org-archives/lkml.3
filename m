Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaEHK7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:59:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:22471 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753903AbaEHK7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:59:52 -0400
Date: Thu, 8 May 2014 06:59:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v10 7/7] ftrace: Introduce
 FTRACE_OPS_FL_SELF_FILTER for ftrace-kprobe
Message-ID: <20140508065947.214f4951@gandalf.local.home>
In-Reply-To: <20140508093930.31767.86419.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140508093842.31767.43766.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140508093930.31767.86419.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2014 18:39:30 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Since the kprobes itself owns a hash table to get a kprobe
> data structure corresponding to the given ip address, there
> is no need to test ftrace hash in ftrace side.
> To achive better performance on ftrace-based kprobe,
> FTRACE_OPS_FL_SELF_FILTER flag to ftrace_ops which means
> that ftrace skips testing its own hash table.
> 
> Without this patch, ftrace_lookup_ip() is biggest cycles
> consumer when 20,000 kprobes are enabled.
>   ----
>   Samples: 1K of event 'cycles', Event count (approx.): 340068894
>   +  20.77%  [k] ftrace_lookup_ip
>   +   8.33%  [k] kprobe_trace_func
>   +   4.83%  [k] get_kprobe_cached
>   ----
> 
> With this patch, ftrace_lookup_ip() vanished from the
> cycles consumer list (of course, there is no caller on
> hotpath anymore :))
>   ----
>   Samples: 1K of event 'cycles', Event count (approx.): 186861492
>   +   9.95%  [k] kprobe_trace_func
>   +   6.00%  [k] kprobe_ftrace_handler
>   +   5.53%  [k] get_kprobe_cached

I should look at your filtering methods, maybe it can make ftrace
filtering better?

>   ----
> 
> Changes from v7:
>  - Re-evaluate the performance improvement.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  include/linux/ftrace.h |    3 +++
>  kernel/kprobes.c       |    2 +-
>  kernel/trace/ftrace.c  |    3 ++-
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index ae9504b..f1fa7d27 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -93,6 +93,8 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
>   * INITIALIZED - The ftrace_ops has already been initialized (first use time
>   *            register_ftrace_function() is called, it will initialized the ops)
>   * DELETED - The ops are being deleted, do not let them be registered again.
> + * SELF_FILTER - The ftrace_ops function filters ip by itself. Do not need to
> + *            check hash table on each hit.

 - The ftrace_ops function has its own ip filter and does not need to
   rely on the ftrace internal ip filtering.


>   */
>  enum {
>  	FTRACE_OPS_FL_ENABLED			= 1 << 0,
> @@ -105,6 +107,7 @@ enum {
>  	FTRACE_OPS_FL_STUB			= 1 << 7,
>  	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
>  	FTRACE_OPS_FL_DELETED			= 1 << 9,
> +	FTRACE_OPS_FL_SELF_FILTER		= 1 << 10,
>  };
>  
>  /*
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 0f5f23c..5c6e410 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1027,7 +1027,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>  #ifdef CONFIG_KPROBES_ON_FTRACE
>  static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
>  	.func = kprobe_ftrace_handler,
> -	.flags = FTRACE_OPS_FL_SAVE_REGS,
> +	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_SELF_FILTER,
>  };
>  static int kprobe_ftrace_enabled;
>  
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 4a54a25..062ca20 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4501,7 +4501,8 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
>  	 */
>  	preempt_disable_notrace();
>  	do_for_each_ftrace_op(op, ftrace_ops_list) {
> -		if (ftrace_ops_test(op, ip, regs))
> +		if (op->flags & FTRACE_OPS_FL_SELF_FILTER ||
> +		    ftrace_ops_test(op, ip, regs))

Hmm, I wonder if I should add the check for:

	!(op->flags & FTRACE_OPS_FL_STUB)

here too? But that's another change that I'll do.

Just update the flag description as I commented and the rest looks good.

-- Steve

>  			op->func(ip, parent_ip, op, regs);
>  	} while_for_each_ftrace_op(op);
>  	preempt_enable_notrace();
> 

