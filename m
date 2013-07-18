Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab3GRQfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:35:32 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42862 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab3GRQfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:35:30 -0400
Message-ID: <51E8194E.1030704@linaro.org>
Date: Thu, 18 Jul 2013 09:35:26 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RTC: Add an alarm disable quirk
References: <1374162294-29726-1-git-send-email-bp@alien8.de>
In-Reply-To: <1374162294-29726-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 08:44 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
>
> 41c7f7424259f ("rtc: Disable the alarm in the hardware (v2)") added the
> functionality to disable the RTC wake alarm when shutting down the box.
>
> However, there are at least two b0rked BIOSes we know about:
>
> https://bugzilla.novell.com/show_bug.cgi?id=812592
> https://bugzilla.novell.com/show_bug.cgi?id=805740

So first of all, thanks for digging in and generating a patch here! This 
issue has been on my list, but I've not been able to reproduce it and 
have just not had the time to chase it down remotely, so I really 
appreciate your efforts here!


> where, when wakeup alarm is enabled in the BIOS, the machine reboots
> automatically right after shutdown, regardless of what wakeup time is
> programmed.

So this doesn't quite make sense, since the wakeup alarm is being 
disabled on shutdown (and this patch is allowing the alarm interrupt to 
be left enabled). I assumed it was some sort of BIOS issue where any 
modification of the RTC_AIE bit caused the alarm irq line to be left 
high(or something like that) that triggered the immediate power-on on 
shutdown. But I've not been able to dig down on this.

So while I do want to make sure we resolve this issue for the affected 
users, I would like to better understand exactly what is wrong in the 
BIOS that causes this.


> Bisecting the issue lead to this patch so disable its functionality with
> a DMI quirk only for those boxes.
So from the one bug above I could read, it looks like the RTC wakeup 
alarm functionality is also disabled with this patch, no? Might want to 
document that clearly, so we understand the known side-effects of 
applying this. It might also be interesting to see if much older kernels 
(pre 2.6.38 - before the RTC rework landed) have this functionality 
issue as well. I suspect there has to be some way to make the hardware 
work properly.

>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Rabin Vincent <rabin.vincent@stericsson.com>
> ---
>   drivers/rtc/class.c     | 24 ++++++++++++++++++++++++
>   drivers/rtc/interface.c |  8 ++++++++
>   include/linux/rtc.h     |  1 +
>   3 files changed, 33 insertions(+)
>
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 02426812bebc..f3006db26125 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -19,6 +19,8 @@
>   #include <linux/idr.h>
>   #include <linux/slab.h>
>   #include <linux/workqueue.h>
> +#include <linux/dmi.h>
> +#include <linux/mod_devicetable.h>
>   
>   #include "rtc-core.h"
>   
> @@ -26,6 +28,25 @@
>   static DEFINE_IDA(rtc_ida);
>   struct class *rtc_class;
>   
> +static int __init clear_disable_alarm(const struct dmi_system_id *id)
> +{
> +	rtc_disable_alarm = false;
> +	return 0;
> +}
> +
> +static const struct dmi_system_id rtc_quirks[] __initconst = {
> +	/* https://bugzilla.novell.com/show_bug.cgi?id=805740 */
Any chance that bugzilla bug can be made public (it apparently requires 
a login to read, where as the other bug doesn't).


> +	{
> +		.callback = clear_disable_alarm,
> +		.ident    = "IBM Truman",

"IBM Truman"?

> +		.matches  = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "4852570"),
> +		},
> +	},
> +	{}
> +};
> +

Also, this seems to only address one of the systems you described. Do we 
need a second quirk entry as well?

>   static void rtc_device_release(struct device *dev)
>   {
>   	struct rtc_device *rtc = to_rtc_device(dev);
> @@ -340,6 +361,9 @@ static int __init rtc_init(void)
>   	rtc_class->pm = RTC_CLASS_DEV_PM_OPS;
>   	rtc_dev_init();
>   	rtc_sysfs_init(rtc_class);
> +
> +	dmi_check_system(rtc_quirks);
> +

Since this issue so far only affects x86 systems, would it be smarter to 
move the dmi quirk to the actual RTC driver in drivers/rtc/rtc-cmos.c 
rather then leaving it in the RTC core?


>   	return 0;
>   }
>   
> diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> index 72c5cdbe0791..0d944d1c02b8 100644
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -17,6 +17,11 @@
>   #include <linux/log2.h>
>   #include <linux/workqueue.h>
>   
> +/*
> + * Do not disable RTC alarm on shutdown - workaround for b0rked BIOSes.
> + */
> +bool rtc_disable_alarm = true;
> +
>   static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
>   static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
>   
> @@ -787,6 +792,9 @@ static void rtc_alarm_disable(struct rtc_device *rtc)
>   	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
>   		return;
>   
> +	if (!rtc_disable_alarm)
> +		return;
> +
>   	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);

I suspect the same logic could be better applied in cmos_alarm_irq_enable().

thanks again!
-john
