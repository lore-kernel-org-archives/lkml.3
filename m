Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaJWMtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:49:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbaJWMtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:49:45 -0400
Message-ID: <1414068531.2376.69.camel@localhost.localdomain>
Subject: Re: [PATCH v4] PCI: add kernel parameter to override devid<->driver
 mapping.
From: Marcel Apfelbaum <marcel.a@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        marcel@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Date: Thu, 23 Oct 2014 15:48:51 +0300
In-Reply-To: <CAErSpo4bx1tZMi1rhKhRoE6v9EVr6iTFVw=oQaLEpzT+h=U5Tg@mail.gmail.com>
References: <1413813882-27047-1-git-send-email-marcel.a@redhat.com>
	 <CAErSpo4bx1tZMi1rhKhRoE6v9EVr6iTFVw=oQaLEpzT+h=U5Tg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 15:28 -0600, Bjorn Helgaas wrote:
> Hi Marcel,
Hi Bjorn,
Thank you for the review!

> 
> I'm not quite clear on what the objective is here, so I apologize for
> some questions that probably seem silly.
I appreciate you took your time to go over it.

> 
> On Mon, Oct 20, 2014 at 8:04 AM, Marcel Apfelbaum <marcel.a@redhat.com> wrote:
> > Scanning a lot of devices during boot requires a lot of time.
> 
> I think what takes a lot of time is the .probe() method for some
> drivers, right?  I first thought you meant that it took a long time
> for the PCI core to enumerate a lot of devices, but you're not
> changing anything there.
Yes indeed.

> 
> If the intent is to reduce boot time, I don't think this is a general
> solution.  Drivers should be able to schedule asynchronous things in
> their .probe() methods if necessary.
I agree, but sadly we cannot go over *all* existing drivers and fix,
we can of course do the best effort :)
By the way this was not the only reason as you also thought, see bellow

> 
> > On other scenarios there is a need to bind a driver to a specific slot.
> 
> A short example here would be good.  Are you talking about something
> like binding a NIC driver to one device while leaving others unbound
> for use by guests?
Exactly! This is the "perfect" example, thanks!
> 
> > Binding devices to pci-stub driver does not work,
> > as it will not differentiate between devices of the
> > same type.
> 
> I assume you mean booting with "pci-stub.ids=$VENDOR:$DEVICE" will
> make pci-stub bind to *all* matching devices, and you only want it to
> bind to some.
You are right again.

>   Maybe pci-stub could be extended to pay attention to
> PCI bus addresses in addition to vendor/device IDs.
A few thoughts here:
- We will have a race here between the "native" driver and pci-stub, right?
- Why not leverage the existing driver_override feature that is already
there and gives us exactly what we want: slot<->driver mapping?
- Maybe there are other scenarios that can benefit from slot<->driver mapping,
not only pci-stub.

 


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
Sure, thanks for the tip.

> 
> PCI bus numbers are mutable, e.g., they can change with hotplug or
> other configuration changes.  But I don't have any better suggestion,
> so I guess all we can do is be aware of this.
Well, indeed, there is so much that can be done. (We can listen to an event and remap...)

> 
> Speaking of hotplug, this is only a boot-time kernel parameter, with
> no opportunity to use this, e.g., to add slot/driver pairs, after
> boot.  Do you not need that because of Alex's driver_override thing?
Well actually Alex's "driver_override" feature does that for runtime
(adds slot/driver pair), the only thing missing is the boot time
mapping.

> How can we integrate this all together into a coherent whole?  I'm a
> little confused as to how this would all be documented in a form
> usable by end-users.
For end-users it will be like this:
They want to create a slot/driver mapping.
In order to do that they will use the "driver_override" feature:
1. Run-time use:
   - Use sysfs to edit driver_override file associated with the slot.
2. Boot-time use:
   - Use the pci's driver_override parameter. 

Thanks,
Marcel
> 
> Bjorn



