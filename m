Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3EJWxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 18:53:06 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:64417 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab3EJWxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 18:53:01 -0400
Date: Fri, 10 May 2013 16:52:57 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        Guo-Fu Tseng <cooldavid@cooldavid.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>, nic_swsd@realtek.com,
        aacraid@adaptec.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Subject: Re: is L1 really disabled in iwlwifi
Message-ID: <20130510225257.GA10847@google.com>
References: <CANUX_P2Hy02SnyYS24dyUGLv3wB3L5xkXt8Y1s+8_RG9d5ReAw@mail.gmail.com>
 <CANUX_P3znXgMN5aBZbEVx_zKpTQ98my1C_cBG5+mERFWrrrLEw@mail.gmail.com>
 <CANUX_P3Mt3X8JXq5siSijrWGkjeWbTCcdmJ-Fuv6U8jUqrFouQ@mail.gmail.com>
 <CAErSpo66=UngrHNcEDeh4gXnt5c0qJHwbxum0mBz-rSWGduLhg@mail.gmail.com>
 <CANUX_P0hpx8NNvX6cJXfOZMNYN8hrEF-gzf9hBN2Uz=k0WiwgA@mail.gmail.com>
 <CANUX_P1JnFk7yovC7kXBMDWiErGhvzDQrNCm8te39m41SonCNg@mail.gmail.com>
 <CAErSpo5WbdCx0iyt14bJxCiNBtUWjT2rMeg5YwNQaRt=M+_v8Q@mail.gmail.com>
 <1367362536.9976.9.camel@x230>
 <CANUX_P1sS8+3s-8-TyovHEwpa5qgQDj4W8P_hvfQjE2MKcTNEA@mail.gmail.com>
 <CAErSpo6OCyTy19u6Xaf=xr0TSDriwCD3n-oMc7eJyLzuJ9d60g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6OCyTy19u6Xaf=xr0TSDriwCD3n-oMc7eJyLzuJ9d60g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael, other pci_disable_link_state() users]

On Wed, May 01, 2013 at 11:13:15AM -0600, Bjorn Helgaas wrote:
> On Wed, May 1, 2013 at 2:31 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> > [from Bjorn's mail]
> >> In Emmanuel's case, we don't get _OSC control, so
> >> pci_disable_link_state() does nothing.
> >
> > Right, but this is true with the specific log I sent to you. Is it
> > possible that another platform  / BIOS, we *will* get _OSC control and
> > that pci_disable_link_state() will actually do something?  In that case
> > I would prefer not to remove the call to pcie_disable_link_state().
> 
> Yes, absolutely, on many platforms we will get _OSC control, and
> pci_disable_link_state() will work as expected.  The problem is that
> the driver doesn't have a good way to know whether pci_disable_link()
> did anything or not.
> 
> Today I think we have:
> 
> 1) If the BIOS grants the OS permission to control PCIe services via
> _OSC, pci_disable_link_state() works and L1 will be disabled.
> 
> 2) If the BIOS does not grant permission, pci_disable_link_state()
> does nothing and L1 may be enabled or not depending on what
> configuration the BIOS did.
> 
> If the device really doesn't work reliably when L1 is enabled, we're
> currently at the mercy of the BIOS -- if the BIOS enables L1 but
> doesn't grant us permission via _OSC, L1 will remain enabled (as it is
> on your system).

I propose the following patch.  Any comments?


commit cd11e3f87c4d2777cf8921c0454500c9baa54b46
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Fri May 10 15:54:35 2013 -0600

    PCI/ASPM: Allow drivers to disable ASPM unconditionally
    
    Some devices have hardware problems related to using ASPM.  Drivers for
    these devices use pci_disable_link_state() to prevent their device from
    entering L0s or L1.  But on platforms where the OS doesn't have permission
    to manage ASPM, pci_disable_link_state() does nothing, and the driver has
    no way to know this.
    
    Therefore, if the BIOS enables ASPM but declines (either via the FADT
    ACPI_FADT_NO_ASPM bit or the _OSC method) to allow the OS to manage it,
    the device can still use ASPM and trip over the hardware issue.
    
    This patch makes pci_disable_link_state() disable ASPM unconditionally,
    regardless of whether the OS has permission to manage ASPM in general.
    
    Reported-by: Emmanuel Grumbach <egrumbach@gmail.com>
    Reference: https://lkml.kernel.org/r/CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com
    Reference: https://bugzilla.kernel.org/show_bug.cgi?id=57331
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index d320df6..9ef4ab8 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -718,15 +718,11 @@ void pcie_aspm_powersave_config_link(struct pci_dev *pdev)
  * pci_disable_link_state - disable pci device's link state, so the link will
  * never enter specific states
  */
-static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem,
-				     bool force)
+static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
 {
 	struct pci_dev *parent = pdev->bus->self;
 	struct pcie_link_state *link;
 
-	if (aspm_disabled && !force)
-		return;
-
 	if (!pci_is_pcie(pdev))
 		return;
 
@@ -757,13 +753,13 @@ static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem,
 
 void pci_disable_link_state_locked(struct pci_dev *pdev, int state)
 {
-	__pci_disable_link_state(pdev, state, false, false);
+	__pci_disable_link_state(pdev, state, false);
 }
 EXPORT_SYMBOL(pci_disable_link_state_locked);
 
 void pci_disable_link_state(struct pci_dev *pdev, int state)
 {
-	__pci_disable_link_state(pdev, state, true, false);
+	__pci_disable_link_state(pdev, state, true);
 }
 EXPORT_SYMBOL(pci_disable_link_state);
 
@@ -781,7 +777,7 @@ void pcie_clear_aspm(struct pci_bus *bus)
 		__pci_disable_link_state(child, PCIE_LINK_STATE_L0S |
 					 PCIE_LINK_STATE_L1 |
 					 PCIE_LINK_STATE_CLKPM,
-					 false, true);
+					 false);
 	}
 }
 
