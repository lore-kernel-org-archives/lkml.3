Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab3KLXkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:40:01 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54781 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab3KLXjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:39:55 -0500
Date: Tue, 12 Nov 2013 23:39:11 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Markus Mayer" <markus.mayer@linaro.org>
Cc: "Wim Van Sebroeck" <wim@iguana.be>, "Christian Daudt" <bcm@fixthebug.org>,
        "Linaro Patches" <patches@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Linux Watchdog List" <linux-watchdog@vger.kernel.org>,
        "ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] watchdog: bcm281xx: Watchdog Driver
Message-ID: <20131112233911.16eba130@alan.etchedpixels.co.uk>
In-Reply-To: <1383943488-6537-2-git-send-email-markus.mayer@linaro.org>
References: <1383943488-6537-1-git-send-email-markus.mayer@linaro.org>
	<1383943488-6537-2-git-send-email-markus.mayer@linaro.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static int bcm_kona_wdt_set_resolution_reg(struct bcm_kona_wdt *wdt)
> +{
> +	uint32_t val;
> +	int timeout;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	if (wdt->resolution > SECWDOG_MAX_RES)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&wdt->lock, flags);
> +
> +	val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
> +	if (!timeout) {
> +		val &= ~SECWDOG_RES_MASK;
> +		val |= wdt->resolution << SECWDOG_CLKS_SHIFT;
> +		writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
> +	} else {
> +		ret = -EAGAIN;

This is I think the wrong choice of return. If the register fails to read
then presumably the device is b*ggered ? In which case return something
like -EIO and log something nasty.

EAGAIN has fairly specific semantics around signals and/or specific
requests for an I/O operation not to wait.

> +	spin_lock_irqsave(&wdt->lock, flags);
> +
> +	val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
> +	if (!timeout) {
> +		val &= ~SECWDOG_COUNT_MASK;
> +		val |= SECS_TO_TICKS(wdog->timeout, wdt);
> +		writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
> +	} else {
> +		ret = -EAGAIN;
> +	}
> +
> +	spin_unlock_irqrestore(&wdt->lock, flags);

As an aside you could fold most of these functions into one single helper
method that read CTRL_REG, did the and and or and wrote the result back
rather than repeating yourself. But hey if you like typing...

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

What if there is no resource present ?

> +	dev_info(dev, "Broadcom Kona Watchdog Timer");

The module load succeeded - the user knows it loaded from that. Likewise
the unload spewage is unwanted and the kernel would just drown in such
messages if we didn't keep them in check. If you need the for debug then
mark them dev_dbg but otherwise bin them.

Alan
