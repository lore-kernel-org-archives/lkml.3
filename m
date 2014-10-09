Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaJIIoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:44:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33914 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaJIIoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:44:06 -0400
Message-ID: <1412844240.6809.1.camel@pengutronix.de>
Subject: Re: [PATCH] reset: add reset_control_status helper function
From: Philipp Zabel <p.zabel@pengutronix.de>
To: dinguyen@opensource.altera.com
Cc: dinh.linux@gmail.com, atull@opensource.altera.com,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Oct 2014 10:44:00 +0200
In-Reply-To: <1412808351-4598-1-git-send-email-dinguyen@opensource.altera.com>
References: <1412808351-4598-1-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

thank you for the patch. Just two small issues below:

Am Mittwoch, den 08.10.2014, 17:45 -0500 schrieb dinguyen@opensource.altera.com:
[...]
> @@ -126,6 +126,19 @@ int reset_control_deassert(struct reset_control *rstc)
>  EXPORT_SYMBOL_GPL(reset_control_deassert);
>  
>  /**
> + * reset_control_status - returns a status of a reset bit
> + * @rstc: reset controller
> + */
> +unsigned int reset_control_status(struct reset_control *rstc)
> +{
> +	if (rstc->rcdev->ops->status)
> +		return rstc->rcdev->ops->status(rstc->rcdev, rstc->id);
> +
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(reset_control_status);

Since this function can return negative error numbers, please make the
return value of reset_control_status int. That also means that drivers
must not set the MSB when returning status.

> +
> +/**
>   * of_reset_control_get - Lookup and obtain a reference to a reset controller.
>   * @node: device to be reset by the controller
>   * @id: reset line name
> diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
> index 41a4695..8e659d5 100644
> --- a/include/linux/reset-controller.h
> +++ b/include/linux/reset-controller.h
> @@ -17,6 +17,7 @@ struct reset_control_ops {
>  	int (*reset)(struct reset_controller_dev *rcdev, unsigned long id);
>  	int (*assert)(struct reset_controller_dev *rcdev, unsigned long id);
>  	int (*deassert)(struct reset_controller_dev *rcdev, unsigned long id);
> +	unsigned int (*status)(struct reset_controller_dev *rcdev, unsigned long id);
>  };

Please change the return value of the status callback to int and
describe it in the kerneldoc comment above. It should probably be
mentioned that the returned status value must be >= 0 except in error
cases.
 
regards
Philipp

