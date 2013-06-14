Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3FNXEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 19:04:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37814 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3FNXEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 19:04:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] PCI / ACPI / PM: Use correct power state strings in messages
Date: Sat, 15 Jun 2013 01:13:22 +0200
Message-ID: <1560214.24OrRSoYgv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130614224949.GA29105@google.com>
References: <2491625.TQ1FFQeR38@vostro.rjw.lan> <1701924.fhYB0ilm4Z@vostro.rjw.lan> <20130614224949.GA29105@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 04:49:49 PM Bjorn Helgaas wrote:
> On Sat, Jun 15, 2013 at 12:28:12AM +0200, Rafael J. Wysocki wrote:
> > On Friday, June 14, 2013 11:08:44 AM Bjorn Helgaas wrote:
> > > On Thu, Jun 13, 2013 at 4:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > >
> > > > Make acpi_pci_set_power_state() print the name of the ACPI device
> > > > power state the device has been actually put into instead of printing
> > > > the name of the requested PCI device power state, which need not be
> > > > the same.
> > > >
> > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > ---
> > > >
> > > > For 3.11.
> > > >
> > > > Thanks,
> > > > Rafael
> > > >
> > > > ---
> > > >  drivers/pci/pci-acpi.c |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > Index: linux-pm/drivers/pci/pci-acpi.c
> > > > ===================================================================
> > > > --- linux-pm.orig/drivers/pci/pci-acpi.c
> > > > +++ linux-pm/drivers/pci/pci-acpi.c
> > > > @@ -211,7 +211,7 @@ static int acpi_pci_set_power_state(stru
> > > >
> > > >         if (!error)
> > > >                 dev_info(&dev->dev, "power state changed by ACPI to %s\n",
> > > > -                        pci_power_name(state));
> > > > +                        acpi_power_state_string(state_conv[state]));
> > > >
> > > >         return error;
> > > >  }
> > > >
> > > 
> > > Just to double-check this, it *looks* like the effective change is
> > > that for PCI_D3hot and PCI_D3cold, we'll print "(unknown)" instead of
> > > "D3hot" and "D3cold" because state_conv[] folds both PCI_D3hot and
> > > PCI_D3cold into ACPI_STATE_D3, and acpi_power_state_string() doesn't
> > > have a case for ACPI_STATE_D3.
> > 
> > No, it won't work like this, because ACPI_STATE_D3 == ACPI_STATE_D3_COLD. :-)
> > 
> > So, actually, "D3cold" will be printed for both PCI_D3hot and PCI_D3cold
> > (and I have tested this).
> 
> Ah, right, I should have noticed that.
> 
> > Well, I think it's better to actually replace ACPI_STATE_D3 everywhere in
> > pci-acpi.c with ACPI_STATE_D3_COLD to avoid that confusion.  Do you want me
> > to prepare a patch?
> 
> If the following is OK, I'll just put it in my pci/misc branch:

Yes, it is, thanks!

Rafael


> commit fc6504b3a4dc9beae782a11e6f7c3c4a9f077fb8
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Fri Jun 14 00:29:50 2013 +0200
> 
>     PCI / ACPI / PM: Use correct power state strings in messages
>     
>     Make acpi_pci_set_power_state() print the name of the ACPI device
>     power state the device has been actually put into instead of printing
>     the name of the requested PCI device power state, which need not be
>     the same.
>     
>     [bhelgaas: use ACPI_STATE_D3_COLD (ACPI_STATE_D3 == ACPI_STATE_D3_COLD)]
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index 6c15d6a..dbdc5f7 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -186,8 +186,8 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  		[PCI_D0] = ACPI_STATE_D0,
>  		[PCI_D1] = ACPI_STATE_D1,
>  		[PCI_D2] = ACPI_STATE_D2,
> -		[PCI_D3hot] = ACPI_STATE_D3,
> -		[PCI_D3cold] = ACPI_STATE_D3
> +		[PCI_D3hot] = ACPI_STATE_D3_COLD,
> +		[PCI_D3cold] = ACPI_STATE_D3_COLD,
>  	};
>  	int error = -EINVAL;
>  
> @@ -211,7 +211,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  
>  	if (!error)
>  		dev_info(&dev->dev, "power state changed by ACPI to %s\n",
> -			 pci_power_name(state));
> +			 acpi_power_state_string(state_conv[state]));
>  
>  	return error;
>  }
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
