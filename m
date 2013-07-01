Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3GAVxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:53:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39308 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab3GAVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:53:18 -0400
Message-ID: <51D1FA4C.8000507@wwwdotorg.org>
Date: Mon, 01 Jul 2013 15:53:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 5/9] usb: phy: tegra: Register as an USB PHY.
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com> <1372455427-20898-6-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1372455427-20898-6-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 03:37 PM, Tuomas Tynkkynen wrote:
> Register the Tegra PHY device instances with the PHY subsystem so that
> the Tegra EHCI driver can locate a PHY via the standard APIs.

> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c

> +	err = usb_add_phy_dev(&tegra_phy->u_phy);
> +	if (err < 0) {
> +		tegra_usb_phy_close(&tegra_phy->u_phy);
> +		return err;
> +	}

Don't you want to do that a bit later? In particular ...

>  	tegra_phy->u_phy.shutdown = tegra_usb_phy_close;
>  	tegra_phy->u_phy.set_suspend = tegra_usb_phy_suspend;
> 
> 	dev_set_drvdata(&pdev->dev, tegra_phy);

... that all happens *after* the call to usb_add_phy_dev() call, yet I
think the USB core could legally call any of the PHY methods after the
call to usb_add_phy_dev(), and that probably requires all those methods
pointers and drvdata to be set up? I suggest moving the call to
usb_add_phy_dev() to the very end of the function.

> +static int tegra_usb_phy_remove(struct platform_device *pdev)
> +{
> +	struct tegra_usb_phy *tegra_phy = platform_get_drvdata(pdev);
> +
> +	usb_remove_phy(&tegra_phy->u_phy);
> +	return 0;
> +}

Nit: I'd typically expect to see a blank line before the return statement.
