Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaCRA1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:27:08 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51730 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaCRA1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:27:05 -0400
Date: Mon, 17 Mar 2014 18:27:00 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding
 disabled
Message-ID: <20140318002700.GA22356@google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <CACVXFVOqBuCcQC6ku0abqstkgJWGe21ZztB-eTsyDwsvDvXNZw@mail.gmail.com>
 <CAErSpo4ngU60XQCD=DbFJbqNOMkOwwhHB1oau1mmr7rJQQ2+pg@mail.gmail.com>
 <CACVXFVMz+6DaSgT0EHeVfyBOsXfWDYnZQ0wy7pwcey5ahM6rUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMz+6DaSgT0EHeVfyBOsXfWDYnZQ0wy7pwcey5ahM6rUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 09:48:35AM +0800, Ming Lei wrote:
> On Fri, Mar 14, 2014 at 12:08 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Thu, Mar 13, 2014 at 2:51 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> >> Hi Bjorn,
> >>
> >> I found this patch broke virtio-pci devices.
> >
> > Thanks a lot for testing this.
> >
> >> On Thu, Feb 27, 2014 at 3:37 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >>> Don't rely on BAR contents when the command register says the BAR is
> >>> disabled.
> >>>
> >>> If we receive a PCI device from firmware (or a hot-added device that was
> >>> just powered up) with the MEMORY or IO enable bits in the PCI command
> >>> register cleared, there's no reason to believe the BARs contain valid
> >>> addresses.
> >>
> >> From PCI LOCAL BUS SPECIFICATION, REV. 3.0, both
> >> PCI_COMMAND_IO and PCI_COMMAND_MEM should be
> >> cleared after reset, so looks the patch sets IORESOURCE_UNSET
> >> too early because PCI drivers may call pci_enable_device()
> >> (->pci_enable_resources()) to enable the two bits of
> >> PCI_COMMAND explicitly.
> >
> > The point is that it's not safe to enable those two bits unless we're
> > certain that the BARs they control contain valid values that don't
> > conflict with anything else in the system.
> >
> > Maybe we should only set IORESOURCE_UNSET when we find a conflict or a
> > BAR that's not contained by an upstream bridge window, and we should
> > try to reallocate then.  I'm pretty sure we do that at least in some
> > cases, but it would probably simplify things if we did it more
> > consistently, and maybe we shouldn't set it at all here in
> > __pci_read_base().
> 
> I think so because __pci_read_base() is called in device emulation
> path.

Which path is this?  I don't know anything about virtio-pci, and I only see
calls to __pci_read_base() from:

  sriov_init()
  pci_sriov_resource_alignment()
  pci_read_bases()

> > But I'd like to understand your situation better, so can you provide
> > more details, please?  Complete before/after dmesg logs would go a
> > long way toward illustrating the problem you're seeing.
> 
> Please see the two attachment log. The memory allocation failure
> is caused by mistaken value read from pci address after the device
> is failed to enable.

Your logs are harder than necessary to compare because one has a lot more
debug turned on than the other.

In the failing case, we ignore all the initial BAR values, but we do assign
values to all of them later:

  pci 0000:00:00.0: can't claim BAR 0 [mem size 0x00000400]: no address assigned
  pci 0000:00:00.0: can't claim BAR 1 [io  size 0x0400]: no address assigned
  ...
  pci 0000:00:00.0: BAR 0: assigned [mem 0x40000000-0x400003ff]
  pci 0000:00:00.0: BAR 1: assigned [io  0x1000-0x13ff]
  ...

The newly-assigned values look valid, and as far as I can tell, they should
work.  Do you know why they don't?  Is there an assumption somewhere that
we never change BAR values?

Even if we don't need to ignore BAR values in as many cases as we do, it
should be legal to ignore them and reassign them, so I want to understand
what's going on here before reverting this.

Is there an easy way I can reproduce the problem on my own box?

Bjorn
