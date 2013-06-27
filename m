Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3F0Qux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:50:53 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:50509 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3F0Qu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:50:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130627163246.GZ9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-3-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo4hvH08bNrObYODFVcwhhiGOj4cKntyJD6Aw6CjecgCow@mail.gmail.com>
 <20130627130229.GT9294@intel.com> <20130627163246.GZ9294@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 27 Jun 2013 10:50:08 -0600
Message-ID: <CAErSpo41WuYStPAo19k7qF5GRH+tBbS-iSR_xQtjk+egrq_vSA@mail.gmail.com>
Subject: Re: [PATCH 2/6] PCI: acpiphp: enable_device(): rescan even if no new
 devices on slot
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 10:32 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Thu, Jun 27, 2013 at 04:02:29PM +0300, Mika Westerberg wrote:
>> On Wed, Jun 26, 2013 at 05:37:58PM -0600, Bjorn Helgaas wrote:
>> > > @@ -707,8 +702,11 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>> > >                             dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
>> > >                                 max = pci_scan_bridge(bus, dev, max, pass);
>> > >                                 if (pass && dev->subordinate) {
>> > > -                                       check_hotplug_bridge(slot, dev);
>> > > -                                       pcibios_resource_survey_bus(dev->subordinate);
>> > > +                                       if (!dev->subordinate->is_added) {
>> > > +                                               check_hotplug_bridge(slot, dev);
>> > > +                                               pcibios_resource_survey_bus(
>> > > +                                                       dev->subordinate);
>> >
>> > It's a shame that pcibios_resource_survey_bus() can't be called twice.
>> >  It would be nice if it were smart enough to notice on the second call
>> > that "oh, resources have already been assigned, so there's nothing
>> > more to be done."  Did you look to see whether that's feasible?
>>
>> I didn't but now that you mentioned I went and checked. I'm pretty sure we
>> can handle it there in the next revision and drop this change.
>
> With following patch that fixes pcibios_resource_survey_bus() Thunderbolt
> seems to be working just fine (and the quirk is gone).
>
> If it looks okay, I'll include it into the next iteration of the patches.

That looks great, thanks a lot for exploring this!

> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 94919e3..db6b1ab 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -210,6 +210,8 @@ static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
>                 r = &dev->resource[idx];
>                 if (!r->flags)
>                         continue;
> +               if (r->parent)  /* Already allocated */
> +                       continue;
>                 if (!r->start || pci_claim_resource(dev, idx) < 0) {
>                         /*
>                          * Something is wrong with the region.
> @@ -318,6 +320,8 @@ static void pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
>         r = &dev->resource[PCI_ROM_RESOURCE];
>         if (!r->flags || !r->start)
>                 return;
> +       if (r->parent) /* Already allocated */
> +               return;
>
>         if (pci_claim_resource(dev, PCI_ROM_RESOURCE) < 0) {
>                 r->end -= r->start;
