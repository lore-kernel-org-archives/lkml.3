Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3DWQmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:42:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35406 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756617Ab3DWQmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:42:24 -0400
Date: Tue, 23 Apr 2013 12:42:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 18/21] usb: phy: tegra: don't call into tegra-ehci directly
In-Reply-To: <1366734653-488286-19-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1304231239220.1679-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Arnd Bergmann wrote:

> Both phy-tegra-usb.c and ehci-tegra.c export symbols used by the other one,
> which does not work if one of them or both are loadable modules, resulting
> in an error like:
> 
> drivers/built-in.o: In function `utmi_phy_clk_disable':
> drivers/usb/phy/phy-tegra-usb.c:302: undefined reference to `tegra_ehci_set_phcd'
> drivers/built-in.o: In function `utmi_phy_clk_enable':
> drivers/usb/phy/phy-tegra-usb.c:324: undefined reference to `tegra_ehci_set_phcd'
> drivers/built-in.o: In function `utmi_phy_power_on':
> drivers/usb/phy/phy-tegra-usb.c:447: undefined reference to `tegra_ehci_set_pts'
> 
> This turns the interface into a one-way dependency by letting the tegra ehci
> driver pass two function pointers for callbacks that need to be called by
> the phy driver.

> @@ -733,7 +731,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>  
>  	tegra->phy = tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
>  					pdata->phy_config,
> -					TEGRA_USB_PHY_MODE_HOST);
> +					TEGRA_USB_PHY_MODE_HOST,
> +					&tegra_ehci_set_pts,
> +					tegra_ehci_set_phcd);

Does the compiler warn about the unnecessary '&'?  In any case, it
looks strange to have one function pointer with an '&' and another
without.

Aside from that minor detail, the ehci-tegra.c changes are fine.

Alan Stern

