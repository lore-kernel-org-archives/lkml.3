Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3GAWCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:02:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57276 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GAWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:02:54 -0400
Message-ID: <51D1FC8B.1030505@wwwdotorg.org>
Date: Mon, 01 Jul 2013 16:02:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 9/9] usb: phy: tegra: Use DT helpers for dr_mode
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com> <1372455427-20898-10-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1372455427-20898-10-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 03:37 PM, Tuomas Tynkkynen wrote:
> Use the new of_usb_get_dr_mode helper function for parsing dr_mode
> from the device tree. Also replace the usage of the custom
> tegra_usb_phy_mode enum with the standard enum.

> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
> +	tegra_phy->mode = of_usb_get_dr_mode(np);
> +	if (tegra_phy->mode == USB_DR_MODE_UNKNOWN) {
> +		dev_err(&pdev->dev, "dr_mode is invalid\n");
> +		return -EINVAL;
> +	}

Unfortunately, of_usb_get_dr_mode() returns USB_DR_MODE_UNKNOWN if the
property is missing, rather than defaulting to host mode as the original
code here did. I would suggest solving this by:

> diff --git a/drivers/usb/usb-common.c b/drivers/usb/usb-common.c
> index 675384d..6391de5 100644
> --- a/drivers/usb/usb-common.c
> +++ b/drivers/usb/usb-common.c
> @@ -103,7 +103,7 @@ enum usb_dr_mode of_usb_get_dr_mode(struct device_node *np)
>  
>         err = of_property_read_string(np, "dr_mode", &dr_mode);
>         if (err < 0)
> -               return USB_DR_MODE_UNKNOWN;
> +               return USB_DR_MODE_HOST;
>  
>         for (i = 0; i < ARRAY_SIZE(usb_dr_modes); i++)
>                 if (!strcmp(dr_mode, usb_dr_modes[i]))

This can't be done by the caller, since of_usb_get_dr_mode() returns
UNKNOWN in two cases, which the caller can't distinguish without
manually checking whether the property exists first:

a) Property is not present (which should default to HOST mode at least
for the Tegra binding, as in the patch I show above).

b) Property is present, but contains an invalid value, which probably
should cause the driver to error-out.

This is only a problem for dr_mode in the Tegra binding: dr_mode is an
optional property, whereas the phy_type property as parsed by patch 8/9
is mandatory, so this issue doesn't come up.
