Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3CTRve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:51:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60815 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3CTRvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:51:33 -0400
Message-ID: <5149F722.8040901@wwwdotorg.org>
Date: Wed, 20 Mar 2013 11:51:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 7/7] usb: phy: registering tegra USB PHY as platform driver
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <1363609781-4045-8-git-send-email-vbyravarasu@nvidia.com> <5148C8B6.90303@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6E5092FFFA@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E5092FFFA@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 06:43 AM, Venu Byravarasu wrote:
> Stephen Warren wrote at Wednesday, March 20, 2013 1:51 AM:
>> On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
>>> Registered tegra USB PHY as a separate platform driver.

>>> diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c

>>> +static int tegra_usb_phy_probe(struct platform_device *pdev)
>>
>> Hmmm. Note that in order to make deferred probe work correctly, all the
>> gpio_request(), clk_get(), etc. calls that acquire resources from other
>> drivers must happen here in probe() and not in tegra_usb_phy_open().
>  
> In present code tegra_usb_phy_open() is indirectly called via usb_phy_init() from ehci-tegra.c.
> Between obtaining PHY handle (and hence getting into deferred probe, when it is not available)
> and calling usb_phy_init, no other USB registers were accessed. Hence I was doing this way.
> 
> Do you still think it would be better to move gpio and clk APIs to probe?

Yes.

What's happening right now is that the PHY driver potentially completes
probe() before its resources are available.

This just happens not to break anything because the EHCI driver's probe
ends up getting deferred until some other PHY driver function can
acquire those resources, so the USB port as a whole isn't registered
until the resources are available.

However, this still means that the PHY driver could be suspended after
e.g. a driver that provides a GPIO it uses, since the PHY's probe
completed before the GPIO driver's probe.

Hence, this could easily cause some form of suspend/resume or perhaps
even shutdown/reboot problem.

>>> +struct usb_phy *tegra_usb_get_phy(struct device_node *dn)
>>> +{
>>> +	struct device *dev;
>>> +	struct tegra_usb_phy *tegra_phy;
>>> +
>>> +	dev = driver_find_device(&tegra_usb_phy_driver.driver, NULL, dn,
>>> +				 tegra_usb_phy_match);
>>> +	if (!dev)
>>> +		return ERR_PTR(-EPROBE_DEFER);
>>> +
>>> +	tegra_phy = dev_get_drvdata(dev);
>>> +
>>> +	return &tegra_phy->u_phy;
>>> +}
>>
>> I think you need a module_get() somewhere in there, and also need to add
>> a tegra_usb_put_phy() function too, so you can call module_put() from it.
> 
> Am not clear on why to add module_get here. Can you plz provide more details?

Actually, I guess it isn't needed, although slightly by accident perhaps:

If ehci-tegra.c and phy-usb-tegra.c are built as modules, they'll be
separate modules. Since ehci-tegra.c calls into phy-usb-tegra.c, you
need to make sure that phy-usb-tegra.c stays loaded any time
ehci-tegra.c is loaded.

Right now, this is ensured because ehci-tegra.c references functions in
phy-usb-tegra.c by symbol name, so a dependency exists. So, I guess
everything actually works out without the module_get(). So, no changes
are needed.

After this series is applied, I believe that tegra_usb_get_phy() is the
last function that ehci-tegra.c references by symbol name. Eventually,
that function will be replaced by devm_of_phy_get_byname() (see Kishon's
generic PHY API patch series), so there won't be any symbol name
dependencies, so some other mechanism must be used to ensure the PHY
driver stays loaded while the EHCI driver is using it. At that point,
the implementation of devm_of_phy_get_byname() should be calling
module_get(), so again no changes should be required to your patch.
