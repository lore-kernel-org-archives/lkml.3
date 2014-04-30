Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422736AbaD3QaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:30:07 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55059 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422657AbaD3QaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:30:04 -0400
Date: Wed, 30 Apr 2014 09:29:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: rydberg@euromail.se, balbi@ti.com, dmurphy@ti.com, mugunthanvnm@ti.com,
        nsekhar@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/7] Input: pixcir_i2c_ts: Initialize interrupt mode
 and power mode
Message-ID: <20140430162950.GA13624@core.coreip.homeip.net>
References: <1398861392-8959-1-git-send-email-rogerq@ti.com>
 <1398861392-8959-3-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398861392-8959-3-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Wed, Apr 30, 2014 at 03:36:27PM +0300, Roger Quadros wrote:
> +static int pixcir_stop(struct pixcir_i2c_ts_data *ts)
> +{
> +	struct device *dev = &ts->client->dev;
> +	int ret;
> +
> +	/* exit ISR if running, no more report parsing */
> +	ts->exiting = true;
> +	mb();	/* update status before we synchronize irq */
> +
> +	/* disable ISR from running again */
> +	disable_irq(ts->client->irq);
> +
> +	/* wait till running ISR complete */
> +	synchronize_irq(ts->client->irq);
> +
> +	/* disable interrupt generation */
> +	ret = pixcir_int_enable(ts, 0);
> +	if (ret)
> +		dev_err(dev, "Failed to disable interrupt generation\n");
> +
> +	/* restore IRQ */
> +	enable_irq(ts->client->irq);
> +
> +	return ret;

Should not this be:

	pixcir_int_enable(ts, 0);
	ts->exiting = true;
	mb();
	synchronize_irq(ts->client->irq);

Why do we also need to disable/enable irq?

By the way, disable_irq() implies synchronize_irq().

Thanks.

-- 
Dmitry
