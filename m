Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbaGUSYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:24:42 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58566 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341AbaGUSYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:24:40 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1407181034170.1642@denkbrett>
References: <alpine.LFD.2.11.1407091237030.1590@denkbrett> <20140716211052.GC14366@google.com>
 <1405612139.30550.13.camel@oc7383187364.ibm.com> <alpine.LFD.2.11.1407181034170.1642@denkbrett>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 21 Jul 2014 12:24:19 -0600
Message-ID: <CAErSpo57gyyiEAdsqxTwu5EWggxohxXv0PpEtYJfUFJAfp2GHg@mail.gmail.com>
Subject: Re: [PATCH] misc/GenWQE: fix pci_enable_msi usage
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 2:46 AM, Sebastian Ott
<sebott@linux.vnet.ibm.com> wrote:
> On Thu, 17 Jul 2014, Frank Haverkamp wrote:
>> Hi Bjorn and Sebastian,
>>
>> Am Mittwoch, den 16.07.2014, 15:10 -0600 schrieb Bjorn Helgaas:
>> > [+cc linux-pci]
>> >
>> > On Wed, Jul 09, 2014 at 12:46:39PM +0200, Sebastian Ott wrote:
>> > > GenWQE used to call pci_enable_msi_block to allocate a desired number
>> > > of MSI's. If that was not possible pci_enable_msi_block returned with a
>> > > smaller number which might be possible to allocate. GenWQE then called
>> > > pci_enable_msi_block with that number.
>> > >
>> > > Since commit a30d0108b
>> > > "GenWQE: Use pci_enable_msi_exact() instead of pci_enable_msi_block()"
>> > > pci_enable_msi_exact is used which fails if the desired number of MSI's
>> > > was not possible to allocate. Change GenWQE to use pci_enable_msi_range
>> > > to restore the old behavior.
>> > >
>> > > Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
>> >
>> > Since this fixes a30d0108b09a, which we merged via my tree in v3.16-rc1, I
>> > applied this with Alexander and Frank's acks to for-linus for v3.16,
>> > thanks!
>> >
>> > > ---
>> > >  drivers/misc/genwqe/card_ddcb.c  |  4 +---
>> > >  drivers/misc/genwqe/card_utils.c | 10 ++++++----
>> > >  2 files changed, 7 insertions(+), 7 deletions(-)
>> > >
>> > > diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
>> > > index c8046db..f66d43d 100644
>> > > --- a/drivers/misc/genwqe/card_ddcb.c
>> > > +++ b/drivers/misc/genwqe/card_ddcb.c
>> > > @@ -1237,9 +1237,7 @@ int genwqe_setup_service_layer(struct genwqe_dev *cd)
>> > >   }
>> > >
>> > >   rc = genwqe_set_interrupt_capability(cd, GENWQE_MSI_IRQS);
>> > > - if (rc > 0)
>> > > -         rc = genwqe_set_interrupt_capability(cd, rc);
>> > > - if (rc != 0) {
>> > > + if (rc) {
>> > >           rc = -ENODEV;
>> > >           goto stop_kthread;
>> > >   }
>> > > diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
>> > > index 62cc6bb..6abc437 100644
>> > > --- a/drivers/misc/genwqe/card_utils.c
>> > > +++ b/drivers/misc/genwqe/card_utils.c
>> > > @@ -718,10 +718,12 @@ int genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count)
>> > >   int rc;
>> > >   struct pci_dev *pci_dev = cd->pci_dev;
>> > >
>> > > - rc = pci_enable_msi_exact(pci_dev, count);
>> > > - if (rc == 0)
>> > > -         cd->flags |= GENWQE_FLAG_MSI_ENABLED;
>> > > - return rc;
>> > > + rc = pci_enable_msi_range(pci_dev, 1, count);
>> > > + if (rc < 0)
>> > > +         return rc;
>> > > +
>> > > + cd->flags |= GENWQE_FLAG_MSI_ENABLED;
>> > > + return 0;
>> > >  }
>>
>> The original code tried to register for 4 interrupts. On my system the
>> following scenario was executed:
>>
>> We tried to register for 4 MSI interrupts, which was the original plan
>> of interrupts for the card. Linux returned that it could not do that and
>> that just 1 would work. We tried to register for 1 MSI interrupt and it
>> worked. GENWQE_MSI_IRQS is still 4. That is how my original version
>> looked like:
>
> I changed the code that way, because I was under the impression
> GENWQE_MSI_IRQS was set to 4 for a reason (I have no knowledge of the
> internal workings of this driver). A lot of archs don't support more than
> one MSI anyway - but are you saying that the genwqe card/driver itself
> doesn't support more than one MSI?
>
> Regards,
> Sebastian
>>
>>         rc = genwqe_set_interrupt_capability(cd, GENWQE_MSI_IRQS);
>>         if (rc > 0)
>>                 rc = genwqe_set_interrupt_capability(cd, rc);
>>         if (rc != 0) {
>>                 rc = -ENODEV;
>>                 goto stop_kthread;
>>         }
>>
>> So genwqe_set_interrupt_capability() was indeed called two times.
>> Calling it with 4 returned with rc=1 and no interrupts enabled. So
>> calling it a 2nd time with rc=1 was leading to the proper enablement.
>>
>> I think the simplest way is to set GENWQE_MSI_IRQS to 1. The rest of the
>> code at least assumes just one interrupt, because 4 never worked.
>>
>> Regards
>>
>> Frank

OK, I dropped this patch from for-linus until this gets sorted out.
If you need any changes before v3.16, they'll have to be merged via
some other route, because I'll be on vacation until v3.16 releases.

Bjorn
