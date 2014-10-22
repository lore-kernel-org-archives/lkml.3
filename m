Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbaJVV2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:28:52 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:59990 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbaJVV2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <1413813882-27047-1-git-send-email-marcel.a@redhat.com>
References: <1413813882-27047-1-git-send-email-marcel.a@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 22 Oct 2014 15:28:29 -0600
Message-ID: <CAErSpo4bx1tZMi1rhKhRoE6v9EVr6iTFVw=oQaLEpzT+h=U5Tg@mail.gmail.com>
Subject: Re: [PATCH v4] PCI: add kernel parameter to override devid<->driver mapping.
To: Marcel Apfelbaum <marcel.a@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        marcel@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

I'm not quite clear on what the objective is here, so I apologize for
some questions that probably seem silly.

On Mon, Oct 20, 2014 at 8:04 AM, Marcel Apfelbaum <marcel.a@redhat.com> wrote:
> Scanning a lot of devices during boot requires a lot of time.

I think what takes a lot of time is the .probe() method for some
drivers, right?  I first thought you meant that it took a long time
for the PCI core to enumerate a lot of devices, but you're not
changing anything there.

If the intent is to reduce boot time, I don't think this is a general
solution.  Drivers should be able to schedule asynchronous things in
their .probe() methods if necessary.

> On other scenarios there is a need to bind a driver to a specific slot.

A short example here would be good.  Are you talking about something
like binding a NIC driver to one device while leaving others unbound
for use by guests?

> Binding devices to pci-stub driver does not work,
> as it will not differentiate between devices of the
> same type.

I assume you mean booting with "pci-stub.ids=$VENDOR:$DEVICE" will
make pci-stub bind to *all* matching devices, and you only want it to
bind to some.  Maybe pci-stub could be extended to pay attention to
PCI bus addresses in addition to vendor/device IDs.

> Using some start scripts is error prone.
>
> The solution leverages driver_override functionality introduced by
>
>         commit: 782a985d7af26db39e86070d28f987cad21313c0
>         Author: Alex Williamson <alex.williamson@redhat.com>
>         Date:   Tue May 20 08:53:21 2014 -0600
>
>         PCI: Introduce new device binding path using pci_dev.driver_override
>
> In order to bind PCI slots to specific drivers use:
>         pci=driver[xxxx:xx:xx.x]=foo,driver[xxxx:xx:xx.x]=bar,...

If/when you address Alex's comments about other bus types, can you
also update the changelog to use the canonical commit reference
format, i.e., 782a985d7af2 ("PCI: Introduce new device binding path
using pci_dev.driver_override") in this case?

PCI bus numbers are mutable, e.g., they can change with hotplug or
other configuration changes.  But I don't have any better suggestion,
so I guess all we can do is be aware of this.

Speaking of hotplug, this is only a boot-time kernel parameter, with
no opportunity to use this, e.g., to add slot/driver pairs, after
boot.  Do you not need that because of Alex's driver_override thing?
How can we integrate this all together into a coherent whole?  I'm a
little confused as to how this would all be documented in a form
usable by end-users.

Bjorn
