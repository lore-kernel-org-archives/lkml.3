Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaB0P6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:58:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaB0P6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:58:14 -0500
Date: Thu, 27 Feb 2014 16:58:12 +0100
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [RFA][PATCH 1/5] ftrace/x86: Run a sync after fixup on failure
Message-ID: <20140227155811.GE22707@pathway.suse.cz>
References: <20140227154616.703252665@goodmis.org>
 <20140227154922.957070805@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227154922.957070805@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-02-14 10:46:17, Steven Rostedt wrote:
> [Request for Ack]
> 
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> If a failure occurs while enabling a trace, it bails out and will remove
> the tracepoints to be back to what the code originally was. But the fix
> up had some bugs in it. By injecting a failure in the code, the fix up
> ran to completion, but shortly afterward the system rebooted.
> 
> There was two bugs here.
> 
> The first was that there was no final sync run across the CPUs after the
> fix up was done, and before the ftrace int3 handler flag was reset. That
> means that other CPUs could still see the breakpoint and trigger on it
> long after the flag was cleared, and the int3 handler would think it was
> a spurious interrupt. Worse yet, the int3 handler could hit other breakpoints
> because the ftrace int3 handler flag would have prevented the int3 handler
> from going further.
> 
> The second bug was that the removal of the breakpoints required the
> "within()" logic updates instead of accessing the ip address directly.
> 
> Link: http://lkml.kernel.org/r/1392650573-3390-1-git-send-email-pmladek@suse.cz
> 
> Reported-by: Petr Mladek <pmladek@suse.cz>

Tested-by: Petr Mladek <pmladek@suse.cz>

> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: stable@vger.kernel.org # 3.5+
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/ftrace.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index e625319..6b566c8 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -455,7 +455,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
>  	}
>  
>   update:
> -	return probe_kernel_write((void *)ip, &nop[0], 1);
> +	return ftrace_write(ip, nop, 1);
>  }
>  
>  static int add_update_code(unsigned long ip, unsigned const char *new)
> @@ -634,6 +634,7 @@ void ftrace_replace_code(int enable)
>  		rec = ftrace_rec_iter_record(iter);
>  		remove_breakpoint(rec);
>  	}
> +	run_sync();
>  }
>  
>  static int
> @@ -664,7 +665,7 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
>  	return ret;
>  
>   fail_update:
> -	probe_kernel_write((void *)ip, &old_code[0], 1);
> +	ftrace_write(ip, old_code, 1);
>  	goto out;
>  }
>  
> -- 
> 1.8.5.3
> 
> 
