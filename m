Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3EKUS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 16:18:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44229 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab3EKUS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 16:18:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        Guo-Fu Tseng <cooldavid@cooldavid.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>, nic_swsd@realtek.com,
        aacraid@adaptec.com, linux-kernel@vger.kernel.org
Subject: Re: is L1 really disabled in iwlwifi
Date: Sat, 11 May 2013 22:26:53 +0200
Message-ID: <1725435.3DlCxYF2FV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130510225257.GA10847@google.com>
References: <CANUX_P2Hy02SnyYS24dyUGLv3wB3L5xkXt8Y1s+8_RG9d5ReAw@mail.gmail.com> <CAErSpo6OCyTy19u6Xaf=xr0TSDriwCD3n-oMc7eJyLzuJ9d60g@mail.gmail.com> <20130510225257.GA10847@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 10, 2013 04:52:57 PM Bjorn Helgaas wrote:
> [+cc Rafael, other pci_disable_link_state() users]
> 
> On Wed, May 01, 2013 at 11:13:15AM -0600, Bjorn Helgaas wrote:
> > On Wed, May 1, 2013 at 2:31 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> > > [from Bjorn's mail]
> > >> In Emmanuel's case, we don't get _OSC control, so
> > >> pci_disable_link_state() does nothing.
> > >
> > > Right, but this is true with the specific log I sent to you. Is it
> > > possible that another platform  / BIOS, we *will* get _OSC control and
> > > that pci_disable_link_state() will actually do something?  In that case
> > > I would prefer not to remove the call to pcie_disable_link_state().
> > 
> > Yes, absolutely, on many platforms we will get _OSC control, and
> > pci_disable_link_state() will work as expected.  The problem is that
> > the driver doesn't have a good way to know whether pci_disable_link()
> > did anything or not.
> > 
> > Today I think we have:
> > 
> > 1) If the BIOS grants the OS permission to control PCIe services via
> > _OSC, pci_disable_link_state() works and L1 will be disabled.
> > 
> > 2) If the BIOS does not grant permission, pci_disable_link_state()
> > does nothing and L1 may be enabled or not depending on what
> > configuration the BIOS did.
> > 
> > If the device really doesn't work reliably when L1 is enabled, we're
> > currently at the mercy of the BIOS -- if the BIOS enables L1 but
> > doesn't grant us permission via _OSC, L1 will remain enabled (as it is
> > on your system).
> 
> I propose the following patch.  Any comments?

In my opinion this is dangerous, because it opens us to bugs that right now
are prevented from happening due to the way the code works.

Thanks,
Rafael


> commit cd11e3f87c4d2777cf8921c0454500c9baa54b46
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Fri May 10 15:54:35 2013 -0600
> 
>     PCI/ASPM: Allow drivers to disable ASPM unconditionally
>     
>     Some devices have hardware problems related to using ASPM.  Drivers for
>     these devices use pci_disable_link_state() to prevent their device from
>     entering L0s or L1.  But on platforms where the OS doesn't have permission
>     to manage ASPM, pci_disable_link_state() does nothing, and the driver has
>     no way to know this.
>     
>     Therefore, if the BIOS enables ASPM but declines (either via the FADT
>     ACPI_FADT_NO_ASPM bit or the _OSC method) to allow the OS to manage it,
>     the device can still use ASPM and trip over the hardware issue.
>     
>     This patch makes pci_disable_link_state() disable ASPM unconditionally,
>     regardless of whether the OS has permission to manage ASPM in general.
>     
>     Reported-by: Emmanuel Grumbach <egrumbach@gmail.com>
>     Reference: https://lkml.kernel.org/r/CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com
>     Reference: https://bugzilla.kernel.org/show_bug.cgi?id=57331
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index d320df6..9ef4ab8 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -718,15 +718,11 @@ void pcie_aspm_powersave_config_link(struct pci_dev *pdev)
>   * pci_disable_link_state - disable pci device's link state, so the link will
>   * never enter specific states
>   */
> -static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem,
> -				     bool force)
> +static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
>  {
>  	struct pci_dev *parent = pdev->bus->self;
>  	struct pcie_link_state *link;
>  
> -	if (aspm_disabled && !force)
> -		return;
> -
>  	if (!pci_is_pcie(pdev))
>  		return;
>  
> @@ -757,13 +753,13 @@ static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem,
>  
>  void pci_disable_link_state_locked(struct pci_dev *pdev, int state)
>  {
> -	__pci_disable_link_state(pdev, state, false, false);
> +	__pci_disable_link_state(pdev, state, false);
>  }
>  EXPORT_SYMBOL(pci_disable_link_state_locked);
>  
>  void pci_disable_link_state(struct pci_dev *pdev, int state)
>  {
> -	__pci_disable_link_state(pdev, state, true, false);
> +	__pci_disable_link_state(pdev, state, true);
>  }
>  EXPORT_SYMBOL(pci_disable_link_state);
>  
> @@ -781,7 +777,7 @@ void pcie_clear_aspm(struct pci_bus *bus)
>  		__pci_disable_link_state(child, PCIE_LINK_STATE_L0S |
>  					 PCIE_LINK_STATE_L1 |
>  					 PCIE_LINK_STATE_CLKPM,
> -					 false, true);
> +					 false);
>  	}
>  }
>  
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
