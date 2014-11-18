Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaKRRNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:13:17 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57868 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaKRRNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:13:14 -0500
Message-ID: <546B7E21.4000602@linaro.org>
Date: Tue, 18 Nov 2014 17:13:05 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>,
        linux-kernel@vger.kernel.org
CC: Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC] debug: add parameters to prevent entering debug mode on
 errors
References: <1416312516-4551-1-git-send-email-kiran.kumar@linaro.org>
In-Reply-To: <1416312516-4551-1-git-send-email-kiran.kumar@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/11/14 12:08, Kiran Kumar Raparthy wrote:
> From: Colin Cross <ccross@android.com>
> 
> debug: add parameters to prevent entering debug mode on errors
> 
> On non-developer devices kgdb prevents CONFIG_PANIC_TIMEOUT from rebooting the
> device after a panic. Add module parameters debug_core.break_on_exception and
> debug_core.break_on_panic to allow skipping debug on panics and exceptions
> respectively.  Both default to true to preserve existing behavior.

I am a little unsure about break_on_panic.

It ought to be possible for kgdb/kdb to honour CONFIG_PANIC_TIMEOUT by
tracking how long it takes for the user to attach a debugger (or to run
the first kdb command after the panic). As it happens the timeout value
is already an exported kernel symbol so all the info it there for us to
use...

Doing so would save us imposing further configuration burden on the user
(although it would be a good deal more code).

Note that I can't think of an automatic way to handle break_on_exception
so I'm less worried about that one.


> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: kgdb-bugreport@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Signed-off-by: Colin Cross <ccross@android.com>
> [Kiran: Added context to commit message]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
> This is one of the number of patches from the Android AOSP common.git tree,
> which is used on almost all Android devices.  I wanted to submit it for review
> to see if it should go upstream.
> 
>  kernel/debug/debug_core.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
> index 1adf62b..af06122 100644
> --- a/kernel/debug/debug_core.c
> +++ b/kernel/debug/debug_core.c
> @@ -87,6 +87,10 @@ static int kgdb_use_con;
>  bool dbg_is_early = true;
>  /* Next cpu to become the master debug core */
>  int dbg_switch_cpu;
> +/* Flag for entering kdb when a panic occurs */
> +static bool break_on_panic = true;
> +/* Flag for entering kdb when an exception occurs */
> +static bool break_on_exception = true;
>  
>  /* Use kdb or gdbserver mode */
>  int dbg_kdb_mode = 1;
> @@ -101,6 +105,8 @@ early_param("kgdbcon", opt_kgdb_con);
>  
>  module_param(kgdb_use_con, int, 0644);
>  module_param(kgdbreboot, int, 0644);
> +module_param(break_on_panic, bool, 0644);
> +module_param(break_on_exception, bool, 0644);

kgdbreboot, which controls whether or not to trap into kgdb during
reboot, has a similar purpose to these new parameters. Perhaps any new
symbols should follow a similar naming scheme.

>  /*
>   * Holds information about breakpoints in a kernel. These breakpoints are
> @@ -690,6 +696,9 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
>  	if (arch_kgdb_ops.enable_nmi)
>  		arch_kgdb_ops.enable_nmi(0);
>  
> +	if (unlikely(signo != SIGTRAP && !break_on_exception))

This is nit picking but...

There should be no need to predict branch results here. Its not
performance critical and anyway the "fast" path implied by the
unlikely() results in all CPUs screaming to a halt and burning up
millions of cycles waiting for user input.

> +		return 1;
> +
>  	memset(ks, 0, sizeof(struct kgdb_state));
>  	ks->cpu			= raw_smp_processor_id();
>  	ks->ex_vector		= evector;
> @@ -821,6 +830,9 @@ static int kgdb_panic_event(struct notifier_block *self,
>  			    unsigned long val,
>  			    void *data)
>  {
> +	if (!break_on_panic)
> +		return NOTIFY_DONE;
> +
>  	if (dbg_kdb_mode)
>  		kdb_printf("PANIC: %s\n", (char *)data);
>  	kgdb_breakpoint();
> 

