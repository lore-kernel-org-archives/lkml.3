Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab3BFVGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:06:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3BFVGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:06:17 -0500
Date: Wed, 6 Feb 2013 13:06:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: max8997: Add driver for max8997 rtc.
Message-Id: <20130206130615.86121923.akpm@linux-foundation.org>
In-Reply-To: <1360149785-19645-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1360149785-19645-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2013 20:23:05 +0900
Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:

> This patch adds rtc driver for Maxim 8997 multifunction chip.
> Max8997 has rtc module in it. and it can be used for timekeeping
> clock and system alarm. It provide various operational mode those are
> BCD/binary, 24/12hour, am/pm. Driver sets binary/24/ for default.
> Maxim 8997 also supports SMPL(Sudden Momentary Power Loss), WTSR
> (Watchdog Timeout and Software Reset).
> 
> ...
>
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -233,6 +233,36 @@ config RTC_DRV_MAX8998
>  	  This driver can also be built as a module. If so, the module
>  	  will be called rtc-max8998.
>  
> +config RTC_DRV_MAX8997
> +	tristate "Maxim MAX8997"
> +	depends on MFD_MAX8997
> +	help
> +	  If you say yes here you will get support for the
> +	  RTC of Maxim MAX8997 PMIC.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called rtc-max8997.
> +
> +config MAX8997_RTC_WTSR
> +	bool "MAX8997_RTC_WTSR"
> +	depends on RTC_DRV_MAX8997
> +	help
> +	  MAX8997 rtc can supports WTSR(Watchdog Timeout and Software Reset).
> +	  WTSR event would keep the PMIC on regardless of PWRHOLD signal.
> +	  When PWRHOLD signal is falling, it turns on WTSR timer rather executes
> +	  reset imidiately. After timer expiring, it determine to reset the PMIC
> +	  depends on PWRHOLD state.
> +
> +config MAX8997_RTC_SMPL
> +	bool "MAX8997_RTC_SMPL"
> +	depends on RTC_DRV_MAX8997
> +	help
> +	  MAX8997 rtc can supports SMPL(Sudden Momentary Power Loss).
> +	  SMPL function can be used to intiate a power up sequence after momentarily
> +	  loosing contact to the battery pack. If battery goes under UVLO(Under
> +	  Lock Out) it starts SMPL timer. After timer exipiring, it checks battery
> +	  whether its state recovers from UVLO or not to make power supplies keep on.

Can we avoid creating CONFIG_MAX8997_RTC_WTSR and
CONFIG_MAX8997_RTC_SMPL?  It would be much better for the users if
these features were always available in all kernel builds.

The best way of handling this sort of thing is for the driver to probe
the hardware, work out its capabilities and "do the right thing".

The second best way is to require that the user add certain module
parameters to enable the functionality.

The worst way is to require the user to make the decision at kernel
build time!

