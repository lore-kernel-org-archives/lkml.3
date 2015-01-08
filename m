Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbbAHXLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 18:11:12 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:38961 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbAHXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 18:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <1420745423.25367.77.camel@redhat.com>
References: <20141121180322.26669.65689.stgit@gimli.home> <20141121182427.26669.82417.stgit@gimli.home>
 <20150108160733.GA6575@google.com> <1420745423.25367.77.camel@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 8 Jan 2015 17:10:48 -0600
Message-ID: <CAErSpo7E3-qEwHeeMvKvGmUzPQ6eP7=g0mqUZuBBrdcu_yN95w@mail.gmail.com>
Subject: Re: [PATCH 4/4] PCI: quirk Atheros AR93xx to avoid bus reset
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 1:30 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Thu, 2015-01-08 at 09:07 -0700, Bjorn Helgaas wrote:
>> On Fri, Nov 21, 2014 at 11:24:27AM -0700, Alex Williamson wrote:
>> > Reports against the TL-WDN4800 card indicate that PCI bus reset of
>> > this Atheros device cause system lock-ups and resets.  I've also
>> > been able to confirm this behavior on multiple systems.  The device
>> > never returns from reset and attempts to access config space of the
>> > device after reset result in hangs.  Blacklist bus reset for the
>> > device to avoid this issue.
>> >
>> > Reported-by: Andreas Hartmann <andihartmann@freenet.de>
>> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> > Tested-by: Andreas Hartmann <andihartmann@freenet.de>
>>
>> If I understand correctly, these two (patches 3 & 4) fix a v3.14 regression
>> caused by 425c1b223dac ("PCI: Add Virtual Channel to save/restore support").
>>
>> If so, these should go to for-linus for v3.19.  What about patches 1 & 2?
>> Do they fix a regression?  Is there a pointer to a bugzilla or problem
>> report about that issue?
>>
>> I don't understand the connection between 425c1b223dac and
>> PCI_DEV_FLAGS_NO_BUS_RESET, because 425c1b223dac doesn't seem to do any
>> resets.  Is that the wrong commit, or can you outline the connection for
>> me?
>
> TBH, I don't have a lot of faith in associating this to 425c1b223dac,
> I'm not sure how Andreas' bisect landed there.  IME, this device cannot,
> and has never been able to handle a bus reset.  A simple setpci
> experiment on the commandline can confirm this.  What I think happened
> is that with the PCI bus reset infrastructure we added, we switched QEMU
> to prefer PCI bus resets over things like PM D3hot->D0 resets.  So it's
> just more prolific use of bus resets by userspace.

Maybe it's not 425c1b223dac, but it seems pretty clear that it really
is a regression from the user point of view.  I'm sure Andreas was
using the same user-space for v3.13 and v3.14.

Testing 425c1b223dac^ (the predecessor of 425c1b223dac) and
425c1b223dac would confirm the bisect results.

If it really turns out that 425c1b223dac^ works and 425c1b223dac
fails, maybe we could learn something interesting by adding debug
output to the various reset flavors and comparing the output?

> There's also no regression in 1 & 2, PM reset has never done anything
> useful on those devices.  Thanks,

Since 1 & 2 don't fix a regression, I think what I should do is apply
3 & 4 to for-linus for v3.19, then apply 1 & 2 on top as v3.20
material.

Bjorn

>> > ---
>> >
>> >  drivers/pci/quirks.c |   14 ++++++++++++++
>> >  1 file changed, 14 insertions(+)
>> >
>> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> > index 561e10d..ebbd5b4 100644
>> > --- a/drivers/pci/quirks.c
>> > +++ b/drivers/pci/quirks.c
>> > @@ -3029,6 +3029,20 @@ static void quirk_no_pm_reset(struct pci_dev *dev)
>> >  DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
>> >                            PCI_CLASS_DISPLAY_VGA, 8, quirk_no_pm_reset);
>> >
>> > +static void quirk_no_bus_reset(struct pci_dev *dev)
>> > +{
>> > +   dev->dev_flags |= PCI_DEV_FLAGS_NO_BUS_RESET;
>> > +}
>> > +
>> > +/*
>> > + * Atheros AR93xx chips do not behave after a bus reset.  The device will
>> > + * throw a Link Down error on AER capable system and regardless of AER,
>> > + * config space of the device is never accessible again and typically
>> > + * causes the system to hang or reset when access is attempted.
>> > + * http://www.spinics.net/lists/linux-pci/msg34797.html
>> > + */
>> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030, quirk_no_bus_reset);
>> > +
>> >  #ifdef CONFIG_ACPI
>> >  /*
>> >   * Apple: Shutdown Cactus Ridge Thunderbolt controller.
>> >
>
>
>
