Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab3DYRXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:23:22 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:63197 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3DYRXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130425035503.GA15749@ram.oc3035372033.ibm.com>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
 <1363217302-14383-4-git-send-email-yinghai@kernel.org> <CAErSpo4VzBZ=fAzPm1yWEs4+09_D1=rysMf6tGgnqpVEKytSzQ@mail.gmail.com>
 <20130409045113.GA7251@ram.oc3035372033.ibm.com> <CAErSpo7TReTzz289EMuh5gGKjskCLmACNT99o1s-QCzRHLGaXg@mail.gmail.com>
 <20130425035503.GA15749@ram.oc3035372033.ibm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Apr 2013 11:22:59 -0600
Message-ID: <CAErSpo704b0OhSdeRWK+cZ++6RCDvoL7vzqZVEM1WOPp9f7MRQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/27] PCI: pci resource iterator
To: Ram Pai <linuxram@us.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 9:55 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> On Wed, Apr 10, 2013 at 09:22:48AM -0600, Bjorn Helgaas wrote:
>> On Mon, Apr 8, 2013 at 10:51 PM, Ram Pai <linuxram@us.ibm.com> wrote:
>> > On Thu, Apr 04, 2013 at 04:18:01PM -0600, Bjorn Helgaas wrote:
>> >> On Wed, Mar 13, 2013 at 5:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> >> > From: Ram Pai <linuxram@us.ibm.com>
>> >> >
>> >> > Currently pci_dev structure holds an array of 17 PCI resources; six base
>> >> > BARs, one ROM BAR, four BRIDGE BARs, six sriov BARs.  This is wasteful.
>> >> > A bridge device just needs the 4 bridge resources. A non-bridge device
>> >> > just needs the six base resources and one ROM resource. The sriov
>> >> > resources are needed only if the device has SRIOV capability.
>> >> >
...
>> > I agree. There are two cleanups needed.
>> >
>> > a) pci drivers should not assume the internal organization of the
>> >         resources in the struct pci_dev.
>>
>> Do you mean that drivers should not use "pci_dev->resource[i]"?  If
>> so, I agree that it would be great if we had an accessor for BARs, but
>> it seems impractical to change all the drivers that use the current
>> style.
>
> Sorry for the delay. Was vacationing.  I mean, we cannot let drivers
> assume anything about the how the resources are organized.
>
> The only thing the drivers should know is that there are 6 normal
> resources, 4 bridge resources, 1 ROM resource and 6 iov resources.
>
> Currently the drivers assume that ROM resource follows normal resources
> followed by IOV followed by bridge. These assumptions are making it hard
> to re-organize the layout of resources in struct pci_dev.
>
> I think we need to expose the following interfaces to drivers.
>
> a) return the nth normal resource

I think this needs to remain "pci_dev->resource[n]", because so many
drivers do this that it would be impractical to change them all.

> b) return the nth iov resource

I could imagine a new interface for this, given that I only see a
dozen SR-IOV drivers in the tree.  There might be a few out-of-tree,
but there probably aren't many.

> c) return the rom resource

There are only about 30 drivers in the tree that reference
PCI_ROM_RESOURCE.  Fewer than I expected, but I'd still be hesitant
about make "pci_dev->resource[PCI_ROM_RESOURCE]" stop working.

> d) return the nth bridge resource

I think it's reasonable to have a new interface for this because
bridges are handled almost entirely in the PCI core and architecture
code, and I doubt there are many, if any, drivers that care.

> e) return the type and index of a given resource, where 'index' is
>         the index w.r.t to that resource type; not w.r.t to all
>         the resources of the device.
> f) ability to loop through all resources of the given type/types.

We do loop through resources in the core when we're assigning, fixing
up, etc., and that makes some sense to me.  But I actually don't see
the use case for *drivers* to loop through resources.  All a driver
knows is "BAR X means Y", and it generally doesn't need to iterate and
do something generic to all of them.

> Everything else needs to be hidden.

Bjorn
