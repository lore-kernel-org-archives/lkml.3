Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaBTOvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:51:36 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:50460 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaBTOvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:51:33 -0500
MIME-Version: 1.0
In-Reply-To: <20140220124400.GA8198@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-6-git-send-email-agordeev@redhat.com>
 <CAErSpo7xWe6n3Nk3Aatik4tfSHQLQehf3WELqD=q1oTmXYVVuw@mail.gmail.com> <20140220124400.GA8198@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Feb 2014 07:51:12 -0700
Message-ID: <CAErSpo7gNbRNAPjRqpvz85nS_fhVetf=6J+v7NdoVZ1eAGQBsA@mail.gmail.com>
Subject: Re: [PATCH] portdrv: Use pci_enable_msix_range() instead of pci_enable_msix()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 5:44 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Wed, Feb 19, 2014 at 03:09:41PM -0700, Bjorn Helgaas wrote:
>> On Wed, Feb 19, 2014 at 3:15 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
>> > As result of deprecation of MSI-X/MSI enablement functions
>> > pci_enable_msix() and pci_enable_msi_block() all drivers
>> > using these two interfaces need to be updated to use the
>> > new pci_enable_msi_range() and pci_enable_msix_range()
>> > interfaces.
>> >
>> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> > Cc: Bjorn Helgaas <bhelgaas@google.com>
>> > Cc: linux-pci@vger.kernel.org
>> > ---
>> >  drivers/pci/pcie/portdrv_core.c |   17 ++++++++++-------
>> >  1 files changed, 10 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
>> > index 986f8ea..4e46eca 100644
>> > --- a/drivers/pci/pcie/portdrv_core.c
>> > +++ b/drivers/pci/pcie/portdrv_core.c
>> > @@ -99,8 +99,9 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
>> >         for (i = 0; i < nr_entries; i++)
>> >                 msix_entries[i].entry = i;
>> >
>> > -       status = pci_enable_msix(dev, msix_entries, nr_entries);
>> > -       if (status)
>> > +       status = pci_enable_msix_range(dev,
>> > +                                      msix_entries, nr_entries, nr_entries);
>>
>> This is a place we could use pci_enable_msix_exact(), isn't it?  (Also below.)
>
> Yes, absolutely.
>
> I posted it (and other updates) as is, since I understood
> pci_enable_msix_exact() is not going to make it into 3.14. Was I wrong here?

Ooh, sorry, I do plan to merge pci_enable_msix_exact() and some of the
other infrastructure patches for v3.14.  They've been in my for-linus
branch for a week or so, and I plan to ask Linus to pull them today.
Sorry I didn't make that more clear.

> I think more time in testing with either pci_enable_msix_range() or
> pci_enable_msix_exact() is good. And a follow-up switch from
> pci_enable_msix_range() to pci_enable_msix_exact() should be easy eigher.
>
> What do you think is the best course of action now?

You should be able to post patches that use pci_enable_msix_exact();
that's been in -next for a while now.  Maybe include a cover note
saying what they depend on.

Bjorn

>> > +       if (status < 0)
>> >                 goto Exit;
>> >
>> >         for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++)
>> > @@ -159,21 +160,23 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
>> >                 idx[PCIE_PORT_SERVICE_AER_SHIFT] = i;
>> >         }
>> >
>> > +       status = 0;
>> > +
>> >         /*
>> >          * If nvec is equal to the allocated number of entries, we can just use
>> >          * what we have.  Otherwise, the port has some extra entries not for the
>> >          * services we know and we need to work around that.
>> >          */
>> > -       if (nvec == nr_entries) {
>> > -               status = 0;
>> > -       } else {
>> > +       if (nvec != nr_entries) {
>> >                 /* Drop the temporary MSI-X setup */
>> >                 pci_disable_msix(dev);
>> >
>> >                 /* Now allocate the MSI-X vectors for real */
>> > -               status = pci_enable_msix(dev, msix_entries, nvec);
>> > -               if (status)
>> > +               nvec = pci_enable_msix_range(dev, msix_entries, nvec, nvec);
>> > +               if (nvec < 0) {
>> > +                       status = nvec;
>> >                         goto Exit;
>> > +               }
>> >         }
>> >
>> >         for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++)
>> > --
>> > 1.7.7.6
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
