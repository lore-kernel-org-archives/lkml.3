Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3GVH0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 03:26:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42614 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab3GVH0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 03:26:32 -0400
Message-ID: <51ECDE5E.3050104@ti.com>
Date: Mon, 22 Jul 2013 12:55:18 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, <kyungmin.park@samsung.com>,
        <balbi@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
References: <Pine.LNX.4.44L0.1307211453450.19133-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307211453450.19133-100000@netrider.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 22 July 2013 12:52 AM, Alan Stern wrote:
> On Sun, 21 Jul 2013, Sylwester Nawrocki wrote:
> 
>>> What's wrong with the platform_data structure, why can't that be used
>>> for this?
>>
>> At the point the platform data of some driver is initialized, e.g. in
>> board setup code the PHY pointer is not known, since the PHY supplier
>> driver has not initialized yet.  Even though we wanted to pass pointer
>> to a PHY through some notifier call, it would have been not clear
>> which PHY user driver should match on such notifier.  A single PHY
>> supplier driver can create M PHY objects and this needs to be mapped
>> to N PHY user drivers.  This mapping needs to be defined somewhere by
>> the system integrator.  It works well with device tree, but except that
>> there seems to be no other reliable infrastructure in the kernel to
>> define links/dependencies between devices, since device identifiers are
>> not known in advance in all cases.
>>
>> What Tomasz proposed seems currently most reasonable to me for non-dt.
>>
>>> Or, if not, we can always add pointers to the platform device structure,
>>> or even the main 'struct device' as well, that's what it is there for.
>>
>> Still we would need to solve a problem which platform device structure
>> gets which PHY pointer.
> 
> Can you explain the issues in more detail?  I don't fully understand 
> the situation.
> 
> Here's what I think I know:
> 
> 	The PHY and the controller it is attached to are both physical
> 	devices.
> 
> 	The connection between them is hardwired by the system
> 	manufacturer and cannot be changed by software.
> 
> 	PHYs are generally described by fixed system-specific board
> 	files or by Device Tree information.  Are they ever discovered
> 	dynamically?

No. They are created just like any other platform devices are created.
> 
> 	Is the same true for the controllers attached to the PHYs?
> 	If not -- if both a PHY and a controller are discovered 
> 	dynamically -- how does the kernel know whether they are 
> 	connected to each other?

No differences here. Both PHY and controller will have dt information or hwmod
data using which platform devices will be created.
> 
> 	The kernel needs to know which controller is attached to which
> 	PHY.  Currently this information is represented by name or ID
> 	strings embedded in platform data.

right. It's embedded in the platform data of the controller.
> 
> 	The PHY's driver (the supplier) uses the platform data to 
> 	construct a platform_device structure that represents the PHY.  

Currently the driver assigns static labels (corresponding to the label used in
the platform data of the controller).
> 	Until this is done, the controller's driver (the client) cannot 
> 	use the PHY.

right.
> 
> 	Since there is no parent-child relation between the PHY and the 
> 	controller, there is no guarantee that the PHY's driver will be
> 	ready when the controller's driver wants to use it.  A deferred
> 	probe may be needed.

right.
> 
> 	The issue (or one of the issues) in this discussion is that 
> 	Greg does not like the idea of using names or IDs to associate
> 	PHYs with controllers, because they are too prone to
> 	duplications or other errors.  Pointers are more reliable.
> 
> 	But pointers to what?  Since the only data known to be 
> 	available to both the PHY driver and controller driver is the
> 	platform data, the obvious answer is a pointer to platform data
> 	(either for the PHY or for the controller, or maybe both).

hmm.. it's not going to be simple though as the platform device for the PHY and
controller can be created in entirely different places. e.g., in some cases the
PHY device is a child of some mfd core device (the device will be created in
drivers/mfd) and the controller driver (usually) is created in board file. I
guess then we have to come up with something to share a pointer in two
different files.
> 
> Probably some of the details above are wrong; please indicate where I
> have gone astray.  Also, I'm not clear about the role played by various 
> APIs.  For example, where does phy_create() fit into this picture?

phy_create is the API by which the PHY's driver (the supplier) hook into the
PHY framework. It's like the controller driver will always interact with the
PHY driver through the PHY framework.

Thanks
Kishon
