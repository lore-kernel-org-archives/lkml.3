Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaB0Qhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:37:38 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:57213 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaB0Qhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:37:36 -0500
Date: Thu, 27 Feb 2014 17:37:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFA][PATCH 2/5] ftrace/x86: One more missing sync after fixup
 of function modification failure
Message-ID: <20140227163731.GC19580@localhost.localdomain>
References: <20140227154616.703252665@goodmis.org>
 <20140227154923.103932155@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227154923.103932155@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:46:18AM -0500, Steven Rostedt wrote:
> [Request for Ack]
> 
> From: Petr Mladek <pmladek@suse.cz>
> 
> If a failure occurs while modifying ftrace function, it bails out and will
> remove the tracepoints to be back to what the code originally was.
> 
> There is missing the final sync run across the CPUs after the fix up is done
> and before the ftrace int3 handler flag is reset.

So IIUC the risk is that other CPUs may spuriously ignore non-ftrace traps if we don't sync the
other cores after reverting the int3 before decrementing the modifying_ftrace_code counter?

> 
> Link: http://lkml.kernel.org/r/1393258342-29978-2-git-send-email-pmladek@suse.cz
> 
> Fixes: 8a4d0a687a5 "ftrace: Use breakpoint method to update ftrace caller"
> Cc: stable@vger.kernel.org # 3.5+
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/ftrace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 6b566c8..69885e2 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -660,8 +660,8 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
>  		ret = -EPERM;
>  		goto out;
>  	}
> -	run_sync();
>   out:
> +	run_sync();
>  	return ret;
>  
>   fail_update:

This could be further optimized by rather calling run_sync() in the end of the
fail_update block (after the probe_kernel_write revert) otherwise even failure on
setting the break will result in run_sync(), which doesn't appear to be needed. But
that's really just nitpicking as it's a rare failure codepath and shouldn't hurt.

In any case, the fix looks correct.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> -- 
> 1.8.5.3
> 
> 
