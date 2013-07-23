Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3GWFsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:48:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54537 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3GWFsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:48:52 -0400
Message-ID: <51EE18FC.2070505@ti.com>
Date: Tue, 23 Jul 2013 11:17:40 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, <kyungmin.park@samsung.com>,
        <balbi@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
References: <Pine.LNX.4.44L0.1307221028440.1495-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307221028440.1495-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 22 July 2013 08:14 PM, Alan Stern wrote:
> On Mon, 22 Jul 2013, Kishon Vijay Abraham I wrote:
> 
>>> 	The PHY and the controller it is attached to are both physical
>>> 	devices.
>>>
>>> 	The connection between them is hardwired by the system
>>> 	manufacturer and cannot be changed by software.
>>>
>>> 	PHYs are generally described by fixed system-specific board
>>> 	files or by Device Tree information.  Are they ever discovered
>>> 	dynamically?
>>
>> No. They are created just like any other platform devices are created.
> 
> Okay.  Are PHYs _always_ platform devices?

Not always. It can be any other device also.
> 
>>> 	Is the same true for the controllers attached to the PHYs?
>>> 	If not -- if both a PHY and a controller are discovered 
>>> 	dynamically -- how does the kernel know whether they are 
>>> 	connected to each other?
>>
>> No differences here. Both PHY and controller will have dt information or hwmod
>> data using which platform devices will be created.
>>>
>>> 	The kernel needs to know which controller is attached to which
>>> 	PHY.  Currently this information is represented by name or ID
>>> 	strings embedded in platform data.
>>
>> right. It's embedded in the platform data of the controller.
> 
> It must also be embedded in the PHY's platform data somehow.  
> Otherwise, how would the kernel know which PHY to use?
> 
>>> 	The PHY's driver (the supplier) uses the platform data to 
>>> 	construct a platform_device structure that represents the PHY.  
>>
>> Currently the driver assigns static labels (corresponding to the label used in
>> the platform data of the controller).
>>> 	Until this is done, the controller's driver (the client) cannot 
>>> 	use the PHY.
>>
>> right.
>>>
>>> 	Since there is no parent-child relation between the PHY and the 
>>> 	controller, there is no guarantee that the PHY's driver will be
>>> 	ready when the controller's driver wants to use it.  A deferred
>>> 	probe may be needed.
>>
>> right.
>>>
>>> 	The issue (or one of the issues) in this discussion is that 
>>> 	Greg does not like the idea of using names or IDs to associate
>>> 	PHYs with controllers, because they are too prone to
>>> 	duplications or other errors.  Pointers are more reliable.
>>>
>>> 	But pointers to what?  Since the only data known to be 
>>> 	available to both the PHY driver and controller driver is the
>>> 	platform data, the obvious answer is a pointer to platform data
>>> 	(either for the PHY or for the controller, or maybe both).
>>
>> hmm.. it's not going to be simple though as the platform device for the PHY and
>> controller can be created in entirely different places. e.g., in some cases the
>> PHY device is a child of some mfd core device (the device will be created in
>> drivers/mfd) and the controller driver (usually) is created in board file. I
>> guess then we have to come up with something to share a pointer in two
>> different files.
> 
> The ability for two different source files to share a pointer to a data 
> item defined in a third source file has been around since long before 
> the C language was invented.  :-)
> 
> In this case, it doesn't matter where the platform_device structures 
> are created or where the driver source code is.  Let's take a simple 
> example.  Suppose the system design includes a PHY named "foo".  Then 
> the board file could contain:
> 
> struct phy_info { ... } phy_foo;
> EXPORT_SYMBOL_GPL(phy_foo);
> 
> and a header file would contain:
> 
> extern struct phy_info phy_foo;
> 
> The PHY supplier could then call phy_create(&phy_foo), and the PHY 
> client could call phy_find(&phy_foo).  Or something like that; make up 
> your own structure tags and function names.

Alright. Thanks for the hint :-)

Thanks
Kishon
