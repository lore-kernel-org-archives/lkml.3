Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3J0LR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:17:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47711 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3J0LRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:17:47 -0400
Date: Sun, 27 Oct 2013 12:17:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: anton@enomsg.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 2/4] charger-manager: Use IIO subsystem to read battery
 temperature instead of legacy method
Message-ID: <20131027111739.GC2437@xo-6d-61-c0.localdomain>
References: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com>
 <1382446317-32613-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382446317-32613-3-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index e6f92b4..6700191 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -309,6 +309,7 @@ config CHARGER_MANAGER
>  	bool "Battery charger manager for multiple chargers"
>  	depends on REGULATOR && RTC_CLASS
>  	select EXTCON
> +	select IIO
>  	help
>            Say Y to enable charger-manager support, which allows multiple
>            chargers attached to a battery and multiple batteries attached to a

Umm. Are there charger-manager users that don't have temperature sensor on IIO?

> +	if (desc->channel) {
> +		temp = iio_read_channel_raw(desc->channel, last_temp_mC);
> +
> +		/*
> +		 * The charger-manager use IIO subsystem to read ADC raw data
> +		 * from IIO ADC device drvier. The each device driver has
> +		 * own non-standard ADC table. If user of charger-manager
> +		 * would like to get correct temperature value, have to convert
> +		 * 'last_temp_mC' variable according to proper calculation
> +		 * method and own ADC table.
> +		 */
> +
> +		if (*last_temp_mC >= desc->iio_adc_overheat)
> +			temp = CM_TEMP_NORMAL;	/* Overheat */
> +		else if (*last_temp_mC <= desc->iio_adc_cold)
> +			temp = CM_TEMP_COLD;	/* Cold */
> +		else
> +			temp = CM_TEMP_NORMAL;	/* Normal */

Something is definitely wrong here.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
