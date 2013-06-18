Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761Ab3FRWLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:11:01 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38322 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab3FRWK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:10:59 -0400
MIME-Version: 1.0
In-Reply-To: <1371580735.22681.216.camel@ul30vt.home>
References: <20130607162732.7733.17758.stgit@bling.home> <20130607163441.7733.23221.stgit@bling.home>
 <20130618170926.GA9203@google.com> <1371580735.22681.216.camel@ul30vt.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Jun 2013 16:10:38 -0600
Message-ID: <CAErSpo75R26gqO=muqrR28igNkMay4NNRW-VJWPt3xQCqp1YBQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] pci: Fix flaw in pci_acs_enabled()
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:38 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Tue, 2013-06-18 at 11:09 -0600, Bjorn Helgaas wrote:
>> On Fri, Jun 07, 2013 at 10:34:41AM -0600, Alex Williamson wrote:
>> > Downstream ports support for all ACS flags supercedes multifunction
>> > exclusion of some flags.  The PCIe spec also fully specifies which
>> > PCIe types are subject to the multifunction rules and excludes event
>> > collectors and PCIe-to-PCI bridges entirely.  Document each rule to
>> > the section of the PCIe spec.
>>
>> What's the flaw, exactly?  Does this fix a user-visible issue?  Should
>> it be backported to any stable releases?  It'd be nice to have an
>> example or two of devices where we return the wrong thing today.
>>
>> Oh, I think I see: the original code filters out flags for
>> multi-function downstream ports, and your new code does not.
>
> Right, if you have a multifunction root port and you want to check a
> feature that applies to downstream ports, but not multifunction devices,
> we were previously filtering those out.
>
>> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> > ---
>> >  drivers/pci/pci.c |   59 ++++++++++++++++++++++++++++++++++++++++-------------
>> >  1 file changed, 45 insertions(+), 14 deletions(-)
>> >
>> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> > index b099e00..457ae51 100644
>> > --- a/drivers/pci/pci.c
>> > +++ b/drivers/pci/pci.c
>> > @@ -2354,6 +2354,19 @@ void pci_enable_acs(struct pci_dev *dev)
>> >     pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
>> >  }
>> >
>> > +static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
>> > +{
>> > +   int pos;
>> > +   u16 ctrl;
>> > +
>> > +   pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
>> > +   if (!pos)
>> > +           return false;
>> > +
>> > +   pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
>> > +   return (ctrl & acs_flags) == acs_flags;
>> > +}
>> > +
>> >  /**
>> >   * pci_acs_enabled - test ACS against required flags for a given device
>> >   * @pdev: device to test
>> > @@ -2364,8 +2377,7 @@ void pci_enable_acs(struct pci_dev *dev)
>> >   */
>> >  bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
>>
>> I know you didn't change the *name* of this function, but I think it
>> would be easier to follow if you did change the name to something more
>> descriptive, e.g., something to do with the actual property you're
>> interested in, which has to do with routing peer-to-peer DMA.
>>
>> That property makes sense even for the excluded devices, while the
>> idea of an ACS capability that doesn't even exist is implicitly
>> enabled, really doesn't.
>
> I think we also don't want to put the complexity at the caller for
> understanding what capabilities are applicable to a given device.  It's
> also convenient to use the set of ACS flags.  Given that, the current
> naming came about.  It's a little awkward, but it's easy to use.
> Suggestions for a better name?

100% agreed the caller shouldn't have to worry about different device
types.  I was thinking something like "pci_enforces_peer_isolation()"
or "pci_peer_dma_routed_upstream()".  Or maybe it should be
"pci_dev_...()".

>> >  {
>> > -   int pos, ret;
>> > -   u16 ctrl;
>> > +   int ret;
>> >
>> >     ret = pci_dev_specific_acs_enabled(pdev, acs_flags);
>> >     if (ret >= 0)
>> > @@ -2374,23 +2386,42 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
>> >     if (!pci_is_pcie(pdev))
>> >             return false;
>> >
>> > -   /* Filter out flags not applicable to multifunction */
>> > -   if (pdev->multifunction)
>> > +   switch (pci_pcie_type(pdev)) {
>> > +   /*
>> > +    * PCIe 3.0, 6.12.1 excludes ACS on these devices.  "Not applicable"
>> > +    */
>> > +   case PCI_EXP_TYPE_PCI_BRIDGE:
>> > +   case PCI_EXP_TYPE_RC_EC:
>> > +           break;
>>
>> Why not just return "true" immediately here, or even better, just omit
>> the case altogether, since it doesn't change the behavior at all?
>
> It could certainly return true, I debated that for a while and decided
> to break just to reduce the number of exit points.

That's interesting; I know lots of people advocate a single exit
point, but for functions like this where there's no cleanup and we're
essentially doing a "goto" to a "return <constant>", it seems harder
to read because I have to look down at the bottom to see how this case
is resolved.  Oh well, no point in arguing about *that* :)

> Omitting the case
> means that anyone who looks at this in the future has to figure out why
> those pcie types aren't explicitly listed.
>
>> > +   /*
>> > +    * PCIe 3.0, 6.12.1.1 specifies full ACS capabilities on downstream
>> > +    * ports, regardless of them being multifunction devices.
>> > +    */
>> > +   case PCI_EXP_TYPE_DOWNSTREAM:
>> > +   case PCI_EXP_TYPE_ROOT_PORT:
>> > +           return pci_acs_flags_enabled(pdev, acs_flags);
>> > +   /*
>> > +    * PCIe 3.0, 6.12.1.2 specifies unimplemented ACS capabilities on
>> > +    * multifunction devices.  6.12 footnote identifies specifically
>> > +    * which devices types this applies to.
>> > +    */
>> > +   case PCI_EXP_TYPE_ENDPOINT:
>> > +   case PCI_EXP_TYPE_UPSTREAM:
>> > +   case PCI_EXP_TYPE_LEG_END:
>> > +   case PCI_EXP_TYPE_RC_END:
>> > +           if (!pdev->multifunction)
>> > +                   break;
>>
>> And here.
>
> Same
>
>> > +
>> >             acs_flags &= (PCI_ACS_RR | PCI_ACS_CR |
>> >                           PCI_ACS_EC | PCI_ACS_DT);
>> >
>> > -   if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM ||
>> > -       pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT ||
>> > -       pdev->multifunction) {
>> > -           pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
>> > -           if (!pos)
>> > -                   return false;
>> > -
>> > -           pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
>> > -           if ((ctrl & acs_flags) != acs_flags)
>> > -                   return false;
>> > +           return pci_acs_flags_enabled(pdev, acs_flags);
>> >     }
>> >
>> > +   /*
>> > +    * PCIe 3.0, 6.12.1.3 specifies no ACS capabilties are applicable
>> > +    * to single function devices with the exception of downstream ports.
>> > +    */
>> >     return true;
>> >  }
>> >
>> >
>>
>> I actually liked the original code organization, because it's closer
>> to expressing the idea of "here are the control points where hardware
>> can make choices about routing peer-to-peer DMA and here's the knob
>> (ACS) that constrains those choices."
>>
>> Maybe something like (pidgin C):
>>
>>     if (PCI_EXP_TYPE_DOWNSTREAM || PCI_EXP_TYPE_ROOT_PORT)
>>       return pci_acs_flags_enabled(pdev, acs_flags);
>>
>>     if (!pdev->multifunction)
>>       return true;
>>
>>     acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | ...);
>>     return pci_acs_flags_enabled(pdev, acs_flags);
>
> Ok.  I re-organized it because I got tired of re-reading the spec to
> make sure that a given type of device was handled correctly.  Note that
> the above simplification incorrectly handles multifunction bridges or EC
> devices.

Hmm...  What *is* the correct behavior for a bridge?  You return
"true," i.e., you're saying that a PCIe-to-PCI bridge will always
route peer-to-peer transactions from PCI devices upstream to its PCIe
link.  But that seems wrong: a PCI DMA transaction can target a peer
on the same PCI bus, and it's not even possible for the bridge to
validate the transaction or forward it upstream.

I suspect the "ACS is never applicable to a PCI Express to PCI Bridge
Function" statement in 6.12.1 just means "it's impossible for ACS to
isolate the devices below the bridge from each other, so it would be
misleading to implement the capability."

I have no idea or speculation about why the spec calls out Event
Collectors.  They aren't bridges, so I suppose it must be related to
multi-function devices?

> I can do something like you suggest, but being explicit was
> actually a goal in fixing this bug and avoiding future bugs.  Thanks,

Is there a bugzilla you can reference here?  Or can we at least turn
the "multi-function downstream port flag filtering" thing into a
user-visible effect?  I can see what it fixes at the microscopic
level, but I really don't know the implications of it.

Bjorn
