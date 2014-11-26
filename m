Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaKZJ01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:26:27 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63918 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKZJ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:26:22 -0500
Message-ID: <54759CB6.9020704@linaro.org>
Date: Wed, 26 Nov 2014 09:26:14 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kiran Raparthy <kiran.kumar@linaro.org>, linux-kernel@vger.kernel.org
CC: Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v3] debug: prevent entering debug mode on errors
References: <1416993266-16514-1-git-send-email-kiran.kumar@linaro.org>
In-Reply-To: <1416993266-16514-1-git-send-email-kiran.kumar@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 09:14, Kiran Raparthy wrote:
> From: Colin Cross <ccross@android.com>
> 
> debug: prevent entering debug mode on errors
> 
> On non-developer devices kgdb prevents CONFIG_PANIC_TIMEOUT from rebooting the
> device after a panic.
> 
> In case of panics and exceptions, to honor CONFIG_PANIC_TIMEOUT, prevent
> entering debug mode to avoid getting stuck waiting for the user to interact
> with debugger.
> 
> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: kgdb-bugreport@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Signed-off-by: Colin Cross <ccross@android.com>
> [Kiran: Added context to commit message.
> panic_timeout is used instead of break_on_panic and
> break_on_exception to honor CONFIG_PANIC_TIMEOUT]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>

When this gets upgrade from RFC to PATCH then feel free to add:
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>

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

