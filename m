Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaHANw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:52:56 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:57602 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaHANwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:52:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Yijing Wang <wangyijing@huawei.com>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Date: Fri, 1 Aug 2014 15:52:31 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Paul.Mundt@huawei.com, Marc Zyngier <marc.zyngier@arm.com>,
        linux-pci@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        virtualization@lists.linux-foundation.org,
        Xinwei Hu <huxinwei@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, Wuyun <wuyun.wu@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <1748052.OMBQJiOLYT@wuerfel> <53D85C2E.3060205@huawei.com>
In-Reply-To: <53D85C2E.3060205@huawei.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201408011552.32135.arnd@arndb.de>
X-Provags-ID: V02:K0:jVLCfx+hyzIqcDLhbiw0wPMpA2lWHHVRgO24VDr+VqP
 BBxUek0W1E8qKoHAWft44DX98llCAofp6JOGKAehvGRY3e0XP2
 2HVGcF2QaPcDL4enTMEkbGrk4T1ZUJqVczxnND6SlL35pwRbMm
 8g/S8wbvrja2xYkzY4s9ULA/VBN0u1NpyPR8MrkloVVH5dgPM8
 Yi9e/amFmzbpVgjrZSym7jtYamH0PdSht3pHBm/s4gw4n8ywcu
 AUB9Bzu06BWPOj0LpkxuU4TY3jdlrWw4NmCK6p4+/nDhzy0pJ0
 qkkoZpEhmQ0ax295FLBU+zSWgzbJXDg9L8CnSzsD5VlwkhUj2E
 7I94v4Jl3Ds1StXzcbi6igdlk5s/TJu8L/C0Jxglh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2014, Yijing Wang wrote:
> On 2014/7/29 22:08, Arnd Bergmann wrote:
> > On Saturday 26 July 2014 11:08:37 Yijing Wang wrote:
> >>
> >> The new data struct for generic MSI driver.
> >> struct msi_irqs {
> >>         u8 msi_enabled:1; /* Enable flag */
> >>         u8 msix_enabled:1;
> >>         struct list_head msi_list; /* MSI desc list */
> >>         void *data;     /* help to find the MSI device */
> >>         struct msi_ops *ops; /* MSI device specific hook */
> >> };
> >> struct msi_irqs is used to manage MSI related informations. Every device supports
> >> MSI should contain this data struct and allocate it.
> > 
> > I think you should have a stronger association with the 'struct
> > device' here. Can you replace the 'void *data' with 'struct device *dev'?
> 
> Actually, I used the struct device *dev in my first draft, finally, I replaced
> it with void *data, because some MSI devices don't have a struct device *dev,
> like the existing hpet device, dmar msi device, and OF device, like the ARM consolidator.
> 
> Of course, we can make the MSI devices have their own struct device, and register to
> device tree, eg, add a class device named MSI_DEV. But I'm not sure whether it is appropriate.

It doesn't have to be in the (OF) device tree, but I think it absolutely makes
sense to use the 'struct device' infrastructure here, as almost everything uses
a device, and the ones that don't do that today can be easily changed.

> > The other part I'm not completely sure about is how you want to
> > have MSIs map into normal IRQ descriptors. At the moment, all
> > MSI users are based on IRQ numbers, but this has known scalability problems.
> 
> Hmmm, I still use the IRQ number to map the MSIs to IRQ description.
> I'm sorry, I don't understand you meaning.
> What are the scalability problems you mentioned ?
> For device drivers, they always process interrupt in two steps.
> If irq is the legacy interrupt, drivers will first
> use the irq_of_parse_and_map() or pci_enable_device() to parse and get the IRQ number.
> Then drivers will call the request_irq() to register the interrupt handler.
> If irq is MSIs, first call pci_enable_msi/x() to get the IRQ number and then call
> request_irq() to register interrupt handler.

The method you describe here makes sense for PCI devices that are required to support
legacy interrupts and may or may not support MSI on a given system, but not so much
for platform devices for which we know exactly whether we want to use MSI
or legacy interrupts.

In particular if you have a device that can only do MSI, the entire pci_enable_msi
step is pointless: all we need to do is program the correct MSI target address/message
pair into the device and register the handler.

> > I wonder if we can do the interface in a way that
> > hides the interrupt number from generic device drivers and just
> > passes a 'struct irq_desc'. Note that there are long-term plans to
> > get rid of IRQ numbers entirely, but those plans have existed for
> > a long time already without anybody seriously addressing the device
> > driver interfaces so far, so it might never really happen.
> > 
> 
> Maybe this is a huge work, now hundreds drivers use the IRQ number, so maybe we can consider
> this in a separate title.

Sorry for being unclear here: I did suggest changing all drivers now. What I meant
is that we use a different API for non-PCI devices that works without IRQ numbers.
I don't think we should touch the PCI interfaces at this point.

> > With the other operations, I think they should all take a 'struct device *'
> > as the first argument for convenience and consistency. I don't think you actually
> > need msi_read_message(), and we could avoid msi_write_message() by doing it
> > the other way round.
> > 
> 
> There only two functions use the read_msi_msg(), because every msi_desc has
> a struct msi_msg, and it caches the msi address and data. I will consider to
> retrieve the msg from cached msi_msg, then we can avoid the msi_read_message().
> But msi_write_message() maybe necessary, some xxx_set_affinity() functions and
> restore functions need the msi_write_message() to rewrite the address and data.

Makes sense. I'd have to think about it more, but I think you are right
about the affinity APIs needing this.

> > What I'd envision as the API from the device driver perspective is something
> > as simple like this:
> > 
> > struct msi_desc *msi_request(struct msi_chip *chip, irq_handler_t handler,
> > 			unsigned long flags, const char *name, struct device *dev);
> > 
> > which would get an msi descriptor that is valid for this device (dev)
> > connected to a particular msi_chip, and associate a handler function
> > with it. The device driver can call that function and retrieve the
> > address/message pair from the msi_desc in order to store it in its own
> > device specific registers. The request_irq() can be handled internally
> > to msi_request().
> 
> This is a huge change for device drivers, and some device drivers don't know which msi_chip
> their MSI irq deliver to. I'm reworking the msi_chip, and try to use msi_chip to eliminate
> all arch_msi_xxx() under every arch in kernel. And the important point is how to create the
> binding for the MSI device to the target msi_chip.

Which drivers are you thinking of? Again, I wouldn't expect to change any PCI drivers,
but only platform drivers that do native MSI, so we only have to change drivers that
do not support any MSI at all yet and that need to be changed anyway in order to add
support.

> For PCI device, some arm platform already bound the msi_chip to the pci hostbridge, then all
> pci devices under the pci hostbridge deliver their MSI irqs to the target msi_chip.
> And other platform create the binding in DTS file, then the MSI device can find their msi_chip
> by device_node.
> I don't know whether there are other situations, we should provide a generic interface that
> every MSI device under every platform can use it to find its msi_chip exactly.

We have introduced the "msi-parent" property to mirror the "interrupt-parent" property.
For the PCI case, this property is only needed in the PCI host controller, and there
can be a system-wide default, by putting the "msi-parent" property into the root device
node or the node of a bus that is parent to all devices supporting MSI.

For non-PCI devices, it should be possible to override the "msi-parent" property per
device, but those can also use the global property.

The main use case that I see are PCI host controllers that have their own MSI catcher
included, so meaning that any PCI device can either send its MSIs there, or to a
system-wide GICv3 instance, and we need a way to select which one.

A degenerate case of this would be a system where a PCI device sends its MSI into
the host controller, that generates a legacy interrupt and that in turn gets 
sent to an irqchip which turns it back into an MSI for the GICv3. This would of
course be very inefficient, but I think we should be able to express this with
both the binding and the in-kernel framework just to be on the safe side.


	Arnd
