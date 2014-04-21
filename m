Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaDUNUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:20:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbaDUNUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:20:47 -0400
Date: Mon, 21 Apr 2014 08:30:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: Re: [PATCH v3] kernel/panic: Add "crash_kexec_post_notifiers" option
 for kdump after panic_notifers
Message-ID: <20140421123032.GC22181@redhat.com>
References: <20140421013348.6719.6959.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421013348.6719.6959.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 10:33:48AM +0900, Masami Hiramatsu wrote:
> Add a "crash_kexec_post_notifiers" option to run kdump after running
> panic_notifiers and dump kmsg. This can help rare situations which
> kdump drops in failure because of unstable crashed kernel or hardware
> failure (memory corruption on critical data/code), or the 2nd kernel
> is already broken by the 1st kernel (it's a broken behavior, but who
> can guarantee that the "crashed" kernel works correctly?).
> 
> Usage: add "crash_kexec_post_notifiers" to kernel boot option.
> 
> Note that this actually increases risks of the failure of kdump.
> This option should be set only if you worry about the rare case
> of kdump failure rather than increasing the chance of success.
> 
> Changes from v2:
>  - Remove warning message according to Vivek's comment.
> 
> Changes from v1:
>  - Rename late_kdump option to crash_kexec_post_notifiers.
>  - Remove unneeded warning message.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Acked-by: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Satoru MORIYA <satoru.moriya.br@hitachi.com>
> Cc: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
> ---
>  Documentation/kernel-parameters.txt |    8 ++++++++
>  kernel/panic.c                      |   23 +++++++++++++++++++++--
>  2 files changed, 29 insertions(+), 2 deletions(-)

I think let us do it. Quite a few people have been asking for allowing
to run hook for saving kernel buffers to NVRAM before we transition into
kdump kernel. 

I understand that it opens flood gate for every kind of hook to be
executed but that's the not default and if user decides to set
crash_kexec_post_notifiers, they understand that they are increasing
the chances of kdump failures.

If they decide to do that, they need to live with this trade-off.

We have pushed back on this for a very long time. I guess it is time to
give it a chance and see how does it go. Does it really help those who
want to do run notifiers before kdump kicks in.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 03e50b4..1df416b 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2339,6 +2339,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			timeout < 0: reboot immediately
>  			Format: <timeout>
>  
> +	crash_kexec_post_notifiers
> +			Run kdump after running panic-notifiers and dumping
> +			kmsg. This only for the users who doubt kdump always
> +			succeeds in any situation.
> +			Note that this also increases risks of kdump failure,
> +			because some panic notifiers can make the crashed
> +			kernel more unstable.
> +
>  	parkbd.port=	[HW] Parallel port number the keyboard adapter is
>  			connected to, default is 0.
>  			Format: <parport#>
> diff --git a/kernel/panic.c b/kernel/panic.c
> index d02fa9f..30c4a1c 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -32,6 +32,7 @@ static unsigned long tainted_mask;
>  static int pause_on_oops;
>  static int pause_on_oops_flag;
>  static DEFINE_SPINLOCK(pause_on_oops_lock);
> +static bool crash_kexec_post_notifiers;
>  
>  int panic_timeout = CONFIG_PANIC_TIMEOUT;
>  EXPORT_SYMBOL_GPL(panic_timeout);
> @@ -112,9 +113,11 @@ void panic(const char *fmt, ...)
>  	/*
>  	 * If we have crashed and we have a crash kernel loaded let it handle
>  	 * everything else.
> -	 * Do we want to call this before we try to display a message?
> +	 * If we want to run this after calling panic_notifiers, pass
> +	 * the "crash_kexec_post_notifiers" option to the kernel.
>  	 */
> -	crash_kexec(NULL);
> +	if (!crash_kexec_post_notifiers)
> +		crash_kexec(NULL);
>  
>  	/*
>  	 * Note smp_send_stop is the usual smp shutdown function, which
> @@ -131,6 +134,15 @@ void panic(const char *fmt, ...)
>  
>  	kmsg_dump(KMSG_DUMP_PANIC);
>  
> +	/*
> +	 * If you doubt kdump always works fine in any situation,
> +	 * "crash_kexec_post_notifiers" offers you a chance to run 
> +	 * panic_notifiers and dumping kmsg before kdump.
> +	 * Note: since some panic_notifiers can make crashed kernel
> +	 * more unstable, it can increase risks of the kdump failure too.
> +	 */
> +	crash_kexec(NULL);
> +
>  	bust_spinlocks(0);
>  
>  	if (!panic_blink)
> @@ -472,6 +484,13 @@ EXPORT_SYMBOL(__stack_chk_fail);
>  core_param(panic, panic_timeout, int, 0644);
>  core_param(pause_on_oops, pause_on_oops, int, 0644);
>  
> +static int __init setup_crash_kexec_post_notifiers(char *s)
> +{
> +	crash_kexec_post_notifiers = true;
> +	return 0;
> +}
> +early_param("crash_kexec_post_notifiers", setup_crash_kexec_post_notifiers);
> +
>  static int __init oops_setup(char *s)
>  {
>  	if (!s)
> 
