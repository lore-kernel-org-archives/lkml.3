Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaANI0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:26:36 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:52380 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751412AbaANI0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:26:34 -0500
Date: Tue, 14 Jan 2014 09:26:32 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Dave Young <dyoung@redhat.com>
Cc: dzickus@redhat.com, bhe@redhat.com, vgoyal@redhat.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add a parameter for stop wdt before register
Message-ID: <20140114082632.GA28648@spo001.leaseweb.com>
References: <20140114082323.GA4485@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114082323.GA4485@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> In kdump kernel watchdog could interrupt vmcore capturing because we
> have no way to disable/stop it while crashing happens.
> 
> Add a module parameter stop_before_register so watchdog can be stopped
> before register in driver loading path. Thus we can try to load the
> watchdog driver as early as possible in kdump kernel to ensure vmcore
> capturing.
> 
> Don Zickus mentioned that there's the case that bios start the watchdog
> and it is expected that the kernel keep the watchdog alive. To address
> this case I added the module parameter which is false by default so
> it will stop the watchdog only when user provice kernel cmdline
> "watchdog.stop_before_register=1".  
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  drivers/watchdog/watchdog_core.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- linux.orig/drivers/watchdog/watchdog_core.c
> +++ linux/drivers/watchdog/watchdog_core.c
> @@ -42,6 +42,7 @@
>  
>  static DEFINE_IDA(watchdog_ida);
>  static struct class *watchdog_class;
> +static bool stop_before_register;
>  
>  static void watchdog_check_min_max_timeout(struct watchdog_device *wdd)
>  {
> @@ -119,6 +120,9 @@ int watchdog_register_device(struct watc
>  	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
>  		return -EINVAL;
>  
> +	if (stop_before_register)
> +		wdd->ops->stop(wdd);
> +
>  	watchdog_check_min_max_timeout(wdd);
>  
>  	/*
> @@ -220,6 +224,8 @@ static void __exit watchdog_exit(void)
>  subsys_initcall(watchdog_init);
>  module_exit(watchdog_exit);
>  
> +module_param(stop_before_register, bool, 0644);
> +
>  MODULE_AUTHOR("Alan Cox <alan@lxorguk.ukuu.org.uk>");
>  MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
>  MODULE_DESCRIPTION("WatchDog Timer Driver Core");

Hmm, need to look closer to this, but my first thought is:
what about devices that cannot be stopped once started...
They should be able to override this module_parameter...

Kind regards,
Wim.

