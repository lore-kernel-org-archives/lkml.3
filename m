Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab3HMPq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:46:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47236 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab3HMPq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:46:28 -0400
Message-ID: <520A54D0.3060504@wwwdotorg.org>
Date: Tue, 13 Aug 2013 09:46:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH v3] pinctrl: pinmux: Don't free pins requested by other
 devices in pinmux_disable_setting.
References: <1376369666-2564-1-git-send-email-sonic.adi@gmail.com>
In-Reply-To: <1376369666-2564-1-git-send-email-sonic.adi@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 10:54 PM, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> One peripheral may share part of its pins with the 2nd
> peripheral and the other pins with the 3rd. If it requests all pins
> when part of them has already be requested and owned by the 2nd
> peripheral, this request fails and pinmux_disable_setting() is called.
> The pinmux_disable_setting() frees all pins of the first peripheral
> without checking if the pin is owned by itself or the 2nd, which
> results in the malfunction of the 2nd peripheral driver.

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c

> @@ -480,15 +480,17 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>  			dev_warn(pctldev->dev,
>  				 "could not get pin desc for pin %d\n",
>  				 pins[i]);
> +			/* And release the pin */
> +			pin_free(pctldev, pins[i], NULL);

This change doesn't seem useful. The 2 lines right above the patch
context are:

		desc = pin_desc_get(pctldev, pins[i]);
                if (desc == NULL) {

... and the first thing pin_free() does it call pin_desc_get() again.
So, pin_free() is simply going to fail and print another error.

The rest of the patch looks good.

