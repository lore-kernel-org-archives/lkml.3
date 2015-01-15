Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbbAOIGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:06:00 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57055 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbbAOIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:05:58 -0500
Message-ID: <54B774DF.7010209@hitachi.com>
Date: Thu, 15 Jan 2015 17:05:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, vvs@sw.ru,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86-ml <x86@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ftrace: Fix updating of filters for shared global_ops
 filters
References: <20150114153958.931152836@goodmis.org> <20150114154329.055980438@goodmis.org>
In-Reply-To: <20150114154329.055980438@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/15 0:39), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> As the set_ftrace_filter affects both the function tracer as well as the
> function graph tracer, the ops that represent each have a shared
> ftrace_ops_hash structure. This allows both to be updated when the filter
> files are updated.
> 
> But if function graph is enabled and the global_ops (function tracing) ops
> is not, then it is possible that the filter could be changed without the
> update happening for the function graph ops. This will cause the changes
> to not take place and may even cause a ftrace_bug to occur as it could mess
> with the trampoline accounting.
> 
> The solution is to check if the ops uses the shared global_ops filter and
> if the ops itself is not enabled, to check if there's another ops that is
> enabled and also shares the global_ops filter. In that case, the
> modification still needs to be executed.
> 

Looks good to me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> Cc: stable@vger.kernel.org # 3.17+
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ftrace.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 929a733d302e..2b35d0ba578d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4008,8 +4008,32 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
>  static void ftrace_ops_update_code(struct ftrace_ops *ops,
>  				   struct ftrace_hash *old_hash)
>  {
> -	if (ops->flags & FTRACE_OPS_FL_ENABLED && ftrace_enabled)
> +	struct ftrace_ops *op;
> +
> +	if (!ftrace_enabled)
> +		return;
> +
> +	if (ops->flags & FTRACE_OPS_FL_ENABLED) {
>  		ftrace_run_modify_code(ops, FTRACE_UPDATE_CALLS, old_hash);
> +		return;
> +	}
> +
> +	/*
> +	 * If this is the shared global_ops filter, then we need to
> +	 * check if there is another ops that shares it, is enabled.
> +	 * If so, we still need to run the modify code.
> +	 */
> +	if (ops->func_hash != &global_ops.local_hash)
> +		return;
> +
> +	do_for_each_ftrace_op(op, ftrace_ops_list) {
> +		if (op->func_hash == &global_ops.local_hash &&
> +		    op->flags & FTRACE_OPS_FL_ENABLED) {
> +			ftrace_run_modify_code(op, FTRACE_UPDATE_CALLS, old_hash);
> +			/* Only need to do this once */
> +			return;
> +		}
> +	} while_for_each_ftrace_op(op);
>  }
>  
>  static int

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


