Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaDYKnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:43:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38207 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaDYKnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:43:22 -0400
Date: Fri, 25 Apr 2014 12:42:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mathieu Souchaud <mattieu.souchaud@free.fr>
Cc: tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] x86/mce: Check misc_register() return code.
Message-ID: <20140425104256.GB18540@nazgul.tnic>
References: <1398419295-18590-1-git-send-email-mattieu.souchaud@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398419295-18590-1-git-send-email-mattieu.souchaud@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 11:48:15AM +0200, Mathieu Souchaud wrote:
> The current code does not check the return from misc_register() so set
> the return variable with the return code of misc_register.
> 
> Signed-off-by: Mathieu Souchaud <mattieu.souchaud@free.fr>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 68317c8..45fb7aa 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2462,7 +2462,7 @@ static __init int mcheck_init_device(void)
>  	cpu_notifier_register_done();
>  
>  	/* register character device /dev/mcelog */
> -	misc_register(&mce_chrdev_device);
> +	err = misc_register(&mce_chrdev_device);

This function mcheck_init_device() is a one big sloppy mess
of not handling the error cases responsibly. It doesn't check
zalloc_cpumask_var() retval, it doesn't free the mce_device_initialized
when subsys_system_register() fails, the same when mce_device_create
fails, the same with __register_hotcpu_notifier and finally with
misc_register.

Would you be willing to fix this properly with goto labels and proper
unwinding, like it is done in other, saner places in the kernel, and
at the end maybe add a printk for the error case warning us that
/dev/mcelog didn't get registered?

That would be a very nice cleanup! :-)

Thanks.
