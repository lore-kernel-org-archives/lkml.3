Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3IMWlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 18:41:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48608 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3IMWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 18:41:03 -0400
Message-ID: <52339479.6030402@wwwdotorg.org>
Date: Fri, 13 Sep 2013 16:40:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH alt 4/4] pinctrl: at91: rework debounce configuration
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com> <1379058813-3489-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1379058813-3489-1-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 01:53 AM, Boris BREZILLON wrote:
> AT91 SoCs do not support per pin debounce time configuration.
> Instead you have to configure a debounce time which will be used for all
> pins of a given bank (PIOA, PIOB, ...).

> diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt

> +Optional properties for iomux controller:
> +- atmel,default-debounce-div: array of debounce divisors (one divisor per bank)
> +  which describes the debounce timing in use for all pins of a given bank
> +  configured with the DEBOUNCE option (see the following description).
> +  Debounce timing is obtained with this formula:
> +  Tdebounce = 2 * (debouncediv + 1) / Fslowclk
> +  with Fslowclk = 32KHz
> +
>  Required properties for pin configuration node:
>  - atmel,pins: 4 integers array, represents a group of pins mux and config
>    setting. The format is atmel,pins = <PIN_BANK PIN_BANK_NUM PERIPH CONFIG>.
> @@ -91,7 +99,6 @@ DEGLITCH	(1 << 2): indicate this pin need deglitch.
>  PULL_DOWN	(1 << 3): indicate this pin need a pull down.
>  DIS_SCHMIT	(1 << 4): indicate this pin need to disable schmit trigger.
>  DEBOUNCE	(1 << 16): indicate this pin need debounce.
> -DEBOUNCE_VAL	(0x3fff << 17): debounce val.

This change would break the DT ABI since it removes a feature that's
already present.

I suppose it's still up to the Atmel maintainers to decide whether this
is appropriate, or whether the impact to out-of-tree DT files would be
problematic.

Assuming the DT ABI can be broken, I think I'd prefer to do so, rather
than take "non-alt" patch 4/4, since a per-pin DEBOUNCE_VAL clearly
doesn't correctly model the HW, assuming the patch description is
correct. I don't think arguments re: the generic pinconf debounce
property hold; if the Linux-specific/internal generic property doesn't
apply, the DT binding should not be bent to adjust to it, but should
rather still represent the HW itself.
