Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3DOLeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:34:25 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60524 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3DOLeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:34:21 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 1/6] drivers: phy: add generic PHY framework
To: Kishon Vijay Abraham I <kishon@ti.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, akpm@linux-foundation.org,
        rob@landley.net
Cc: davem@davemloft.net, cesarb@cesarb.net, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, rob.herring@calxeda.com, b-cousson@ti.com,
        linux@arm.linux.org.uk, eballetbo@gmail.com, javier@dowhile0.org,
        kishon@ti.com, mchehab@redhat.com, santosh.shilimkar@ti.com,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1363770725-13717-2-git-send-email-kishon@ti.com>
References: <1363770725-13717-1-git-send-email-kishon@ti.com> <1363770725-13717-2-git-send-email-kishon@ti.com>
Date: Mon, 15 Apr 2013 12:34:16 +0100
Message-Id: <20130415113416.7C3943E0AA8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013 14:42:00 +0530, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> The PHY framework provides a set of APIs for the PHY drivers to
> create/destroy a PHY and APIs for the PHY users to obtain a reference to the
> PHY with or without using phandle. To obtain a reference to the PHY without
> using phandle, the platform specfic intialization code (say from board file)
> should have already called phy_bind with the binding information. The binding
> information consists of phy's device name, phy user device name and an index.
> The index is used when the same phy user binds to mulitple phys.
> 
> PHY drivers should create the PHY by passing phy_descriptor that has
> describes the PHY (label, type etc..) and ops like init, exit, suspend, resume,
> poweron, shutdown.
> 
> The documentation for the generic PHY framework is added in
> Documentation/phy.txt and the documentation for the sysfs entry is added
> in Documentation/ABI/testing/sysfs-class-phy.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Hi Kishon,

For review purposes, I'll skip most of the implementation and focus on
the data structures. I think you need to take another look at the
approach your using. The kernel already provides a lot of support for
implementing devices and binding them to drivers that you should be
able to use...


[...]
> +/**
> + * struct phy - represent the phy device
> + * @dev: phy device
> + * @label: label given to phy
> + * @type: specifies the phy type
> + * @of_node: device node of the phy
> + * @ops: function pointers for performing phy operations
> + */
> +struct phy {
> +	struct device		dev;
> +	const char		*label;
> +	int			type;
> +	struct bus_type		*bus;
> +	struct device_node	*of_node;
> +	struct phy_ops		*ops;
> +};

Alright, so the core of the functionality is this 'struct phy' which
tracks all the instances of PHY devices. As I understand it each
physical phy will have a 'struct phy' instance tracking it. That makes
sense.

struct phy embeds a struct device. Also good. The linux driver model
knows all about devices and how to handle them. However, most of the
rest of this structure looks to be reinventing stuff the driver model
already does.

'label' seems unnecessary. struct device embeds a struct kobject, which
means it has a name and shows up in sysfs. Is there a reason that the
device name cannot be used directly?

'type' I just don't understand. I don't see any users of it in this
patch. I only see where it is set.

'bus' absolutely should not be here. The bus type should be set in the
struct device by this subsystem when the device gets registered. There
is no reason to have a pointer to it here.

'of_node' is already in struct device

Finally, it really doesn't look right for a device object to have an
'ops' structure. The whole point of the driver model is that a struct
device doesn't encapsulate any behaviour. A device gets registers to a
bus type, and then the driver core will associate a struct device_driver
to a device that it is able to drive, and the struct device_driver is
supposed to contain any ops structure used to control the device.

> +
> +/**
> + * struct phy_bind - represent the binding for the phy
> + * @dev_name: the device name of the device that will bind to the phy
> + * @phy_dev_name: the device name of the phy
> + * @index: used if a single controller uses multiple phys
> + * @auto_bind: tells if the binding is done explicitly from board file or not
> + * @phy: reference to the phy
> + * @list: to maintain a linked list of the binding information
> + */
> +struct phy_bind {
> +	const char	*dev_name;
> +	const char	*phy_dev_name;
> +	int		index;
> +	int		auto_bind:1;
> +	struct phy	*phy;
> +	struct list_head list;
> +};

How are PHYs attached to the system. Would the PHY be a direct child of
the host controller device, or would a PHY hang off another bus (like
i2c) for control? (this is how Ethernet phys work; they hang off the
MDIO bus, but may be attached to any Ethernet controller).

Since there is at most a 1:N relationship between host controllers and
PHYs, there shouldn't be any need for a separate structure to describe
binding. Put the inding data into the struct phy itself. Each host
controller can have a list of phys that it is bound to.

Tring to maintain a separate global list of PHY bindings isn't a good
idea. Keep it local to the host controller and the specific phys
instead.

g.
