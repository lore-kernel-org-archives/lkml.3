Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaCHBFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:05:03 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47138 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCHBFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:05:00 -0500
Date: Fri, 7 Mar 2014 18:04:56 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [Bug] PCI: Enable INTx if BIOS left them disabled - triggers
 during rescan
Message-ID: <20140308010456.GA30660@google.com>
References: <CAMxnaaXd9-VbxSYa9q1YVT+fwfDFYKGG2Hq-1jkc-awLX-HwtQ@mail.gmail.com>
 <CAErSpo5fkaFNq_qTZ+gTDMV554f4diOXQ7_4bsHqj06iAGTpHg@mail.gmail.com>
 <CAE9FiQVNFqTw+92qy8zcwG1haiSZzU+KE3oh4YnjNc_aE6KUnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVNFqTw+92qy8zcwG1haiSZzU+KE3oh4YnjNc_aE6KUnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael]

On Fri, Mar 07, 2014 at 11:39:48AM -0800, Yinghai Lu wrote:
> On Fri, Mar 7, 2014 at 8:45 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >
> > I opened a bugzilla report at https://bugzilla.kernel.org/show_bug.cgi?id=71691
> >
> > It seems like clearing DisINTx has some effect on MSI.  I don't see
> > anything in the spec that would suggest this (I'm looking at the PCIe
> > r3.0 spec, sec 7.5.1.1).
> >
> > Can somebody point out a connection between DisINTx and MSI?  If not,
> > maybe we'll need some sort of quirk to deal with this.
> 
> I had different impression: if you disable INTx in some chipset, MSI will not
> work anymore.
> 
> so we have
> 
> static void pci_intx_for_msi(struct pci_dev *dev, int enable)
> {
>         if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
>                 pci_intx(dev, enable);
> }
> 
> and have quirks for ati and broadcom chip to set that FLAG.

Setting INTX_DISABLE on some chipsets seems to disable MSI, and that
behavior seems to be a hardware defect (see ba698ad4b7e4 "PCI: Add
quirk for devices which disable MSI when INTX_DISABLE is set.")

Andreas has a device where *clearing* INTX_DISABLE seems to disable
MSI.  Do you think that's also a hardware defect?  If it's not a
defect, is there something in the spec that explains why that happens?

> regarding the regression: i would suggest move out
> do_pci_enable_intx() from re-enable path.

Today we have this:

  pcie_portdrv_probe
    pci_enable_device		# clears INTX_DISABLE
    pci_enable_msi		# sets INTX_DISABLE

  pciehp_configure_device
    pci_reenable_device		# clears INTX_DISABLE again

This is clearly not the intent; we set INTX_DISABLE when MSI was
enabled, then we clear it again later even though MSI is still
enabled.  Maybe we should just leave INTX_DISABLE alone if
(dev->msi_enabled || dev->msix_enabled).

pci_reenable_device() is also used in the device resume path.  I don't
know what should happen there.

But I'm curious about why we set INTX_DISABLE when enabling MSI/MSI-X
in the first place.  Per the PCI 3.0 spec, sec 6.8.3.3:

  While enabled for MSI or MSI-X operation, a function is prohibited
  from using its INTx# pin (if implemented) to request service (MSI,
  MSI-X, and INTx# are mutually exclusive).

This suggests that we might not need to touch INTX_DISABLE when we're
enabling MSI/MSI-X.  I looked at these commits related to it:

  ba698ad4b7e4 PCI: Add quirk for devices which disable MSI when INTX_DISABLE is set.
  b1cbf4e4dddd msi: fix up the msi enable/disable logic
  1769b46a3ed9 PCI MSI: always toggle legacy-INTx-enable bit upon MSI entry/exit
  986162d3239a ia32 Message Signalled Interrupt support

and none of them mentions a problem that requires us to set
INTX_DISABLE.  It's possible that we're causing ourselves trouble by
being overly defensive.  I wonder what would happen if we stopped
fiddling with it in the MSI/MSI-X paths, e.g., something like this
(just as an experiment, of course):

  diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
  index 7a0fec6ce571..9ef7bd608add 100644
  --- a/drivers/pci/msi.c
  +++ b/drivers/pci/msi.c
  @@ -442,8 +442,6 @@ static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
   
   static void pci_intx_for_msi(struct pci_dev *dev, int enable)
   {
  -	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
  -		pci_intx(dev, enable);
   }
   
   static void __pci_restore_msi_state(struct pci_dev *dev)

If we did that, INTX_DISABLE would be cleared by the first
pci_enable_device() and pci_reenable_device() wouldn't do anything,
leaving it cleared.  The resulting state (cleared) would be the same,
but the transitions would be gone, and maybe those are important.

The thing I don't like about the patch below is that it's magical: the
code doesn't have any obvious connection with the problem.  How would
one deduce that this is necessary, or explain why it's necessary?  A
changelog like "this makes things work" is not really very useful.  If
we make a change like this, it needs to be connected with MSI/MSI-X
somehow so a reader can figure out why we twiddle INTX_DISABLE in the
enable path but not the reenable path.

Bjorn

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 5a24cb3..92718c9 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1190,11 +1190,22 @@ int __weak pcibios_enable_device(struct
> pci_dev *dev, int bars)
>      return pci_enable_resources(dev, bars);
>  }
> 
> +static void do_pci_enable_intx(struct pci_dev *dev)
> +{
> +    u8 pin;
> +    pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
> +    if (pin) {
> +        pci_read_config_word(dev, PCI_COMMAND, &cmd);
> +        if (cmd & PCI_COMMAND_INTX_DISABLE)
> +            pci_write_config_word(dev, PCI_COMMAND,
> +                          cmd & ~PCI_COMMAND_INTX_DISABLE);
> +    }
> +}
> +
>  static int do_pci_enable_device(struct pci_dev *dev, int bars)
>  {
>      int err;
>      u16 cmd;
> -    u8 pin;
> 
>      err = pci_set_power_state(dev, PCI_D0);
>      if (err < 0 && err != -EIO)
> @@ -1204,14 +1215,6 @@ static int do_pci_enable_device(struct pci_dev
> *dev, int bars)
>          return err;
>      pci_fixup_device(pci_fixup_enable, dev);
> 
> -    pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
> -    if (pin) {
> -        pci_read_config_word(dev, PCI_COMMAND, &cmd);
> -        if (cmd & PCI_COMMAND_INTX_DISABLE)
> -            pci_write_config_word(dev, PCI_COMMAND,
> -                          cmd & ~PCI_COMMAND_INTX_DISABLE);
> -    }
> -
>      return 0;
>  }
> 
> @@ -1287,6 +1290,8 @@ static int pci_enable_device_flags(struct
> pci_dev *dev, unsigned long flags)
>      err = do_pci_enable_device(dev, bars);
>      if (err < 0)
>          atomic_dec(&dev->enable_cnt);
> +    else
> +        do_pci_enable_intx(dev);
>      return err;
>  }

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 5a24cb3..92718c9 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1190,11 +1190,22 @@ int __weak pcibios_enable_device(struct pci_dev *dev, int bars)
>  	return pci_enable_resources(dev, bars);
>  }
>  
> +static void do_pci_enable_intx(struct pci_dev *dev)
> +{
> +	u8 pin;
> +	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
> +	if (pin) {
> +		pci_read_config_word(dev, PCI_COMMAND, &cmd);
> +		if (cmd & PCI_COMMAND_INTX_DISABLE)
> +			pci_write_config_word(dev, PCI_COMMAND,
> +					      cmd & ~PCI_COMMAND_INTX_DISABLE);
> +	}
> +}
> +
>  static int do_pci_enable_device(struct pci_dev *dev, int bars)
>  {
>  	int err;
>  	u16 cmd;
> -	u8 pin;
>  
>  	err = pci_set_power_state(dev, PCI_D0);
>  	if (err < 0 && err != -EIO)
> @@ -1204,14 +1215,6 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
>  		return err;
>  	pci_fixup_device(pci_fixup_enable, dev);
>  
> -	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
> -	if (pin) {
> -		pci_read_config_word(dev, PCI_COMMAND, &cmd);
> -		if (cmd & PCI_COMMAND_INTX_DISABLE)
> -			pci_write_config_word(dev, PCI_COMMAND,
> -					      cmd & ~PCI_COMMAND_INTX_DISABLE);
> -	}
> -
>  	return 0;
>  }
>  
> @@ -1287,6 +1290,8 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
>  	err = do_pci_enable_device(dev, bars);
>  	if (err < 0)
>  		atomic_dec(&dev->enable_cnt);
> +	else
> +		do_pci_enable_intx(dev);
>  	return err;
>  }
>  

