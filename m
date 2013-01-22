Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3AVRhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:37:46 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45438 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3AVRhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:37:45 -0500
Message-ID: <50FECE64.5040802@wwwdotorg.org>
Date: Tue, 22 Jan 2013 10:37:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mitch Bradley <wmb@firmworks.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] drivers/pinctrl: grab default handles from device
 core
References: <1358795855-21064-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1358795855-21064-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 12:17 PM, Linus Walleij wrote:
> This makes the device core auto-grab the pinctrl handle and set
> the "default" (PINCTRL_STATE_DEFAULT) state for every device
> that is present in the device model right before probe. This will
> account for the lion's share of embedded silicon devcies.

> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt

> @@ -1144,6 +1156,12 @@ PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-foo", NULL /* group */, "power_func")
>  
>  This gives the exact same result as the above construction.
>  
> +This should not be used for any kind of device which is represented in
> +the device model, as the pinctrl core will attempt to do the equal of
> +pinctrl_get_select_default() for these devices right before their device
> +drivers are probed, so hogging these will just make the model look
> +strange. Instead put in proper map entries.

This is a policy change unrelated to this change. There are good reasons
to use pinctrl hogs for everything except where dynamic changes are
required by drivers. As such, I think the wording above is overly
strong. Preferably, that paragraph should simply not be added.

> diff --git a/drivers/base/pinctrl.c b/drivers/base/pinctrl.c

> +int pinctrl_bind_pins(struct device *dev)
> +{
> +	struct dev_pin_info *dpi;
> +	int ret;
> +
> +	/* Allocate a pin state container on-the-fly */
> +	if (!dev->pins) {

This path is guaranteed to be take unless there is a bug. The first time
through, this field will be NULL. If probe fails, the code below
attempts to ensure this field is set back to NULL. As such, we should
simply remove this if condition and always allocate dpi. This would also
remove the requirement to set dev->pins back to NULL below, this
simplifying the code all around, although perhaps it'd be a good idea to
clear out any invalid pointers for clarity either way.

> +		dpi = devm_kzalloc(dev, sizeof(*dpi), GFP_KERNEL);
> +		if (!dpi)
> +			return -ENOMEM;
> +	} else
> +		dpi = dev->pins;

> +	/*
> +	 * Check if we already have a pinctrl handle, as we may arrive here
> +	 * after a deferral in the state selection below
> +	 */
> +	if (!dpi->p) {
...
> +	/*
> +	 * We may have looked up the state earlier as well.
> +	 */
> +	if (!dpi->default_state) {

The same argument applies to both those if conditions too.

Following on from this, I thought that the code looked OK; all the error
paths set dev->pins=NULL when expected, although I think that the
pinctrl_lookup_state() short-exit path should have cleared dpi->p and
dpi->default_state, so I thought this patch would test out OK. However,
pinctrl_bind_pins() is not the only source of errors during probe(); the
driver itself could fail to probe() due to -EPROBE_DEFER, and that would
then require clearing dev->pins. So in fact, this patch still doesn't
work. Again, this can all be solved simply by removing all the
conditionals in the code that I mention above.

I'll send an updated/tested patch in a minute.
