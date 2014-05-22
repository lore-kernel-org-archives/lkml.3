Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaEVJxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:53:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49061 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbaEVJxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:53:38 -0400
Date: Thu, 22 May 2014 11:53:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mathieu Souchaud <mattieu.souchaud@free.fr>
Cc: tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] x86/mce: Improve mcheck_init_device() error handling
Message-ID: <20140522095333.GD4383@pd.tnic>
References: <1399151031-19905-1-git-send-email-mattieu.souchaud@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399151031-19905-1-git-send-email-mattieu.souchaud@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 11:03:51PM +0200, Mathieu Souchaud wrote:
> Check return code of every function called by mcheck_init_device().
> 
> Signed-off-by: Mathieu Souchaud <mattieu.souchaud@free.fr>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   49 +++++++++++++++++++++++++++++++-------
>  1 file changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 68317c8..284cfad 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2437,32 +2437,65 @@ static __init int mcheck_init_device(void)
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
> -			cpu_notifier_register_done();
> -			return err;
> +			goto err_device_create;
>  		}

No need for curly braces {} around a single if-statement.

>  	}
>  
>  	register_syscore_ops(&mce_syscore_ops);

Ok, I see it now. Your patch is correct but the way the error labels
get placed it is hard to see that the cpu hotplug mutex is taken and
released in the right order, even on the error path.

So, can we try to simplify this and make it more obvious? I.e., we take
register_syscore_ops out of the way of the hotplug region:

---
	cpu_notifier_register_begin();
	for_each_online_cpu(i) {
		err = mce_device_create(i);
		if (err) {
			cpu_notifier_register_done();
			goto err_device_create;
		}
	}

	__register_hotcpu_notifier(&mce_cpu_notifier);
	cpu_notifier_register_done();
---

Also, as you've noticed we've dropped the __register_hotcpu_notifier
retval because that function returns 0 unconditionally. Which is very
smart, btw.</sarcasm>

This way, in the hotplug mutex region we have only cpu hotplug-relevant
operations which one can verify at a glance.

Then, we do

---
	register_syscore_ops(&mce_syscore_ops);
---

Then, the error path looks simpler too:

---
err_register:
	unregister_syscore_ops(&mce_syscore_ops);
	cpu_notifier_register_begin();
	__unregister_hotcpu_notifier(&mce_cpu_notifier);
	cpu_notifier_register_done();

err_device_create:
	/*
	 * mce_device_remove behave properly if mce_device_create was not
	 * called on that device.
	 */
	for_each_possible_cpu(i)
		mce_device_remove(i);
---

We don't need to grab the hotplug lock when iterating over the possible
cpus because we don't care whether they're online or not, I'd say.

So what do you think, makes sense? You probably would need to apply the
patch and look at the code - it is easier at least to me.

Here's the whole diff with the new changes incorporated. If no one
complains, feel free to incorporate this into your v3 along with the
remaining feedback.

Thanks for your patience.

---
Index: b/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- a/arch/x86/kernel/cpu/mcheck/mce.c	2014-05-22 11:04:25.006626559 +0200
+++ b/arch/x86/kernel/cpu/mcheck/mce.c	2014-05-22 11:47:50.102583505 +0200
@@ -2437,32 +2437,63 @@ static __init int mcheck_init_device(voi
 	int err;
 	int i = 0;
 
-	if (!mce_available(&boot_cpu_data))
-		return -EIO;
+	if (!mce_available(&boot_cpu_data)) {
+		err = -EIO;
+		goto err_out;
+	}
 
-	zalloc_cpumask_var(&mce_device_initialized, GFP_KERNEL);
+	if (!zalloc_cpumask_var(&mce_device_initialized, GFP_KERNEL)) {
+		err = -ENOMEM;
+		goto err_out;
+	}
 
 	mce_init_banks();
 
 	err = subsys_system_register(&mce_subsys, NULL);
 	if (err)
-		return err;
+		goto err_out_mem;
 
 	cpu_notifier_register_begin();
 	for_each_online_cpu(i) {
 		err = mce_device_create(i);
 		if (err) {
 			cpu_notifier_register_done();
-			return err;
+			goto err_device_create;
 		}
 	}
 
-	register_syscore_ops(&mce_syscore_ops);
 	__register_hotcpu_notifier(&mce_cpu_notifier);
 	cpu_notifier_register_done();
 
+	register_syscore_ops(&mce_syscore_ops);
+
 	/* register character device /dev/mcelog */
-	misc_register(&mce_chrdev_device);
+	err = misc_register(&mce_chrdev_device);
+	if (err)
+		goto err_register;
+
+	return 0;
+
+err_register:
+	unregister_syscore_ops(&mce_syscore_ops);
+
+	cpu_notifier_register_begin();
+	__unregister_hotcpu_notifier(&mce_cpu_notifier);
+	cpu_notifier_register_done();
+
+err_device_create:
+	/*
+	 * mce_device_remove behave properly if mce_device_create was not
+	 * called on that device.
+	 */
+	for_each_possible_cpu(i)
+		mce_device_remove(i);
+
+err_out_mem:
+	free_cpumask_var(mce_device_initialized);
+
+err_out:
+	pr_err("Unable to init device /dev/mcelog (rc: %d)\n", err);
 
 	return err;
 }

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
