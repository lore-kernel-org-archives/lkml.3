Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbbALQtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:49:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbALQtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:49:11 -0500
Message-ID: <1421081344.6130.54.camel@redhat.com>
Subject: Re: [PATCH 4/4] PCI: quirk Atheros AR93xx to avoid bus reset
From: Alex Williamson <alex.williamson@redhat.com>
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2015 09:49:04 -0700
In-Reply-To: <54B3E653.8020900@maya.org>
References: <20141121180322.26669.65689.stgit@gimli.home>
		 <20141121182427.26669.82417.stgit@gimli.home>
		 <20150108160733.GA6575@google.com> <1420745423.25367.77.camel@redhat.com>
	 <54B3E653.8020900@maya.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 16:20 +0100, Andreas Hartmann wrote:
> Alex Williamson wrote:
> > On Thu, 2015-01-08 at 09:07 -0700, Bjorn Helgaas wrote:
> >> On Fri, Nov 21, 2014 at 11:24:27AM -0700, Alex Williamson wrote:
> >>> Reports against the TL-WDN4800 card indicate that PCI bus reset of
> >>> this Atheros device cause system lock-ups and resets.  I've also
> >>> been able to confirm this behavior on multiple systems.  The device
> >>> never returns from reset and attempts to access config space of the
> >>> device after reset result in hangs.  Blacklist bus reset for the
> >>> device to avoid this issue.
> >>>
> >>> Reported-by: Andreas Hartmann <andihartmann@freenet.de>
> >>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >>> Tested-by: Andreas Hartmann <andihartmann@freenet.de>
> >>
> >> If I understand correctly, these two (patches 3 & 4) fix a v3.14 regression
> >> caused by 425c1b223dac ("PCI: Add Virtual Channel to save/restore support").
> >>
> >> If so, these should go to for-linus for v3.19.  What about patches 1 & 2?
> >> Do they fix a regression?  Is there a pointer to a bugzilla or problem
> >> report about that issue?
> >>
> >> I don't understand the connection between 425c1b223dac and
> >> PCI_DEV_FLAGS_NO_BUS_RESET, because 425c1b223dac doesn't seem to do any
> >> resets.  Is that the wrong commit, or can you outline the connection for
> >> me?
> > 
> > TBH, I don't have a lot of faith in associating this to 425c1b223dac,
> > I'm not sure how Andreas' bisect landed there. 
> 
> Because removing this patch made it working again :-)
> 
> And too:
> http://thread.gmane.org/gmane.linux.kernel.pci/35170/focus=35984
> 
> Kernel 2.10. and 2.12. and 2.13. did work fine for me. 2.14 is the first
> kernel, which hangs the machine at startup of the VM. The userland
> (qemu) didn't change in between.

s/2\./3\./

Ok, so what about VC save/restore (425c1b223dac) is the problem then?
When we tried to determine that, you found that if we continue from the
top of the save loop, everything works (ie. no VC state saved), but if
you continue after the variable declaration of the same loop (ie. still
no VC state saved), it breaks:

http://www.spinics.net/lists/linux-pci/msg36166.html

So, please forgive me if I don't have a whole lot of faith that
425c1b223dac is involved.

We also both independently determined that this particular device never
recovers from a PCI bus reset, even when done from userspace with setpci
and absolutely no save/restore wrappers.  Config space on the device is
never accessible after the reset.  Therefore, how could any sort of bus
reset with save/restore ever work for this device?

> Therefore: from my point of view, it is a regression, because things
> have been working < 2.14.
> 
> Besides that: It is undoubted, that there is a problem with resetting
> this card. But the difference between >= 3.14 and < 3.14 is, that < 3.14
> has been working nevertheless. The patch
> 425c1b223dac456d00a61fd6b451b6d1cf00d065 obviously changed something
> which I can't say and I don't know off. Therefore, the quirk-patch is
> definitely required, because things work completely fine again w/ this
> patch.
> 
> "Working" means for me here: I was able to start (and use) the VM w/o
> crashing the machine and this isn't possible w/ unpatched 2.14+ any
> more. Yes, w/ 2.12, I wasn't able to restart the VM (it then crashed the
> machine), but w/ 2.10 even this was possible.

What?!  So v3.12 still had a machine crash when assigning this device.
The vfio hot reset interface was added in v3.12, so v3.10 didn't have
any way to do a reset other than what pci_reset_function() decided to
do.  That all seems to associate the machine crash to the ability to do
a bus reset on the device.  I'm not sure why the behavior changed
between v3.14 and v3.12 (maybe the try-reset addition), but there's some
sort of pre-existing issue before we even got to 425c1b223dac.

I'm perfectly happy tagging this for stable, but it seems like a
hardware bug exposed by allowing userspace the ability to select a bus
reset.  Whether or not that's a kernel regression isn't exactly clear to
me ("new functionality exposes broken hardware, news at 11").  Thanks,

Alex

> > IME, this device cannot,
> > and has never been able to handle a bus reset.  A simple setpci
> > experiment on the commandline can confirm this.  What I think happened
> > is that with the PCI bus reset infrastructure we added, we switched QEMU
> > to prefer PCI bus resets over things like PM D3hot->D0 resets.  So it's
> > just more prolific use of bus resets by userspace.
> > 
> > There's also no regression in 1 & 2, PM reset has never done anything
> > useful on those devices.  Thanks,
> > 
> > Alex
> > 
> >>> ---
> >>>
> >>>  drivers/pci/quirks.c |   14 ++++++++++++++
> >>>  1 file changed, 14 insertions(+)
> >>>
> >>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> >>> index 561e10d..ebbd5b4 100644
> >>> --- a/drivers/pci/quirks.c
> >>> +++ b/drivers/pci/quirks.c
> >>> @@ -3029,6 +3029,20 @@ static void quirk_no_pm_reset(struct pci_dev *dev)
> >>>  DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> >>>  			       PCI_CLASS_DISPLAY_VGA, 8, quirk_no_pm_reset);
> >>>  
> >>> +static void quirk_no_bus_reset(struct pci_dev *dev)
> >>> +{
> >>> +	dev->dev_flags |= PCI_DEV_FLAGS_NO_BUS_RESET;
> >>> +}
> >>> +
> >>> +/*
> >>> + * Atheros AR93xx chips do not behave after a bus reset.  The device will
> >>> + * throw a Link Down error on AER capable system and regardless of AER,
> >>> + * config space of the device is never accessible again and typically
> >>> + * causes the system to hang or reset when access is attempted.
> >>> + * http://www.spinics.net/lists/linux-pci/msg34797.html
> >>> + */
> >>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030, quirk_no_bus_reset);
> >>> +
> >>>  #ifdef CONFIG_ACPI
> >>>  /*
> >>>   * Apple: Shutdown Cactus Ridge Thunderbolt controller.
> >>>
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 



