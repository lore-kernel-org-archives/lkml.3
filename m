Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab3BXEWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 23:22:31 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:49832 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180Ab3BXEWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 23:22:30 -0500
Date: Sat, 23 Feb 2013 18:14:48 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH RFC] pwm: add sysfs interface
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, thierry.reding@avionic-design.de,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <1361284061-2874-1-git-send-email-larsi@wh2.tu-dresden.de>
	(from larsi@wh2.tu-dresden.de on Tue Feb 19 08:27:41 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361664888.11282.16@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 08:27:41 AM, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> This adds a simple sysfs interface to the pwm subsystem. It is
> heavily inspired by the gpio sysfs interface.

Docs!

> diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
> index 7d2b4c9..b349d16 100644
> --- a/Documentation/pwm.txt
> +++ b/Documentation/pwm.txt
> @@ -45,6 +45,52 @@ int pwm_config(struct pwm_device *pwm, int  
> duty_ns, int period_ns);
> 
>  To start/stop toggling the PWM output use pwm_enable()/pwm_disable().

Hm, read read read existing file...

So a PWM is a GPIO that blinks on its own, in hardware, without needing  
a kernel thread and a timer to tell it to? (I think? Correction, an  
output-only gpio...)

> +Using PWMs with the sysfs interface
> +-----------------------------------
> +
> +You have to enable CONFIG_PWM_SYSFS in your kernel configuration to  
> use
> +the sysfs interface. It is exposed at /sys/class/pwm/. If there are  
> pwm
> +drivers loaded and these drivers successfully probed a chip, this  
> chip
> +is exported as pwmchipX . Note that a single driver can probe  
> multiple chips.
> +Inside the directory you can read these properties:
> +
> +base - This is the linux global start where the chips pwm channels  
> get
> +exposed.
> +
> +npwm - This is the number of pwm channels this chip supports.
> +
> +If you want to start using a pwm channel with sysfs first you have to
> +export it. If you are finished with it and want to free the pwm for  
> other
> +uses, you can unexport it:
> +
> +export - Write the global pwm channel number to this file to start  
> using
> +the channel with sysfs.
> +
> +unexport - Write the global pwm channel number of the channel you  
> are finshed
> +with to this file to make the channel available for other uses.
> +
> +Once a pwm is exported a pwmX (X ranging from 0 to MAX_PWMS)  
> directory appears
> +with the following read/write properties inside to control the pwm:
> +
> +duty_ns - Write the number of nanoseconds the active portion of the  
> pwm period
> +should last to this file. This can not be longer than the period_ns.
> +
> +period_ns - Write the length of the pwm period in nanoseconds to  
> this file.
> +This includes the active and inactive portion of the pwm period and  
> can not
> +be smaller than duty_ns.
> +
> +polarity - The normal behaviour is to put out a high for the active  
> portion of
> +the pwm period. Write a 1 to this file to inverse the signal and  
> output a low
> +on the active portion. Write a 0 to switch back to the normal  
> behaviour. The
> +polarity can only be changed if the pwm is not running. This file is  
> only
> +visible if the underlying driver/device supports changing the  
> polarity.
> +
> +run - Write a 1 to this file to start the pwm signal generation,  
> write a 0 to
> +stop it. Set your desired period_ns, duty_ns and polarity before  
> starting the
> +pwm.
> +
> +It is recommend to set the period_ns at first and duty_ns after that.
> +
>  Implementing a PWM driver
>  -------------------------

Doc part looks good to me:

Acked-by Rob Landley <rob@landley.net>

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index e513cd9..1c3432e 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -28,6 +28,21 @@ menuconfig PWM
> 
>  if PWM
> 
> +config PWM_SYSFS
> +	bool "/sys/class/pwm/... (sysfs interface)"
> +	depends on SYSFS
> +	help
> +	  Say Y here to add a sysfs interface for PWMs.
> +
> +	  This exports directories and files to userspace using sysfs.

Given that that's what a sysfs interface _is_, does that last line  
actually add anything?

> +	  This way the PWM outputs of a device can easyly be used,

s/easyly/easily/

> +	  controlled and tested.

And again, this sentence isn't hugely helpful if you already know what  
sysfs is. Why not start here:

> +	  For every instance of an PWM capable
> +	  device there is a pwmchipX directory exported to
> +	  /sys/class/pwm. If you want to use a PWM, you have to export
> +	  it to sysfs, which is done by writing the number into
> +	  /sys/class/pwm/export. After that /sys/class/pwm/pwmX is
> +	  reaady to be used.
> +

s/reaady/ready/

Rob