Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111Ab3HNQen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:34:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40861 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760002Ab3HNQem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:34:42 -0400
Message-ID: <520BB19E.8040901@wwwdotorg.org>
Date: Wed, 14 Aug 2013 10:34:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] pinctrl: improve warning messages
References: <1376497533-32303-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1376497533-32303-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 10:25 AM, Linus Walleij wrote:
> Print out the affected group name on activation of pin mux
> settings, and warn if you cannot free a pin that should have
> been part of a certain setting.

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c

> @@ -411,9 +415,14 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
>  	for (i = 0; i < num_pins; i++) {
>  		ret = pin_request(pctldev, pins[i], setting->dev_name, NULL);
>  		if (ret) {
> +			const char *gname;
> +
> +			gname = pctlops->get_group_name(pctldev,
> +						setting->data.mux.group);
>  			dev_err(pctldev->dev,
> -				"could not request pin %d on device %s\n",
> -				pins[i], pinctrl_dev_get_name(pctldev));
> +				"could not request pin %d from group %s on "
> +				"device %s\n",
> +				pins[i], gname, pinctrl_dev_get_name(pctldev));

I think it'd be useful to print the pin name rather than pin number here.

> @@ -486,6 +499,16 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>  			desc->mux_setting = NULL;
>  			/* And release the pin */
>  			pin_free(pctldev, pins[i], NULL);
> +		} else {
> +			const char *gname;
> +
> +			gname = pctlops->get_group_name(pctldev,
> +						setting->data.mux.group);
> +			dev_warn(pctldev->dev,
> +				 "not freeing pin %d as part of deactivating "
> +				 "group %s - it is already used for some other "
> +				 "setting",
> +				 pins[i], gname);
>  		}
>  	}

I think that will only happen if one of the pinmux_enabling_setting
prints already happened. Is it worth adding this one?

