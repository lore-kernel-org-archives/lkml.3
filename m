Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbaGOUwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:52:02 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:52314 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919AbaGOUv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:51:59 -0400
MIME-Version: 1.0
In-Reply-To: <1405317877-15060-1-git-send-email-vidyas@nvidia.com>
References: <1405317877-15060-1-git-send-email-vidyas@nvidia.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 15 Jul 2014 14:51:38 -0600
Message-ID: <CAErSpo4D5m14wk6k2Hd19tH+E_VbtmSR2SncQBhg5Dq=KSyKSw@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: enable ASPM configuration in PCIE POWERSAVE mode
To: Vidya Sagar <sagar.tv@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nagananda Chumbalkar <nchumbalkar@lenovo.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Krishna Thota <kthota@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vidya Sagar <vidyas@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Matthew, Rafael]

On Mon, Jul 14, 2014 at 12:04 AM, Vidya Sagar <sagar.tv@gmail.com> wrote:
> From: Vidya Sagar <sagar.tv@gmail.com>
>
> 'commit 1a680b7c3258 ("PCI: PCIe links may not get configured for ASPM
>  under POWERSAVE mode")' moved pcie_aspm_powersave_config_link() out of
> pci_raw_set_power_state() to pci_set_power_state() which would enable
> ASPM. But, with 'commit db288c9c5f9d ("PCI / PM: restore the original
>  behavior of pci_set_power_state()")', which re-introduced the following check
> ./drivers/pci/pci.c: pci_set_power_state()
> +   /* Check if we're already there */
> +   if (dev->current_state == state)
> +       return 0;
> in pci_set_power_state(), call to pcie_aspm_powersave_config_link() is never
> made leaving ASPM broken.
> Fix it by not returning from when the above condition is true, rather, jump to
> ASPM configuration code and exit from there eventually.
>
> Signed-off-by: Vidya Sagar <sagar.tv@gmail.com>

I'm OK with the patch (obviously, since I wrote it), but you neglected
to copy Matthew and Rafael.  And you forgot to rewrite the changelog.
I'll take care of the changelog, but I would like to see something
from Matthew and Rafael, since this is a significant change in how we
configure ASPM.

Matthew, Rafael, my observation was: "But I wonder if we can untangle
ASPM from pci_set_power_state().  I don't think they're really
related.  There are a zillion .suspend() and .resume() methods that
call pci_set_power_state().  I doubt that we need to do ASPM
configuration during suspend, and I'm dubious about resume, too."

So the new patch moves the pcie_aspm_powersave_config_link() call out
of pci_set_power_state() and into do_pci_enable_device().

Bjorn

> ---
> v2:
> * Calling ASPM config code is moved from pci_set_power_state() to
> * do_pci_enable_device()
>
>  drivers/pci/pci.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 1c8592b..81d49d3 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -839,12 +839,6 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>
>         if (!__pci_complete_power_transition(dev, state))
>                 error = 0;
> -       /*
> -        * When aspm_policy is "powersave" this call ensures
> -        * that ASPM is configured.
> -        */
> -       if (!error && dev->bus->self)
> -               pcie_aspm_powersave_config_link(dev->bus->self);
>
>         return error;
>  }
> @@ -1195,12 +1189,18 @@ int __weak pcibios_enable_device(struct pci_dev *dev, int bars)
>  static int do_pci_enable_device(struct pci_dev *dev, int bars)
>  {
>         int err;
> +       struct pci_dev *bridge;
>         u16 cmd;
>         u8 pin;
>
>         err = pci_set_power_state(dev, PCI_D0);
>         if (err < 0 && err != -EIO)
>                 return err;
> +
> +       bridge = pci_upstream_bridge(dev);
> +       if (bridge)
> +               pcie_aspm_powersave_config_link(bridge);
> +
>         err = pcibios_enable_device(dev, bars);
>         if (err < 0)
>                 return err;
> --
> 1.8.1.5
>
