Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081Ab3DOTuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 15:50:39 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57982 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933716Ab3DOTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 15:50:37 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 1/6] drivers: phy: add generic PHY framework
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, arnd@arndb.de,
        akpm@linux-foundation.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, rob.herring@calxeda.com, b-cousson@ti.com,
        linux@arm.linux.org.uk, eballetbo@gmail.com, javier@dowhile0.org,
        mchehab@redhat.com, santosh.shilimkar@ti.com,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <516BF1E2.3020104@ti.com>
References: <1363770725-13717-1-git-send-email-kishon@ti.com> <1363770725-13717-2-git-send-email-kishon@ti.com> <20130415113416.7C3943E0AA8@localhost> <516BF1E2.3020104@ti.com>
Date: Mon, 15 Apr 2013 20:50:30 +0100
Message-Id: <20130415195030.9F7E93E0AA8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013 17:56:10 +0530, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
> 
> On Monday 15 April 2013 05:04 PM, Grant Likely wrote:
> > On Wed, 20 Mar 2013 14:42:00 +0530, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> >> The PHY framework provides a set of APIs for the PHY drivers to
> >> create/destroy a PHY and APIs for the PHY users to obtain a reference to the
> >> PHY with or without using phandle. To obtain a reference to the PHY without
> >> using phandle, the platform specfic intialization code (say from board file)
> >> should have already called phy_bind with the binding information. The binding
> >> information consists of phy's device name, phy user device name and an index.
> >> The index is used when the same phy user binds to mulitple phys.
> >>
> >> PHY drivers should create the PHY by passing phy_descriptor that has
> >> describes the PHY (label, type etc..) and ops like init, exit, suspend, resume,
> >> poweron, shutdown.
> >>
> >> The documentation for the generic PHY framework is added in
> >> Documentation/phy.txt and the documentation for the sysfs entry is added
> >> in Documentation/ABI/testing/sysfs-class-phy.
> >>
> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >
> > Hi Kishon,
> >
> > For review purposes, I'll skip most of the implementation and focus on
> > the data structures. I think you need to take another look at the
> > approach your using. The kernel already provides a lot of support for
> > implementing devices and binding them to drivers that you should be
> > able to use...
> >
> >
> > [...]
> >> +/**
> >> + * struct phy - represent the phy device
> >> + * @dev: phy device
> >> + * @label: label given to phy
> >> + * @type: specifies the phy type
> >> + * @of_node: device node of the phy
> >> + * @ops: function pointers for performing phy operations
> >> + */
> >> +struct phy {
> >> +	struct device		dev;
> >> +	const char		*label;
> >> +	int			type;
> >> +	struct bus_type		*bus;
> >> +	struct device_node	*of_node;
> >> +	struct phy_ops		*ops;
> >> +};
> >
> > Alright, so the core of the functionality is this 'struct phy' which
> > tracks all the instances of PHY devices. As I understand it each
> > physical phy will have a 'struct phy' instance tracking it. That makes
> > sense.
> >
> > struct phy embeds a struct device. Also good. The linux driver model
> > knows all about devices and how to handle them. However, most of the
> > rest of this structure looks to be reinventing stuff the driver model
> > already does.
> >
> > 'label' seems unnecessary. struct device embeds a struct kobject, which
> > means it has a name and shows up in sysfs. Is there a reason that the
> > device name cannot be used directly?
> 
> hmm.. the label name is supposed to be a simpler name than device name.
> Say for instance "omap-usb2.1.auto" device name can simply be 
> "omap-usb2-phy". Further the device name while using dt will have 
> register address in it. However it's used only for displaying the label 
> in sysfs entry (/sys/class/phy/<phy>/label).

I wouldn't go mucking with names in that way. Stick with one name and
drop the separate label. Otherwise you introduce addtional sources of
confusion.

> >
> > 'type' I just don't understand. I don't see any users of it in this
> > patch. I only see where it is set.
> 
> yeah. Was planning to remove this in my next version (btw the latest is 
> version 5).
> >
> > 'bus' absolutely should not be here. The bus type should be set in the
> > struct device by this subsystem when the device gets registered. There
> > is no reason to have a pointer to it here.
> 
> right. I had removed it in version 5 of this patch series.
> >
> > 'of_node' is already in struct device
> 
> I wasn't sure if we can manually assign the of_node of one device to 
> of_node of an another device. Here the of_node comes from _phy provider_.

There is no problem with multiple devices referencing the same node. The
only time it may cause problems is when two devices of the same bus type
are referencing the same of_node. In that situation the device will get
probed more than once. You're not in that situation.

> > Finally, it really doesn't look right for a device object to have an
> > 'ops' structure. The whole point of the driver model is that a struct
> > device doesn't encapsulate any behaviour. A device gets registers to a
> > bus type, and then the driver core will associate a struct device_driver
> 
> We have decided not to implement the PHY layer as a separate bus layer. 
> The PHY provider can be part of any other bus. Making the PHY layer as a 
> bus will make the PHY provider to be part of multiple buses which will 
> lead to bad design. All we are trying to do here is keep the pool of PHY 
> devices under PHY class in this layer and help any controller that wants 
> to use the PHY to get it.

If you're using a class, then you already have your list of registered
phy devices! :-) No need to create another global list that you need to
manage.

You really need to be careful here though. By lumping all the phy types
into a single pot your glossing over the fact that different subsystems
have phys that behave differently. It is just fine to have a framework
that works in lots of places, it's actively encouraged, but by putting
the struct device into struct phy, you're taping into a large amount of
assumptions that the linux kernel makes about what devices are. For
instance, it is generally assumed that a class contains a bunch of the
same devices; but in this framework it is explicitly not true.

I would also imagine that each of the subsystems will want to wrap the
struct phy with subsystem specific additions so it will be important to
ensure the correct type of device is always returned.

You'd be better off providing a set of utility functions that work for
all the types of phys, but have a separate instance for each one. For
example, you could have a separate class for each phy type, but all of
them use the same utility function.

> > to a device that it is able to drive, and the struct device_driver is
> > supposed to contain any ops structure used to control the device.
> >
> >> +
> >> +/**
> >> + * struct phy_bind - represent the binding for the phy
> >> + * @dev_name: the device name of the device that will bind to the phy
> >> + * @phy_dev_name: the device name of the phy
> >> + * @index: used if a single controller uses multiple phys
> >> + * @auto_bind: tells if the binding is done explicitly from board file or not
> >> + * @phy: reference to the phy
> >> + * @list: to maintain a linked list of the binding information
> >> + */
> >> +struct phy_bind {
> >> +	const char	*dev_name;
> >> +	const char	*phy_dev_name;
> >> +	int		index;
> >> +	int		auto_bind:1;
> >> +	struct phy	*phy;
> >> +	struct list_head list;
> >> +};
> >
> > How are PHYs attached to the system. Would the PHY be a direct child of
> > the host controller device, or would a PHY hang off another bus (like
> > i2c) for control? (this is how Ethernet phys work; they hang off the
> > MDIO bus, but may be attached to any Ethernet controller).
> 
> This layer does not have any restriction on how the PHY is attached to 
> the system. For all the sample cases (USB OTG controller in OMAP 
> platforms) that follows this patch, the PHY is attached to the platform 
> bus and the PHY provider is a platform driver. All this framework does 
> is maintain a list of PHY's added in the system and helps the controller 
> to find the appropriate PHY.

Okay, that's what I thought. A lot of systems end up looking this way.
So I would assume that for an i2c-controlled phy, and i2c driver would
bind against the device, and the probe hook would create and register a
phy device. That would make the sysfs tree look something like:

/sys/devices/.../i2c@80000000/usbphy@2/phy0

where, i2c@80000000 is the i2c master, usbphy@2 is what the phy's driver
binds against, and phy0 is created and registered by the driver of
usbphy@2 at probe time. Correct?

> We are currently not looking at having Ethernet use this layer because 
> it itself has a comprehensive PHY layer and merging it with this will 
> take some effort. However other subsystems like USB, SATA, video etc.. 
> can make use of this.
> >
> > Since there is at most a 1:N relationship between host controllers and
> > PHYs, there shouldn't be any need for a separate structure to describe
> > binding. Put the inding data into the struct phy itself. Each host
> > controller can have a list of phys that it is bound to.
> 
> No. Having the host controller to have a list of phys wont be a good 
> idea IMHO. The host controller is just an IP and the PHY to which it 
> will be connected can vary from board to board, platform to platform. So 
> ideally this binding should come from platform initialization code/dt data.

That is not what I mean. I mean the host controller instance should
contain a list of all the PHYs that are attached to it. There should not
be a global list. That has nothing to do with where the data of binding
comes from.

g.
