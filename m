Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbaJWND0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:03:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbaJWNDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:03:21 -0400
Date: Thu, 23 Oct 2014 16:06:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Marcel Apfelbaum <marcel.a@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        marcel@redhat.com,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: Re: [PATCH v4] PCI: add kernel parameter to override devid<->driver
 mapping.
Message-ID: <20141023130654.GA11446@redhat.com>
References: <1413813882-27047-1-git-send-email-marcel.a@redhat.com>
 <CAErSpo4bx1tZMi1rhKhRoE6v9EVr6iTFVw=oQaLEpzT+h=U5Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4bx1tZMi1rhKhRoE6v9EVr6iTFVw=oQaLEpzT+h=U5Tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 03:28:29PM -0600, Bjorn Helgaas wrote:
> Hi Marcel,
> 
> I'm not quite clear on what the objective is here, so I apologize for
> some questions that probably seem silly.
> 
> On Mon, Oct 20, 2014 at 8:04 AM, Marcel Apfelbaum <marcel.a@redhat.com> wrote:
> > Scanning a lot of devices during boot requires a lot of time.
> 
> I think what takes a lot of time is the .probe() method for some
> drivers, right?  I first thought you meant that it took a long time
> for the PCI core to enumerate a lot of devices, but you're not
> changing anything there.
> 
> If the intent is to reduce boot time, I don't think this is a general
> solution.  Drivers should be able to schedule asynchronous things in
> their .probe() methods if necessary.

If this worked for all devices, we could just make probe
asynchronous in PCI core.
Unfortunately this doesn't work esp for storage devices
since people expect disks to be available for mount immediately.

If the point of the patch is to speed up boot, we could
try to probe everything in parallel?
Probe is serialized now, right?


> > On other scenarios there is a need to bind a driver to a specific slot.
> 
> A short example here would be good.  Are you talking about something
> like binding a NIC driver to one device while leaving others unbound
> for use by guests?
> 
> > Binding devices to pci-stub driver does not work,
> > as it will not differentiate between devices of the
> > same type.
> 
> I assume you mean booting with "pci-stub.ids=$VENDOR:$DEVICE" will
> make pci-stub bind to *all* matching devices, and you only want it to
> bind to some.  Maybe pci-stub could be extended to pay attention to
> PCI bus addresses in addition to vendor/device IDs.
> 
> > Using some start scripts is error prone.
> >
> > The solution leverages driver_override functionality introduced by
> >
> >         commit: 782a985d7af26db39e86070d28f987cad21313c0
> >         Author: Alex Williamson <alex.williamson@redhat.com>
> >         Date:   Tue May 20 08:53:21 2014 -0600
> >
> >         PCI: Introduce new device binding path using pci_dev.driver_override
> >
> > In order to bind PCI slots to specific drivers use:
> >         pci=driver[xxxx:xx:xx.x]=foo,driver[xxxx:xx:xx.x]=bar,...
> 
> If/when you address Alex's comments about other bus types, can you
> also update the changelog to use the canonical commit reference
> format, i.e., 782a985d7af2 ("PCI: Introduce new device binding path
> using pci_dev.driver_override") in this case?
> 
> PCI bus numbers are mutable, e.g., they can change with hotplug or
> other configuration changes.  But I don't have any better suggestion,
> so I guess all we can do is be aware of this.

We could use slot capability for addressing if that's available.

> Speaking of hotplug, this is only a boot-time kernel parameter, with
> no opportunity to use this, e.g., to add slot/driver pairs, after
> boot.  Do you not need that because of Alex's driver_override thing?
> How can we integrate this all together into a coherent whole?  I'm a
> little confused as to how this would all be documented in a form
> usable by end-users.
> 
> Bjorn
