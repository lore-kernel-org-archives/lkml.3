Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3GQRty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:49:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3GQRtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:49:18 -0400
Date: Wed, 17 Jul 2013 10:38:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        koen@dominion.thruhere.net
Subject: Re: [PATCH 05/21] iio: input: am335x_adc: Add continuous mode to adc
Message-ID: <20130717173801.GD17882@kroah.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374082010-28095-6-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374082010-28095-6-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 06:26:34PM +0100, Zubair Lutfullah wrote:
> Main patch. Adds continuous sampling support for the driver

What does that mean?  Why have this in the changelog at all?

> 
> The IRQs are changed in the TSC drivers as they are shared with
> the ADC IRQ lines.
> 
> This patch is based on work in the 3.2 tree by TI
> Original Author is Patil Rachna
> 
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> ---
>  drivers/iio/adc/ti_am335x_adc.c           |  386 ++++++++++++++++++++++++-----
>  drivers/input/touchscreen/ti_am335x_tsc.c |    9 +-
>  drivers/mfd/ti_am335x_tscadc.c            |   12 +-
>  include/linux/mfd/ti_am335x_tscadc.h      |   12 +
>  4 files changed, 351 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 8a63203..1f6e800 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -29,11 +29,25 @@
>  #include <linux/math64.h>
>  #include <linux/mfd/ti_am335x_tscadc.h>
>  
> +#include <linux/stat.h>
> +
> +#include <linux/sched.h>

Why extra newlines?

> +#include <linux/iio/buffer.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/kfifo_buf.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/delay.h>
> +
>  struct tiadc_device {
>  	struct ti_tscadc_dev *mfd_tscadc;
>  	int channels;
>  	u8 channel_line[8];
>  	u8 channel_step[8];
> +	struct work_struct      poll_work;
> +	wait_queue_head_t       wq_data_avail;
> +	int                     irq;
> +	bool                    is_continuous_mode;
> +        u16                     *buffer;

Please run all of these patches through checkpatch and fix the issues
that are reported, otherwise there is no way they can be accepted.

I've stopped reviewing this series here...

thanks,

greg k-h
