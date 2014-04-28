Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbaD1Tg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:36:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48445 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483AbaD1Tgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:36:55 -0400
Date: Mon, 28 Apr 2014 21:36:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mathieu Souchaud <mattieu.souchaud@free.fr>
Cc: tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] x86/mce: Improve mcheck_init_device() error handling.
Message-ID: <20140428193640.GD31522@pd.tnic>
References: <1398447604-21471-1-git-send-email-mattieu.souchaud@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398447604-21471-1-git-send-email-mattieu.souchaud@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 07:40:04PM +0200, Mathieu Souchaud wrote:
> Check return code of every function called.
> 
> Signed-off-by: Mathieu Souchaud <mattieu.souchaud@free.fr>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 68317c8..b865285 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2437,33 +2437,49 @@ static __init int mcheck_init_device(void)
>  	int err;
>  	int i = 0;
>  
> -	if (!mce_available(&boot_cpu_data))
> -		return -EIO;
> +	if (!mce_available(&boot_cpu_data)) {
> +		err = -EIO;
> +		goto err_out;
> +	}
>  
> -	zalloc_cpumask_var(&mce_device_initialized, GFP_KERNEL);
> +	if (!zalloc_cpumask_var(&mce_device_initialized, GFP_KERNEL)) {
> +		err = -ENOMEM;
> +		goto err_out;
> +	}
>  
>  	mce_init_banks();
>  
>  	err = subsys_system_register(&mce_subsys, NULL);
>  	if (err)
> -		return err;
> +		goto err_out_mem;
>  
>  	cpu_notifier_register_begin();
>  	for_each_online_cpu(i) {
>  		err = mce_device_create(i);
>  		if (err) {
>  			cpu_notifier_register_done();
> -			return err;
> +			goto err_out_mem;

Actually, this should partially unwind what has been created already,
like this:

		if (err)
			goto err_device_create;

and then at that label, you can do:

err_device_create:
	while (--i > 0)
		mce_device_remove(i);
	cpu_notifier_register_done();

And then here come your other labels:

err_out_mem:
 ....

And so on. Makes sense?

>  	register_syscore_ops(&mce_syscore_ops);
> -	__register_hotcpu_notifier(&mce_cpu_notifier);
> +	err = __register_hotcpu_notifier(&mce_cpu_notifier);
>  	cpu_notifier_register_done();
> +	if (err)
> +		goto err_out_mem;

This needs to be a label which goes before err_device_create above and
which does

err_reg_hotcpu:
	unregister_syscore_ops(&mce_syscore_ops);

>  
>  	/* register character device /dev/mcelog */
> -	misc_register(&mce_chrdev_device);
> +	err = misc_register(&mce_chrdev_device);
> +	if (err)
> +		goto err_out_mem;

And this has to go to the top-label which unwinds all the work, along
with the mce percpu devices like:

	for_each_online_cpu(i)
		mce_device_remove(i);

	unregister_hotcpu_notifier(&mce_cpu_notifier);

	...

and so on.

Ok, am I making sense?

Don't be afraid to give it a try, even if it is wrong - we'll get it
right eventually :-)

For testing, you can use a kvm guest and "inject" errors in the
registration code just to see whether it works as expected.

And feel free to ask questions if something's not clear.

Thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
