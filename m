Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3A2Qa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:30:57 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49416 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3A2Qav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:30:51 -0500
Message-ID: <5107F88C.8030002@openwrt.org>
Date: Tue, 29 Jan 2013 17:27:56 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: davem@davemloft.net, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] mv643xx_eth: convert to use the Marvell Orion MDIO
 driver
References: <1359473048-26551-1-git-send-email-florian@openwrt.org> <1359473048-26551-6-git-send-email-florian@openwrt.org> <20130129170131.7964a110@skate>
In-Reply-To: <20130129170131.7964a110@skate>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 05:01 PM, Thomas Petazzoni wrote:
> Dear Florian Fainelli,
>
> On Tue, 29 Jan 2013 16:24:08 +0100, Florian Fainelli wrote:
>> This patch converts the Marvell MV643XX ethernet driver to use the
>> Marvell Orion MDIO driver. As a result, PowerPC and ARM platforms
>> registering the Marvell MV643XX ethernet driver are also updated to
>> register a Marvell Orion MDIO driver. This driver voluntarily overlaps
>> with the Marvell Ethernet shared registers because it will use a subset
>> of this shared register (shared_base + 0x4 - shared_base + 0x84). The
>> Ethernet driver is also updated to look up for a PHY device using the
>> Orion MDIO bus driver.
>>
>> Signed-off-by: Florian Fainelli <florian@openwrt.org>
>> ---
>>   arch/arm/plat-orion/common.c               |   84 +++++++++++--
> In this file, there was one "MV643XX_ETH_SHARED_NAME" platform_device
> registered for each network interface. Why? If the driver is shared,
> isn't the whole idea to register it only once?
It looks like I introduced two redundant mvmdio instances as ge01 refers 
to the ge00 smi bus (the same applies to ge11 and ge10). Thanks for 
spotting this.

>
> In any case, one of the idea of separating the mvmdio driver from the
> mvneta driver in the first place is that there should be only one
> instance of the mvmdio device, even if there are multiple network
> interfaces. The reason is that from a HW point of the view, the MDIO
> unit is shared between the network interfaces. If you look at
> armada-370-xp.dtsi, there is only one mvmdio device registered, and two
> network interfaces (using the mvneta driver) that are registered (and
> actually up to four network interfaces can exist, they are added by
> some other .dtsi files depending on the specific SoC).
>
> So I don't think there should be one instance of the mvmdio per network
> interface.
>
> Also, I am wondering what's left in this MV643XX_ETH_SHARED_NAME driver
> once the MDIO stuff has been pulled out in a separate driver? I think
> the whole point of this work should be to get rid of this
> MV643XX_ETH_SHARED_NAME driver, no?

If you take a closer look at mv643xx_eth you will see that the "shared" 
driver still handles the mconf bus window configuration, which is not 
abstracted yet. Besides that, I would rather do it step by step.
--
Florian
