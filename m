Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3HSW7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:59:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab3HSW7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:59:42 -0400
Message-ID: <1376953177.2657.33.camel@ul30vt.home>
Subject: Re: [PATCH] vfio-pci: PCI hot reset interface
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 19 Aug 2013 16:59:37 -0600
In-Reply-To: <1376952167.25016.85.camel@pasglop>
References: <20130814200845.21923.64284.stgit@bling.home>
	 <CAErSpo4zfuaaBSDci4jOu_9RgUfLQNPvKhro1OEh=8AMvAFWYw@mail.gmail.com>
	 <1376521578.13642.65.camel@ul30vt.home>
	 <1376937682.2657.15.camel@ul30vt.home>
	 <CAErSpo50ve+ZMqcX=13hKvrB75LyWmUddC-qyX7Esfr=P5StcA@mail.gmail.com>
	 <1376952167.25016.85.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 08:42 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-08-19 at 14:02 -0600, Bjorn Helgaas wrote:
> > I guess.  And supply the pci_slot rather than the pci_dev?  I'm a
> > little bit worried because the idea of a "slot" is not well-defined in
> > the spec, and we have sort of an ad hoc method of discovering and
> > managing them, e.g., acpiphp and pciehp might discover the same slot.
> > But I guess that's no reason to bury generic code in vfio.
> 
> And I don't have pci_slot's at all yet on powerpc "powernv" (the host
> platform for KVM) since at this stage we don't support physical hotplug
> on the target machines...
> 
> Alex, why specifically looking for "slots" here ? I don't quite
> understand. It makes sense to be able to reset individual devices
> whether they are on the otherboard, behind extension chassis or directly
> on slots...

a) resetting a slot may have a smaller footprint than resetting a bus,
b) hotplug controllers sometimes need to be involved in a bus reset.
For b) I have a specific example where my Lenovo S20 workstation has an
onboard tg3 NIC attached to a root port supporting pciehp (go figure
since the tg3 is soldered onto the motherboard) and doing a secondary
bus reset at the root port triggers a presence detection change and
therefore tries to do a surprise removal.  By doing a "slot" reset, I
have the hotplug controller code manage the bus reset by disabling
presence detection around the bus reset.  If you don't have slots and
you don't need anything special around a secondary bus reset, you're
fine.  It's just an opportunity to provide a hook for the hotplug
controller to participate.  Thanks,

Alex


