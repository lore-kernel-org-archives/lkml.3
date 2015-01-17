Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbbAQDMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 22:12:55 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:50371 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbAQDMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 22:12:54 -0500
X-IronPort-AV: E=Sophos;i="5.09,415,1418112000"; 
   d="scan'208";a="54877573"
Message-ID: <54B9D329.2050201@broadcom.com>
Date: Fri, 16 Jan 2015 19:12:41 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: Re: How to handle access to multiple PHYs through MDIO
References: <54B9B66C.70308@broadcom.com> <54B9BF16.2020608@gmail.com>
In-Reply-To: <54B9BF16.2020608@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/16/2015 5:47 PM, Florian Fainelli wrote:
> Hi Ray,
> 
> On 16/01/15 17:10, Ray Jui wrote:
>> Hi,
>>
>> Our SoC, Cygnus, uses a generic MDC/MDIO controller to talk to various
>> PHYs, including 2 x Ethernet GPHY, 2 x PCIe Serdes, and 3 x USB PHYs. In
>> this case, how should I work out a generic PHY driver to handle this?
> 
> Interesting, I have typically seen separate MDIO controllers for at
> least Ethernet and USB/PCIe/SATA.
> 
>>
>> I notice that most generic PHY drivers are in drivers/phy/*, but
>> Ethernet seems to have its own interface of talking to a PHY through
>> MDIO (drivers/net/phy/*).
> 
> That's right, the Ethernet PHY library predates the generic PHY library
> from Kishon and they have little to no common ground.
> 
>>
>> I need a single driver to handle these so there isn't any race condition
>> for this single MDIO access in our system.
> 
> How about the following design:
> 
> - you create a MDIO bus controller library in e.g:
> drivers/phy/cygnus-mdio.c which offers generic generic read/write
> operations with a prototype looking like this:
> 
> 	int mdio_read(void *device, enum device_type, int reg, int addr);
> 	- int mdio_write(void *device, enum device_type, int reg, int addr, int
> value)
> 	- where device_type is MDIO_DEV_SERDES or MDIO_DEV_GPHY
> 
> 	- these reads and writes are protected by a local spinlock which is not
> exposed to the caller, it just needs to know that it gets serialized
> access to the controller
> 
> - you write a MDIO controller in drivers/phy/ for the USB and PCIe PHYs
> which uses this library and interfaces with Kishon's PHY Library operations
> 
> - you create a MDIO bus controller driver in drivers/net/phy/ which also
> uses this library and registers with Linux using mdiobus_register()
> 
> This is imho the easiest way to achieve what you want here, however, you
> could also stash all of what I describe above in a single MDIO bus
> driver in drivers/phy/ and ifdef out what is relevant based on your
> kernel configuration, up to you, there could be some tricky dependencies
> to solve though.
> 
Thanks, Florian. This makes sense to me.

Note this means I'll need to create public headers under include/linux
for the mdio library. But yes, having a shared mdio library and
protected with spinlock is the only way to guarantee serialized access
to the mdio controller.

Ray
