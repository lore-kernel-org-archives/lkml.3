Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaEWKzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:55:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44243 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbaEWKyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:54:44 -0400
Date: Fri, 23 May 2014 12:54:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.jf.intel.com>,
        Aiden Park <aiden.park@intel.com>
Subject: Re: [RFC] Unnecessary work and noise from mce code in suspend/resume
 path
Message-ID: <20140523105439.GD21332@pd.tnic>
References: <5373bdc83257044f09@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5373bdc83257044f09@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 12:02:32PM -0700, Luck, Tony wrote:
> When we suspend a laptop we offline all but one processor. But
> the mce code registers on a notify chain so it can clean up
> some sysfs entries. Part of that code calls device_unregister()
> which will fire kobject_uevent() which might wake up some user
> code that is watching for such things.

The issue being?

It is not clear from the text what actually is the problem.

> Patch below from Aiden Park works around the issue by avoiding 
> the device_unregister()/device_register() by just keeping track
> of the original device registrations.
> 
> 1) Is there a better way to avoid the kobject_uevent()?
> 2) What user code actually uses all these sysfs files?
>    Some test code in mcelog(8) uses:
>         /sys/devices/system/machinecheck/machinecheck0/trigger
>    Some code in mce-test package adjusts
>         /sys/devices/system/machinecheck/machinecheck0/tolerant
>    But neither of these make use of all the per-cpu instances
>    created/destroyed on every suspend/resume (or logical processor
>    offline).  Should we just move these out of per-cpu directories
>    and scrap this whole block of code?

Oh, I'd love to.

Especially "trigger" - it wants to be in debugfs anyway. The "tolerant"
deal we probably need to discuss a bit more. Exposing MCE tolerance
levels even to root is not such a good idea and this tolerant thing is
primarily used in testing, AFAICT, so that the box doesn't actually
panic when you inject errors and so on...

> 3) checkpatch isn't happy about use of NR_CPUS I suspect the
>    usage here warrants for_each_possible_cpu()

Right.

> -Tony Luck
> ---
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> old mode 100644
> new mode 100755

Something decided to make mce.c an executable script :-)

> index 68317c80de7f..e49302f24ce5
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -113,6 +113,8 @@ static DEFINE_PER_CPU(struct work_struct, mce_work);
>  
>  static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
>  
> +static struct device *mce_devices[NR_CPUS];
> +
>  /*
>   * CPU/chipset specific EDAC code can register a notifier call here to print
>   * MCE errors in a human-readable form.
> @@ -2060,7 +2062,18 @@ static int mce_syscore_suspend(void)
>  
>  static void mce_syscore_shutdown(void)
>  {
> +	int i = 0;
> +	struct device *dev;
> +
>  	mce_disable_error_reporting();
> +
> +	for (i = 0; i < NR_CPUS; i++) {

WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
#64: FILE: arch/x86/kernel/cpu/mcheck/mce.c:2070:
+       for (i = 0; i < NR_CPUS; i++) {


> +		dev = mce_devices[i];
> +		if (dev) {
> +			device_unregister(dev);
> +			mce_devices[i] = NULL;
> +		}
> +	}
>  }
>  
>  /*
> @@ -2272,23 +2285,27 @@ static void mce_device_release(struct device *dev)
>  static int mce_device_create(unsigned int cpu)
>  {
>  	struct device *dev;
> -	int err;
> +	int err = 0;
>  	int i, j;
>  
>  	if (!mce_available(&boot_cpu_data))
>  		return -EIO;
>  
> -	dev = kzalloc(sizeof *dev, GFP_KERNEL);
> -	if (!dev)
> -		return -ENOMEM;
> -	dev->id  = cpu;
> -	dev->bus = &mce_subsys;
> -	dev->release = &mce_device_release;
> +	dev = mce_devices[cpu];
> +	if (!dev) {
> +		dev = kzalloc(sizeof *dev, GFP_KERNEL);

Please run through checkpatch:

WARNING: sizeof *dev should be sizeof(*dev)
#93: FILE: arch/x86/kernel/cpu/mcheck/mce.c:2296:
+               dev = kzalloc(sizeof *dev, GFP_KERNEL);

> +		if (!dev)
> +			return -ENOMEM;
> +		dev->id  = cpu;
> +		dev->bus = &mce_subsys;
> +		dev->release = &mce_device_release;
>  
> -	err = device_register(dev);
> -	if (err) {
> -		put_device(dev);
> -		return err;
> +		err = device_register(dev);
> +		if (err) {
> +			put_device(dev);
> +			return err;
> +		}
> +		mce_devices[cpu] = dev;

Ok, in any case, AFAIU it is a mechanism to cache those mce_devices and
not generate them every time we come from suspend.

And we have those mce_device per cpu vars which we use too. So this one
adds another array of mce_devices.

Dumb question: would it be possible to save us all that init/teardown
everytime and simply toggle their visibility in sysfs instead? I mean,
maybe play with device_create_file/device_remove_file only and hand it
down those struct device *dev things we have cached per-cpu.

This will definitely save us the kobject_uevent() calls.

But it could be that I'm missing something obvious...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
