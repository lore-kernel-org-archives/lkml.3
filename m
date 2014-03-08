Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaCHNuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 08:50:55 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39727 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaCHNuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 08:50:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140308010612.589034591@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org> <20140308010612.589034591@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 8 Mar 2014 06:50:30 -0700
Message-ID: <CAErSpo6r0P=z0sT-+qKvjZOpa7aHv3E94-t7mvXzSps96fWf9Q@mail.gmail.com>
Subject: Re: [PATCH 3.4 30/99] PCI: Enable INTx if BIOS left them disabled
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Chris Cheng <chris.cheng@atrustcorp.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andreas Noever <andreas.noever@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Andreas]

On Fri, Mar 7, 2014 at 6:07 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.

Let's hold off on this for a bit.  Andreas found that this patch
breaks pciehp, and we haven't figured out the best fix yet.

http://lkml.kernel.org/r/CAMxnaaXd9-VbxSYa9q1YVT+fwfDFYKGG2Hq-1jkc-awLX-HwtQ@mail.gmail.com
https://bugzilla.kernel.org/show_bug.cgi?id=71691

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
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/pci/pci.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1133,6 +1133,8 @@ EXPORT_SYMBOL_GPL(pci_load_and_free_save
>  static int do_pci_enable_device(struct pci_dev *dev, int bars)
>  {
>         int err;
> +       u16 cmd;
> +       u8 pin;
>
>         err = pci_set_power_state(dev, PCI_D0);
>         if (err < 0 && err != -EIO)
> @@ -1142,6 +1144,14 @@ static int do_pci_enable_device(struct p
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
>
