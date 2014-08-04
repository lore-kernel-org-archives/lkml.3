Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaHDPCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:02:51 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55040 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaHDPCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:02:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Yijing Wang <wangyijing@huawei.com>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Date: Mon, 4 Aug 2014 16:59:31 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Paul.Mundt@huawei.com, Marc Zyngier <marc.zyngier@arm.com>,
        linux-pci@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        virtualization@lists.linux-foundation.org,
        Xinwei Hu <huxinwei@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Wuyun <wuyun.wu@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <201408011552.32135.arnd@arndb.de> <53DF2B7B.4000605@huawei.com>
In-Reply-To: <53DF2B7B.4000605@huawei.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201408041659.31364.arnd@arndb.de>
X-Provags-ID: V02:K0:lUTWtW466RlSNFQvZBIP9lFD9fwlO+/olHTcM1nl5a1
 yd0bjYNdtzYttTcMgLsnOKE2C2pWlW27V7bIkv9DIfmYQlD0Xc
 z2fjiuxErIzvaW0L7RnxSF2zKW708BiAp/bzGrLo1zYcsCdbIc
 PysSarzfAwZLrKfnba1Wmv5uVI/on3MKsYP84G7ZGEEoVnqrxs
 kEY7qdnIqW1+5d6HfQChs9ygjjFMM0ICK+bU0ZkKwEuCUn0c1z
 XsnZcTN4H0VRpCJ7OuqQCQXL3JKyp3Z0bG4XdaFaGf0ROonHgg
 kRvi/jVGM0xZkZ5m5+PYnAEivVZnxuYe9jOsNH6lkEL4hgf8vr
 S6FUJfl81AGn2Ss4bgty2pRt8I5H2wd7CikpDU41x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2014, Yijing Wang wrote:
> On 2014/8/1 21:52, Arnd Bergmann wrote:
> > On Wednesday 30 July 2014, Yijing Wang wrote:
> >> On 2014/7/29 22:08, Arnd Bergmann wrote:
> >>> The other part I'm not completely sure about is how you want to
> >>> have MSIs map into normal IRQ descriptors. At the moment, all
> >>> MSI users are based on IRQ numbers, but this has known scalability problems.
> >>
> >> Hmmm, I still use the IRQ number to map the MSIs to IRQ description.
> >> I'm sorry, I don't understand you meaning.
> >> What are the scalability problems you mentioned ?
> >> For device drivers, they always process interrupt in two steps.
> >> If irq is the legacy interrupt, drivers will first
> >> use the irq_of_parse_and_map() or pci_enable_device() to parse and get the IRQ number.
> >> Then drivers will call the request_irq() to register the interrupt handler.
> >> If irq is MSIs, first call pci_enable_msi/x() to get the IRQ number and then call
> >> request_irq() to register interrupt handler.
> > 
> > The method you describe here makes sense for PCI devices that are required to support
> > legacy interrupts and may or may not support MSI on a given system, but not so much
> > for platform devices for which we know exactly whether we want to use MSI
> > or legacy interrupts.
> > 
> > In particular if you have a device that can only do MSI, the entire pci_enable_msi
> > step is pointless: all we need to do is program the correct MSI target address/message
> > pair into the device and register the handler.
> 
> Yes, I almost agree if we won't change the existing hundreds of drivers, what
> I worried about is some drivers may want to know the IRQ numbers, and use the IRQ
> number to process different things, as I mentioned in another reply.
> But we can also provide the interface which integrate MSI configuration and request_irq(),
> if most drivers don't care the IRQ number.

The driver would still have the option of getting the IRQ number for now: With
the interface I imagine, you would get a 'struct msi_desc' pointer, from which
you can look up the 'struct irq_desc' pointer (either embedded in msi_desc,
or using a pointer from a member of msi_desc), and you can already get the
interrupt number from the irq_desc.

My point was that a well-written driver already does not care about the interrupt
number: the only information a driver needs in the interrupt handler is a pointer
to its own context, which we already derive from the irq_desc.

The main interface that currently requires the irq number is free_irq(), but
I would argue that we can just add a wrapper that takes the msi_desc pointer
as its first argument so the driver does not have to worry about it.

We can add additional wrappers like that as needed.

> >>> What I'd envision as the API from the device driver perspective is something
> >>> as simple like this:
> >>>
> >>> struct msi_desc *msi_request(struct msi_chip *chip, irq_handler_t handler,
> >>> 			unsigned long flags, const char *name, struct device *dev);
> >>>
> >>> which would get an msi descriptor that is valid for this device (dev)
> >>> connected to a particular msi_chip, and associate a handler function
> >>> with it. The device driver can call that function and retrieve the
> >>> address/message pair from the msi_desc in order to store it in its own
> >>> device specific registers. The request_irq() can be handled internally
> >>> to msi_request().
> >>
> >> This is a huge change for device drivers, and some device drivers don't know which msi_chip
> >> their MSI irq deliver to. I'm reworking the msi_chip, and try to use msi_chip to eliminate
> >> all arch_msi_xxx() under every arch in kernel. And the important point is how to create the
> >> binding for the MSI device to the target msi_chip.
> > 
> > Which drivers are you thinking of? Again, I wouldn't expect to change any PCI drivers,
> > but only platform drivers that do native MSI, so we only have to change drivers that
> > do not support any MSI at all yet and that need to be changed anyway in order to add
> > support.
> 
> I mean platform device drivers, because we can find the target msi_chip by some platform
> interfaces(like the existing of_pci_find_msi_chip_by_node()). So we no need to explicitly
> provide the msi_chip as the function argument.

Right, that works too. I was thinking we might need an interface that allows us to
pick a particular msi_chip if there are several alternatives (e.g. one in the GIC
and one in the PCI host), but you are right: we should normally be able to hardwire
that information in DT or elsewhere, and just need the 'struct device pointer' which
should probably be the first argument here.

As you pointed out, it's common to have multiple MSIs for a single device, so we
also need a context to pass around, so my suggestion would become something like:

struct msi_desc *msi_request(struct device *dev, irq_handler_t handler,
 			unsigned long flags, const char *name, void *data);

It's possible that we have to add one or two more arguments here.

> > A degenerate case of this would be a system where a PCI device sends its MSI into
> > the host controller, that generates a legacy interrupt and that in turn gets 
> > sent to an irqchip which turns it back into an MSI for the GICv3. This would of
> > course be very inefficient, but I think we should be able to express this with
> > both the binding and the in-kernel framework just to be on the safe side.
> 
> Yes, the best way to tell the kernel which msi_chip should deliver to is describe
> the binding in DTS file. If a real degenerate case found, we can update the platform
> interface which is responsible for getting the match msi_chip in future.

Ok.

	Arnd
