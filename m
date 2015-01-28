Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbbA2DZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:25:01 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47610 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761520AbbA2DYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:24:55 -0500
Message-ID: <54C8C017.4050202@linaro.org>
Date: Wed, 28 Jan 2015 10:55:19 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Kiran Raparthy <kiran.kumar@linaro.org>, linux-kernel@vger.kernel.org
CC: kgdb-bugreport@lists.sourceforge.net, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [Kgdb-bugreport] [RFC v5 - RESEND] debug: prevent entering debug
 mode on panic/exception.
References: <1422441574-24005-1-git-send-email-kiran.kumar@linaro.org>
In-Reply-To: <1422441574-24005-1-git-send-email-kiran.kumar@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 10:39, Kiran Raparthy wrote:
> From: Colin Cross <ccross@android.com>
> 
> debug: prevent entering debug mode on panic/exception.
> 
> On non-developer devices, kgdb prevents the device from rebooting
> after a panic.
> 
> Incase of panics and exceptions, to allow the device to reboot, prevent entering
> debug mode to avoid getting stuck waiting for the user to interact with debugger.
> 
> To avoid entering the debugger on panic/exception without any extra configuration,
> panic_timeout is being used which can be set via /proc/sys/kernel/panic at run time
> and CONFIG_PANIC_TIMEOUT sets the default value.
> 
> Setting panic_timeout indicates that the user requested machine to perform
> unattended reboot after panic. We dont want to get stuck waiting for the user
> input incase of panic.

Some kind of changelog between the versions would have been nice. I
*think* the difference between v4 and v5 was just the addition paragraph
above but I had to put in extra work to check that and I'm still not
100% sure that's the only change.

Also you could start billing this as a PATCH rather than an RFC.


Daniel.


> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: kgdb-bugreport@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Signed-off-by: Colin Cross <ccross@android.com>
> [Kiran: Added context to commit message.
> panic_timeout is used instead of break_on_panic and
> break_on_exception to honor CONFIG_PANIC_TIMEOUT
> Modified the commit as per community feedback]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  kernel/debug/debug_core.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
> index 1adf62b..0012a1f 100644
> --- a/kernel/debug/debug_core.c
> +++ b/kernel/debug/debug_core.c
> @@ -689,6 +689,14 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
>  
>  	if (arch_kgdb_ops.enable_nmi)
>  		arch_kgdb_ops.enable_nmi(0);
> +	/*
> +	 * Avoid entering the debugger if we were triggered due to an oops
> +	 * but panic_timeout indicates the system should automatically
> +	 * reboot on panic. We don't want to get stuck waiting for input
> +	 * on such systems, especially if its "just" an oops.
> +	 */
> +	if (signo != SIGTRAP && panic_timeout)
> +		return 1;
>  
>  	memset(ks, 0, sizeof(struct kgdb_state));
>  	ks->cpu			= raw_smp_processor_id();
> @@ -821,6 +829,15 @@ static int kgdb_panic_event(struct notifier_block *self,
>  			    unsigned long val,
>  			    void *data)
>  {
> +	/*
> +	 * Avoid entering the debugger if we were triggered due to a panic
> +	 * We don't want to get stuck waiting for input from user in such case.
> +	 * panic_timeout indicates the system should automatically
> +	 * reboot on panic.
> +	 */
> +	if (panic_timeout)
> +		return NOTIFY_DONE;
> +
>  	if (dbg_kdb_mode)
>  		kdb_printf("PANIC: %s\n", (char *)data);
>  	kgdb_breakpoint();
> 

