Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaCaRPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:15:25 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:52552 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaCaRPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <lsq.1396221815.13737205@decadent.org.uk>
References: <lsq.1396221814.369444335@decadent.org.uk> <lsq.1396221815.13737205@decadent.org.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 31 Mar 2014 11:15:01 -0600
Message-ID: <CAErSpo6KQNhh-4csydz7iZ+1WnX8LP+Hde8EN_oTwX=8bRAh2w@mail.gmail.com>
Subject: Re: [PATCH 3.2 118/200] PCI: Enable INTx if BIOS left them disabled
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Chris Cheng <chris.cheng@atrustcorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 5:23 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> 3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

No objection, but you need the followup patch as well:

3cdeb713dc66057b50682048c151eae07b186c42 PCI: Enable INTx in
pci_reenable_device() only when MSI/MSI-X not enabled

> ------------------
>
> From: Bjorn Helgaas <bhelgaas@google.com>
>
> commit 1f42db786b14a31bf807fc41ee5583a00c08fcb1 upstream.
>
> Some firmware leaves the Interrupt Disable bit set even if the device uses
> INTx interrupts.  Clear Interrupt Disable so we get those interrupts.
>
> Based on the report mentioned below, if the user selects the "EHCI only"
> option in the Intel Baytrail BIOS, the EHCI device is handed off to the OS
> with the PCI_COMMAND_INTX_DISABLE bit set.
>
> Link: http://lkml.kernel.org/r/20140114181721.GC12126@xanatos
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=70601
> Reported-by: Chris Cheng <chris.cheng@atrustcorp.com>
> Reported-and-tested-by: Jamie Chen <jamie.chen@intel.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/pci/pci.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1078,6 +1078,8 @@ EXPORT_SYMBOL_GPL(pci_load_and_free_save
>  static int do_pci_enable_device(struct pci_dev *dev, int bars)
>  {
>         int err;
> +       u16 cmd;
> +       u8 pin;
>
>         err = pci_set_power_state(dev, PCI_D0);
>         if (err < 0 && err != -EIO)
> @@ -1087,6 +1089,14 @@ static int do_pci_enable_device(struct p
>                 return err;
>         pci_fixup_device(pci_fixup_enable, dev);
>
> +       pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
> +       if (pin) {
> +               pci_read_config_word(dev, PCI_COMMAND, &cmd);
> +               if (cmd & PCI_COMMAND_INTX_DISABLE)
> +                       pci_write_config_word(dev, PCI_COMMAND,
> +                                             cmd & ~PCI_COMMAND_INTX_DISABLE);
> +       }
> +
>         return 0;
>  }
>
>
