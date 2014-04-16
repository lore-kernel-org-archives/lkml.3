Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161157AbaDPNsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:48:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161121AbaDPNsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:48:39 -0400
Date: Wed, 16 Apr 2014 09:48:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Takenori Nagano <t-nagano@ah.jp.nec.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/panic: Add "late_kdump" option for kdump in
 unstable condition
Message-ID: <20140416134830.GA31074@redhat.com>
References: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 01:51:58PM +0900, Masami Hiramatsu wrote:
> Add a "late_kdump" option to run kdump after running panic
> notifiers and dump kmsg. This can help rare situations which
> kdump drops in failure because of unstable crashed kernel
> or hardware failure (memory corruption on critical data/code),
> or the 2nd kernel is broken by the 1st kernel (it's a broken
> behavior, but who can guarantee that the "crashed" kernel
> works correctly?).
> 
> Usage: add "late_kdump" to kernel boot option. That's all.
> 
> Note that this actually increases risks of the failure of
> kdump. This option should be set only if you worry about
> the rare case of kdump failure rather than increasing the
> chance of success.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Satoru MORIYA <satoru.moriya.br@hitachi.com>
> Cc: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
> Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>
> ---
>  Documentation/kernel-parameters.txt |    7 +++++++
>  kernel/panic.c                      |   24 ++++++++++++++++++++++--
>  2 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 03e50b4..1ba58da 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2339,6 +2339,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			timeout < 0: reboot immediately
>  			Format: <timeout>
>  
> +	late_kdump	Run kdump after running panic-notifiers and dumping
> +			kmsg. This only for the users who doubt kdump always
> +			succeeds in any situation.
> +			Note that this also increases risks of kdump failure,
> +			because some panic notifiers can make the crashed
> +			kernel more unstable.
> +

I am wondering if "crash_kexec_post_notifiers" will be a better name
to represent what we are trying to do here.

>  	parkbd.port=	[HW] Parallel port number the keyboard adapter is
>  			connected to, default is 0.
>  			Format: <parport#>
> diff --git a/kernel/panic.c b/kernel/panic.c
> index d02fa9f..bba42b5 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -32,6 +32,7 @@ static unsigned long tainted_mask;
>  static int pause_on_oops;
>  static int pause_on_oops_flag;
>  static DEFINE_SPINLOCK(pause_on_oops_lock);
> +static bool late_kdump;
>  
>  int panic_timeout = CONFIG_PANIC_TIMEOUT;
>  EXPORT_SYMBOL_GPL(panic_timeout);
> @@ -112,9 +113,14 @@ void panic(const char *fmt, ...)
>  	/*
>  	 * If we have crashed and we have a crash kernel loaded let it handle
>  	 * everything else.
> -	 * Do we want to call this before we try to display a message?
> +	 * If we want to call this after we try to display a message, pass
> +	 * the "late_kdump" option to the kernel.
>  	 */
> -	crash_kexec(NULL);
> +	if (!late_kdump)
> +		crash_kexec(NULL);
> +	else
> +		pr_emerg("Warning: late_kdump option is set. Please DO NOT "
> +			"report bugs about kdump failure with this option.\n");

I think above message about DO NOT report bugs seems unnecessary. 

Thanks
Vivek
