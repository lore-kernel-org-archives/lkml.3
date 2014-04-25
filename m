Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaDYRra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:47:30 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:4548 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaDYRrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:47:24 -0400
Message-ID: <535A9FA0.6030104@free.fr>
Date: Fri, 25 Apr 2014 19:47:12 +0200
From: mathieu souchaud <mattieu.souchaud@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: tony.luck@intel.com, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] x86/mce: Improve mcheck_init_device() error handling.
References: <1398447604-21471-1-git-send-email-mattieu.souchaud@free.fr>
In-Reply-To: <1398447604-21471-1-git-send-email-mattieu.souchaud@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch, unwindind is still not perfect from the 
mce_device_create() calls. I guess, from this point, on error we should 
call mce_device_remove on every created device. But I think this will 
make the code rather complex. And I am not too confident on this kind of 
modification as I don't know much about MCE.

Mathieu S.

Le 25/04/2014 19:40, Mathieu Souchaud a écrit :
> Check return code of every function called.
>
> Signed-off-by: Mathieu Souchaud <mattieu.souchaud@free.fr>
> ---
>   arch/x86/kernel/cpu/mcheck/mce.c |   30 +++++++++++++++++++++++-------
>   1 file changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 68317c8..b865285 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2437,33 +2437,49 @@ static __init int mcheck_init_device(void)
>   	int err;
>   	int i = 0;
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
>   	mce_init_banks();
>   
>   	err = subsys_system_register(&mce_subsys, NULL);
>   	if (err)
> -		return err;
> +		goto err_out_mem;
>   
>   	cpu_notifier_register_begin();
>   	for_each_online_cpu(i) {
>   		err = mce_device_create(i);
>   		if (err) {
>   			cpu_notifier_register_done();
> -			return err;
> +			goto err_out_mem;
>   		}
>   	}
>   
>   	register_syscore_ops(&mce_syscore_ops);
> -	__register_hotcpu_notifier(&mce_cpu_notifier);
> +	err = __register_hotcpu_notifier(&mce_cpu_notifier);
>   	cpu_notifier_register_done();
> +	if (err)
> +		goto err_out_mem;
>   
>   	/* register character device /dev/mcelog */
> -	misc_register(&mce_chrdev_device);
> +	err = misc_register(&mce_chrdev_device);
> +	if (err)
> +		goto err_out_mem;
> +
> +	return 0;
> +
> +err_out_mem:
> +	free_cpumask_var(mce_device_initialized);
>   
> +err_out:
> +	pr_err("Unable to init device /dev/mcelog (rc: %d)\n", err);
>   	return err;
>   }
>   device_initcall_sync(mcheck_init_device);

