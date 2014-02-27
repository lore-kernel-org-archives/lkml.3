Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaB0Adt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:33:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaB0Ads (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:33:48 -0500
Date: Wed, 26 Feb 2014 16:33:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ales Novak <alnovak@suse.cz>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] rtc: fix chardev initialization races
Message-Id: <20140226163347.44eed76271b86c1021471e38@linux-foundation.org>
In-Reply-To: <1393410793-7315-1-git-send-email-alnovak@suse.cz>
References: <1393410793-7315-1-git-send-email-alnovak@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 11:33:13 +0100 Ales Novak <alnovak@suse.cz> wrote:

> In many rtc modules, the chardevice file in rtc module probe is
> being created prematurely. If the probe fails after the chardevice
> file has been created (e.g. after rtc_device_register), it's possible
> for a program to open() it, which subsequently can cause memory
> corruption.
> 
> The race looks like that (thanks Jiri):
> 
> CPU0:                                CPU1:
> sys_load_module()
>  do_init_module()
>   do_one_initcall()
>    cmos_do_probe()
>     rtc_device_register()
>      __register_chrdev()
>      cdev->owner = struct module*
>                                      open("/dev/rtc0")
>     rtc_device_unregister()
>   module_put()
>   free_module()
>    module_free(mod->module_core)
>    /* struct module *module is now
>       freed */
>                                       chrdev_open()
>                                        spin_lock(cdev_lock)
>                                        cdev_get()
>                                         try_module_get()
>                                          module_is_live()
>                                          /* dereferences already
>                                             freed struct module* */
> 
> This patch is proposing a solution, splitting the function
> {devm_,}rtc_device_register into {devm_,}rtc_device_register{_fs,}.
> The {devm_}rtc_device_register_fs which is creating the files, should
> be called after it is clear that the probe will pass. It will set the
> RTC_DEV_FILES_EXIST into rtc_device->flags.
> 
> In case of probe not passing, the rtc_device_unregister will try to
> delete the files only if RTC_DEV_FILES_EXIST is set in rtc_device->flags.
> 
> ..
>
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -252,6 +245,21 @@ exit:
>  }
>  EXPORT_SYMBOL_GPL(rtc_device_register);
>  
> +/**
> + * rtc_device_register_fs - creates dev+sysfs+proc files
> + * for rtc device
> + */
> +void rtc_device_register_fs(struct device *dev, struct rtc_device *rtc)
> +{
> +	rtc_dev_add_device(rtc);
> +	rtc_sysfs_add_device(rtc);
> +	rtc_proc_add_device(rtc);

It's a bit sloppy that rtc core simply ignores the error codes from the
driver core functions.  All these things could have failed and the
driver just keeps on trying to work.

I guess that can be fixed separately, but perhaps you'd like to take a
look, see how complex it will be to correctly unwind after such errors?

> +	set_bit(RTC_DEV_FILES_EXIST, &rtc->flags);
> +	dev_info(dev, "rtc core: registered %s as %s\n",
> +			rtc->name, dev_name(&rtc->dev));
> +}
> +EXPORT_SYMBOL_GPL(rtc_device_register_fs);
>  
>  /**
>   * rtc_device_unregister - removes the previously registered RTC class device
> @@ -262,13 +270,15 @@ void rtc_device_unregister(struct rtc_device *rtc)
>  {
>  	if (get_device(&rtc->dev) != NULL) {
>  		mutex_lock(&rtc->ops_lock);
> -		/* remove innards of this RTC, then disable it, before
> -		 * letting any rtc_class_open() users access it again
> -		 */
> -		rtc_sysfs_del_device(rtc);
> -		rtc_dev_del_device(rtc);
> -		rtc_proc_del_device(rtc);
> -		device_unregister(&rtc->dev);
> +		if (test_and_clear_bit(RTC_DEV_FILES_EXIST, &rtc->flags)) {
> +			/* remove innards of this RTC, then disable it, before
> +			 * letting any rtc_class_open() users access it again
> +			 */
> +			rtc_sysfs_del_device(rtc);
> +			rtc_dev_del_device(rtc);
> +			rtc_proc_del_device(rtc);
> +			device_unregister(&rtc->dev);

Presumably it doesn't matter, but it would be nice to do the del
functions in the reverse order of the add functions. 
rtc_proc_del_device() then rtc_sysfs_del_device() then
rtc_dev_del_device().

