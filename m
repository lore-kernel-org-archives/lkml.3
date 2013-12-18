Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3LROON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:14:13 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59296 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab3LROOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:14:11 -0500
Date: Wed, 18 Dec 2013 06:14:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: rydberg@euromail.se, jcbian@pixcir.com.cn, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/9] Input: pixcir_i2c_ts: Initialize interrupt mode and
 power mode
Message-ID: <20131218141408.GC28504@core.coreip.homeip.net>
References: <1387358480-8313-1-git-send-email-rogerq@ti.com>
 <1387358480-8313-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387358480-8313-4-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 02:51:14PM +0530, Roger Quadros wrote:
> +
> +static int pixcir_stop(struct pixcir_i2c_ts_data *ts)
> +{
> +	struct device *dev = &ts->client->dev;
> +	int ret;
> +
> +	/* disable interrupt generation */
> +	ret = pixcir_int_enable(ts, 0);
> +	if (ret) {
> +		dev_err(dev, "Failed to disable interrupt generation\n");
> +		return ret;
> +	}
> +
> +	disable_irq(ts->client->irq);

Why do you need to disable IRQ? If you disable interrupt generation in
the chip I think you only need to call synchronize_irq() to make sure
it's completed if it happens to be running. Also you need to move the
code:

	tsdata->exiting = true;
	mb();

here from pixcir_i2c_ts_remove() to make sure handler exits promptly.

You will also need to reset tsdata->exiting in your start method.

Thanks.

-- 
Dmitry
