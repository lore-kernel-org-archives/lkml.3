Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaKZRpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:45:51 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:58764 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaKZRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:45:49 -0500
MIME-Version: 1.0
In-Reply-To: <1416993266-16514-1-git-send-email-kiran.kumar@linaro.org>
References: <1416993266-16514-1-git-send-email-kiran.kumar@linaro.org>
Date: Wed, 26 Nov 2014 09:45:48 -0800
X-Google-Sender-Auth: FeFZUkc9yeVI6D3lzjfO_C_yKdM
Message-ID: <CAMbhsRR0XzJ9ouYuoE2z+oCR9jRt8XBEfuVgd7sLJMg24bMKyQ@mail.gmail.com>
Subject: Re: [RFC v3] debug: prevent entering debug mode on errors
From: Colin Cross <ccross@android.com>
To: Kiran Raparthy <kiran.kumar@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 1:14 AM, Kiran Raparthy <kiran.kumar@linaro.org> wrote:
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
>         if (arch_kgdb_ops.enable_nmi)
>                 arch_kgdb_ops.enable_nmi(0);
> +       /*
> +        * Avoid entering the debugger if we were triggered due to an oops
> +        * but panic_timeout indicates the system should automatically
> +        * reboot on panic. We don't want to get stuck waiting for input
> +        * on such systems, especially if its "just" an oops.
> +        */
> +       if (signo != SIGTRAP && panic_timeout)
> +               return 1;
>
>         memset(ks, 0, sizeof(struct kgdb_state));
>         ks->cpu                 = raw_smp_processor_id();
> @@ -821,6 +829,15 @@ static int kgdb_panic_event(struct notifier_block *self,
>                             unsigned long val,
>                             void *data)
>  {
> +       /*
> +        * Avoid entering the debugger if we were triggered due to a panic
> +        * We don't want to get stuck waiting for input from user in such case.
> +        * panic_timeout indicates the system should automatically
> +        * reboot on panic.
> +        */
> +       if (panic_timeout)
> +               return NOTIFY_DONE;
> +
>         if (dbg_kdb_mode)
>                 kdb_printf("PANIC: %s\n", (char *)data);
>         kgdb_breakpoint();
> --
> 1.8.2.1
>
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.

The original patch was more useful as it allowed re-enabling break on
panic on specific devices where you were trying to debug a
reproducible issue.  What about using a module_param similar to
kgdbreboot, but setting the default based on CONFIG_PANIC_TIMEOUT to
avoid extra configuration?
