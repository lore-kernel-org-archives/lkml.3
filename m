Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab3FYD56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 23:57:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab3FYD54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 23:57:56 -0400
Message-ID: <1372132661.30572.354.camel@ul30vt.home>
Subject: Re: [PATCH] PCI: avoid NULL deref in alloc_pcie_link_state
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>
Date: Mon, 24 Jun 2013 21:57:41 -0600
In-Reply-To: <CAErSpo5m_6cJEBO56_uEAMbUjYL6pPwZ9dqz59RPBfZqCLuFBg@mail.gmail.com>
References: <1371668174-32115-1-git-send-email-rkrcmar@redhat.com>
	 <CAErSpo7O2YUUq-Ninu+BdmnrDGcU_h5=h=v1MBCoLorSDZW=Ow@mail.gmail.com>
	 <1372129109.30572.335.camel@ul30vt.home>
	 <CAErSpo5m_6cJEBO56_uEAMbUjYL6pPwZ9dqz59RPBfZqCLuFBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 21:35 -0600, Bjorn Helgaas wrote:
> On Mon, Jun 24, 2013 at 8:58 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Mon, 2013-06-24 at 19:38 -0600, Bjorn Helgaas wrote:
> >> [+cc Michael, Alex, Isaku]
> >>
> >> On Wed, Jun 19, 2013 at 12:56 PM, Radim Krčmář <rkrcmar@redhat.com> wrote:
> >> > PCIe switch upstream port can be connected directly to the PCIe root bus
> >> > in QEMU; ASPM does not expect this topology and dereferences NULL pointer
> >> > when initializing.
> >> >
> >> > I have not confirmed this can happen on real hardware, but it is presented
> >> > as a feature in QEMU, so there is no reason to panic if we can recover.
> >>
> >> This doesn't seem like a valid hardware topology to me.  If this *can*
> >> occur on real hardware, we should fix it in Linux.  If not, maybe QEMU
> >> should be changed to disallow it.
> >
> > I think a quad-port 82576 plugged into an express slot is likely the
> > same topology.
> 
> I don't think that would be the same topology Radim described.  In
> Radim's case, we have this:
> 
>   00:03.0 upstream port
>   01:00.0 downstream port
> 
> and when we call alloc_pcie_link_state() for 01:00.0,
> 
>   pdev is 01:00.0
>   pdev->bus is bus 01
>   pdev->bus->parent is bus 00
>   pdev->bus->parent->self (the bridge device leading to bus 00) is NULL
> 
> But in the case of a quad 82576 plugged into a slot, there would be a
> root port or a downstream port leading to the slot's link, so my guess
> is we'd have something like this (based on lspci output I found at
> [1]):
> 
>   00:05.0 root port leading to slot (bridge to [bus 01-08])
>   01:00.0 upstream port of switch on card (bridge to [bus 02-08])
>   02:02.0 downstream port (bridge to [bus 03-05])
>   02:04.0 downstream port (bridge to [bus 06-08])
>   03:00.0 82576 port 0
>   03:00.1 82576 port 1
>   06:00.0 82576 port 2
>   06:00.1 82576 port 3
> 
> So when we call alloc_pcie_link_state() for 02:02.0,
> 
>   pdev is 02:02.0
>   pdev->bus is bus 02
>   pdev->bus->parent is bus 01
>   pdev->bus->parent->self (the bridge leading to bus 01) is 00:05.0


Oops, I misread his statement.  I don't think an upstream port connected
directly to a root complex is valid.  I thought he was having problems
with an upstream port connected to a root port, which is obviously
valid.  QEMU lets us attach nearly anything to the root complex, most of
them aren't valid.  Thanks,

Alex

