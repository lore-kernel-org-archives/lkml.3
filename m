Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaAOBEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:04:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:13287 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750928AbaAOBEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:04:47 -0500
Date: Tue, 14 Jan 2014 20:04:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 6/8] x86: modify ftrace function using the new
 int3-based framework
Message-ID: <20140114200445.6c1ce0ea@gandalf.local.home>
In-Reply-To: <1386690140-19941-7-git-send-email-pmladek@suse.cz>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	<1386690140-19941-7-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 16:42:18 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> The commit fd4363fff3d9 (x86: Introduce int3 (breakpoint)-based instruction
> patching) uses the same technique that has been used in ftrace since 08d636b
> ("ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine")
> 
> It would be great to use the new generic implementation and clean up the x86
> ftrace code a bit.
> 
> Let's start with ftrace_modify_code. It does basically the same as text_poke_bp.
> In addition, it checks whether the replaced code is the expected one to avoid
> problems with modules. The checking code can be split from
> ftrace_modify_code_direct.
> 
> Note that we do not longer need to set modifying_ftrace_code in
> ftrace_update_ftrace_func. The int3 interrupt will be handled by
> poke_int3_handler.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  arch/x86/kernel/ftrace.c | 120 +++++++++++++++++++----------------------------
>  1 file changed, 47 insertions(+), 73 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index d4bdd253fea7..5ade40e4a175 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -52,6 +52,33 @@ union ftrace_code_union {
>  	} __attribute__((packed));
>  };
>  
> +/*
> + * Note: Due to modules and __init, code can
> + *  disappear and change, we need to protect against faulting
> + *  as well as code changing. We do this by using the
> + *  probe_kernel_* functions.

Actually the above comment is no longer accurate. I know that you just
copied it from my code, and this is my fault. But instead of keeping an
inaccurate comment around, lets fix it.

/*
 * Note: Modifying kernel code is extremely critical to get right.
 *  We must try to detect any error, and we should only change code
 *  with code that we expect to be changed. Always test that the old
 *  text is what we expect it to be before we modify it, and fail
 *  if it is not.
 */

> + */
> +static int
> +ftrace_check_code(unsigned long ip, unsigned const char *expected)
> +{
> +	unsigned char actual[MCOUNT_INSN_SIZE];
> +
> +	if (probe_kernel_read(actual, (void *)ip, MCOUNT_INSN_SIZE))
> +		return -EFAULT;
> +
> +	if (memcmp(actual, expected, MCOUNT_INSN_SIZE) != 0) {
> +		WARN_ONCE(1,
> +			  "ftrace check failed: %x %x%x%x%x vs. %x %x%x%x%x\n",
> +			  actual[0],
> +			  actual[1], actual[2], actual[3], actual[4],
> +			  expected[0],
> +			  expected[1], expected[2], expected[3], expected[4]);
> +		return -EINVAL;

Hmm, I guess I'm fine with warning here like this, but it is also
covered in kernel/ftrace.c too, with the return code o -EINVAL.

But duplicate warnings may not be that bad.

> +	}
> +
> +	return 0;
> +}
> +
>  static int ftrace_calc_offset(long ip, long addr)
>  {
>  	return (int)(addr - ip);
> @@ -103,28 +130,12 @@ static int
>  ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
>  		   unsigned const char *new_code)
>  {
> -	unsigned char replaced[MCOUNT_INSN_SIZE];
> -
> -	/*
> -	 * Note: Due to modules and __init, code can
> -	 *  disappear and change, we need to protect against faulting
> -	 *  as well as code changing. We do this by using the
> -	 *  probe_kernel_* functions.
> -	 *
> -	 * No real locking needed, this code is run through
> -	 * kstop_machine, or before SMP starts.
> -	 */
> +	int ret;
>  
> -	/* read the text we want to modify */
> -	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
> -		return -EFAULT;
> -
> -	/* Make sure it is what we expect it to be */
> -	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
> -		return -EINVAL;
> +	ret = ftrace_check_code(ip, old_code);

Wait? If this fails, why not return with ret? Otherwise, we just
returned with success!

-- Steve

>  
>  	/* replace the text with the new text */
> -	if (do_ftrace_mod_code(ip, new_code))
> +	if (!ret && do_ftrace_mod_code(ip, new_code))
>  		return -EPERM;
>  
>  	sync_core();
> @@ -132,6 +143,22 @@ ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
>  	return 0;
>  }
>  
> +static int
> +ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
> +		   unsigned const char *new_code)
> +{
> +	int ret;
> +
> +	ret = ftrace_check_code(ip, old_code);
> +
> +	/* replace the text with the new text */
> +	if (!ret)
> +		ret = text_poke_bp((void *)ip, new_code, MCOUNT_INSN_SIZE,
> +				   (void *)ip + MCOUNT_INSN_SIZE);
> +
> +	return ret;
> +}
> +
