Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaGPVMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:12:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49646 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753823AbaGPVML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:12:11 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Vidya Sagar <sagar.tv@gmail.com>, matthew.garrett@nebula.com,
        nchumbalkar@lenovo.com, thierry.reding@gmail.com, swarren@nvidia.com,
        linux-pci@vger.kernel.org, kthota@nvidia.com,
        linux-kernel@vger.kernel.org, vidyas@nvidia.com
Subject: Re: [PATCH v3] PCI: enable ASPM configuration in PCIE POWERSAVE mode
Date: Wed, 16 Jul 2014 23:30:27 +0200
Message-ID: <1480976.v66rlUIZnu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140716193637.GA14366@google.com>
References: <1405505022-7593-1-git-send-email-vidyas@nvidia.com> <20140716193637.GA14366@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2014 01:36:37 PM Bjorn Helgaas wrote:
> On Wed, Jul 16, 2014 at 03:33:42PM +0530, Vidya Sagar wrote:
> > From: Vidya Sagar <sagar.tv@gmail.com>
> > 
> > Commit 1a680b7c3258 ("PCI: PCIe links may not get configured for ASPM
> >  under POWERSAVE mode") moved pcie_aspm_powersave_config_link() out of
> > pci_raw_set_power_state() to pci_set_power_state() which would enable
> > ASPM. But, with Commit db288c9c5f9d ("PCI / PM: restore the original
> >  behavior of pci_set_power_state()"), which re-introduced the following check
> > ./drivers/pci/pci.c: pci_set_power_state()
> > 
> > +	/* Check if we're already there */
> > +	if (dev->current_state == state)
> > +	   return 0;
> > 
> > in pci_set_power_state(), call to pcie_aspm_powersave_config_link() is never
> > made leaving ASPM broken.
> > Fix it by configuring links for ASPM in do_pci_enable_device() instead of
> > pci_set_power_state()
> > 
> > Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
> > Signed-off-by: Vidya Sagar <sagar.tv@gmail.com>
> 
> I applied this to pci/misc for v3.17 with the following changelog:
> 
> It would still make me feel better if Matthew and/or Rafael acked this.
> 
>     PCI: Configure ASPM when enabling device
>     
>     We can't do ASPM configuration at enumeration-time because enabling it
>     makes some defective hardware unresponsive, even if ASPM is disabled later
>     (see 41cd766b0659 ("PCI: Don't enable aspm before drivers have had a chance
>     to veto it").  Therefore, we have to do it after a driver claims the
>     device.
>     
>     We previously configured ASPM in pci_set_power_state(), but that's not a
>     very good place because it's not really related to setting the PCI device
>     power state, and doing it there means:
>     
>       - We incorrectly skipped ASPM config when setting a device that's
>         already in D0 to D0.
>     
>       - We unnecessarily configured ASPM when setting a device to a low-power
>         state (the ASPM feature only applies when the device is in D0).
>     
>       - We unnecessarily configured ASPM when called from a .resume() method
>         (ASPM configuration needs to be restored during resume, but I think
>         pci_restore_pcie_state() should already do this).
>     
>     Move ASPM configuration from pci_set_power_state() to
>     do_pci_enable_device() so we do it when a driver enables a device.
>     
>     [bhelgaas: changelog]
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=79621
> 
> It would still make me feel better if Matthew and/or Rafael chimed in to
> make sure this is sane.

I like the change, but I'm not sure whether or not it will work for everyone.

The only way to verify that seems to be to apply it, however.

Rafael

