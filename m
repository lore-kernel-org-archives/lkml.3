Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaCYSwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:52:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56441 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaCYSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:52:30 -0400
Message-ID: <1395773543.2770.93.camel@fourier>
Subject: Re: [PATCH 3.8 23/81] PCI: Enable INTx if BIOS left them disabled
From: Kamal Mostafa <kamal@canonical.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kernel-team@lists.ubuntu.com,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Tue, 25 Mar 2014 11:52:23 -0700
In-Reply-To: <CAErSpo6iSiYn0pcv86c3srAXHznYf_Xdqa+yJnhz_BezgXmeig@mail.gmail.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
	 <1395767794-5012-24-git-send-email-kamal@canonical.com>
	 <CAErSpo6iSiYn0pcv86c3srAXHznYf_Xdqa+yJnhz_BezgXmeig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 12:34 -0600, Bjorn Helgaas wrote:
> On Tue, Mar 25, 2014 at 11:15 AM, Kamal Mostafa <kamal@canonical.com> wrote:
> > 3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.
> 
> If you pick up this one, you need the follow-up fix as well:
> 
> 866d54177b4e671cd52bed1fb487d140d7b691f5 PCI: Enable INTx in
> pci_reenable_device() only when MSI/MSI-X not enabled
> 

Thanks very much, Bjorn.  I'll pick up that one for 3.8.13.20 also.

For reference, the upstream commit sha of that is actually:
3cdeb713dc66057b50682048c151eae07b186c42 PCI: Enable INTx in
pci_reenable_device() only when MSI/MSI-X not enabled

 -Kamal



> > From: Bjorn Helgaas <bhelgaas@google.com>
> >
> > commit 1f42db786b14a31bf807fc41ee5583a00c08fcb1 upstream.
> >
> > Some firmware leaves the Interrupt Disable bit set even if the device uses
> > INTx interrupts.  Clear Interrupt Disable so we get those interrupts.
> >
> > Based on the report mentioned below, if the user selects the "EHCI only"
> > option in the Intel Baytrail BIOS, the EHCI device is handed off to the OS
> > with the PCI_COMMAND_INTX_DISABLE bit set.
> >
> > Link: http://lkml.kernel.org/r/20140114181721.GC12126@xanatos
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=70601
> > Reported-by: Chris Cheng <chris.cheng@atrustcorp.com>
> > Reported-and-tested-by: Jamie Chen <jamie.chen@intel.com>
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > ---
> >  drivers/pci/pci.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index d1b4e00..4235728 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -1126,6 +1126,8 @@ EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
> >  static int do_pci_enable_device(struct pci_dev *dev, int bars)
> >  {
> >         int err;
> > +       u16 cmd;
> > +       u8 pin;
> >
> >         err = pci_set_power_state(dev, PCI_D0);
> >         if (err < 0 && err != -EIO)
> > @@ -1135,6 +1137,14 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
> >                 return err;
> >         pci_fixup_device(pci_fixup_enable, dev);
> >
> > +       pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
> > +       if (pin) {
> > +               pci_read_config_word(dev, PCI_COMMAND, &cmd);
> > +               if (cmd & PCI_COMMAND_INTX_DISABLE)
> > +                       pci_write_config_word(dev, PCI_COMMAND,
> > +                                             cmd & ~PCI_COMMAND_INTX_DISABLE);
> > +       }
> > +
> >         return 0;
> >  }
> >
> > --
> > 1.8.3.2
> >
> 


