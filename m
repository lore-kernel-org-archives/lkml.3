Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaKFO2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:28:25 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61931 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaKFOTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:19:31 -0500
Date: Thu, 6 Nov 2014 15:19:17 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Vignesh R <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        devicetree@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jan Kardell <jan.kardell@telliq.com>, linux-iio@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Meerwald <pmeerw@pmeerw.net>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Brad Griffis <bgriffis@ti.com>
Subject: Re: [PATCH 1/4] input: touchscreen: ti_am335x_tsc Interchange
 touchscreen and ADC steps
Message-ID: <20141106141916.GA17151@netboy>
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
 <1414408111-2631-2-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414408111-2631-2-git-send-email-vigneshr@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 04:38:28PM +0530, Vignesh R wrote:

...

> @@ -209,6 +214,7 @@ static void titsc_read_coordinates(struct titsc *ts_dev,
>  	unsigned int read, diff;
>  	unsigned int i, channel;
>  	unsigned int creads = ts_dev->coordinate_readouts;
> +	unsigned int first_step = TOTAL_STEPS - (creads * 2 + 2);
>  
>  	*z1 = *z2 = 0;
>  	if (fifocount % (creads * 2 + 2))
> @@ -226,7 +232,7 @@ static void titsc_read_coordinates(struct titsc *ts_dev,
>  
>  		channel = (read & 0xf0000) >> 16;
>  		read &= 0xfff;
> -		if (channel < creads) {
> +		if (channel > first_step + creads + 2) {
>  			diff = abs(read - prev_val_x);
>  			if (diff < prev_diff_x) {
>  				prev_diff_x = diff;
> @@ -234,19 +240,19 @@ static void titsc_read_coordinates(struct titsc *ts_dev,
>  			}
>  			prev_val_x = read;
>  
> -		} else if (channel < creads * 2) {
> +		} else if (channel == first_step + creads + 1) {
> +			*z1 = read;
> +
> +		} else if (channel == first_step + creads + 2) {
> +			*z2 = read;
> +
> +		} else if (channel > first_step) {
>  			diff = abs(read - prev_val_y);
>  			if (diff < prev_diff_y) {
>  				prev_diff_y = diff;
>  				*y = read;

While you are at it, please get rid of the this "delta filter"
nonsense.

Thanks,
Richard

>  			}
>  			prev_val_y = read;
> -
> -		} else if (channel < creads * 2 + 1) {
> -			*z1 = read;
> -
> -		} else if (channel < creads * 2 + 2) {
> -			*z2 = read;
>  		}
>  	}
>  }
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
