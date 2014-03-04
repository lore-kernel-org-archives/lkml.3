Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbaCDUxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:53:39 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:36755 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaCDUxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:53:35 -0500
MIME-Version: 1.0
In-Reply-To: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 4 Mar 2014 13:53:13 -0700
Message-ID: <CAErSpo6V+P-fVibXysQeDRRcxAarrtqpe+UNemy=LECCXT_QhA@mail.gmail.com>
Subject: Re: [PATCH 0/9] PCI: Use IORESOURCE_UNSET for unassigned BARs
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 12:37 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> I'm trying to unify the way we handle unassigned PCI BARs, i.e., resources
> where we know the type and size, but we haven't assigned an address yet.
> The PCI core and the various architectures don't really have a consistent
> way of dealing with these.
>
> Many places currently use "res->start == 0" to indicate unassigned
> resources.  I don't think that's a good idea in general, because it's
> possible for a resource to actually start at zero.  Zero is also a
> perfectly good BAR value, especially for a host bridge that translates
> addresses, so I want to support that, too.
>
> The IORESOURCE_UNSET flag exists already, but is hardly used at all.  In
> drivers/pci, we set it for an obscure error case, and clear it when
> updating a BAR.  The microblaze and powerpc architectures use it the same
> way I want to use it here: to indicate a resource with no assigned address.
>
> Here's the outline of what this series does:
>
> - Add resource_contains(): true iff r1 contains r2 (for minor cleanup)
> - Make %pR print resource size, not address, when IORESOURCE_UNSET
> - Stop advertising pci_find_parent_resource() for use in allocation
> - Mark PCI resources IORESOURCE_UNSET when BIOS left decoding disabled
> - Mark PCI resources IORESOURCE_UNSET while we're trying to assign addresses
> - Don't enable PCI decoding when no address has been assigned to BARs
>
> It might be too aggressive to ignore the initial value of a BAR and try to
> reassign it when the BIOS left decoding disabled.  If the BIOS left
> decoding *enabled*, we can have some confidence that the BAR value is
> valid.  It's possible the BAR is also valid even if the BIOS turned off
> decoding.  We could conceivably try to use BAR values that are inside
> upstream bridge windows, even if the BAR was initially disabled.  But this
> first pass just ignores the values in BARs that are disabled.
>
> I welcome any comments :)
>
> ---
>
> Bjorn Helgaas (9):
>       resource: Add resource_contains()
>       vsprintf: Add support for IORESOURCE_UNSET in %pR
>       PCI: Remove pci_find_parent_resource() use for allocation
>       PCI: Mark resources as IORESOURCE_UNSET if we can't assign them
>       PCI: Don't clear IORESOURCE_UNSET when updating BAR
>       PCI: Check IORESOURCE_UNSET before updating BAR
>       PCI: Don't try to claim IORESOURCE_UNSET resources
>       PCI: Ignore BAR contents when firmware left decoding disabled
>       PCI: Don't enable decoding if BAR hasn't been assigned an address
>
>
>  drivers/pci/host-bridge.c |    8 --------
>  drivers/pci/pci.c         |   41 +++++++++++++++++++++++++----------------
>  drivers/pci/probe.c       |    8 +++++++-
>  drivers/pci/quirks.c      |    5 +++++
>  drivers/pci/rom.c         |    2 ++
>  drivers/pci/setup-res.c   |   37 +++++++++++++++++++++++++------------
>  include/linux/ioport.h    |   12 +++++++++++-
>  kernel/resource.c         |    8 ++------
>  lib/vsprintf.c            |   13 +++++++++----
>  9 files changed, 86 insertions(+), 48 deletions(-)

I applied these to pci/resource for v3.15.
