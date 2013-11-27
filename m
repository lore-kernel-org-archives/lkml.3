Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3K0AuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:50:03 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49988 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753069Ab3K0Atz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:49:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 0/4] ACPI / bind: Simplify child devices lookup
Date: Wed, 27 Nov 2013 02:02:43 +0100
Message-ID: <8065346.ZtkoVh8DW8@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385512408.1791.196.camel@misato.fc.hp.com>
References: <2610478.KxPMyuOMok@vostro.rjw.lan> <3773077.bfZR2z09sY@vostro.rjw.lan> <1385512408.1791.196.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 05:33:28 PM Toshi Kani wrote:
> On Wed, 2013-11-27 at 01:27 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, November 26, 2013 05:00:42 PM Toshi Kani wrote:
> > > On Mon, 2013-11-25 at 01:09 +0100, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > The following series of four patches (on top of current linux-pm.git/bleeding-edge)
> > > > rework child device lookup in drivers/acpi/glue.c and related things:
> > > > 
> > > > [1/4] ACPI / bind: Simplify child device lookup
> > > > [2/4] PCI/ ACPI: Use acpi_find_child_device() for child device lookup
> > > > [3/4] ACPI / bind: Redefine acpi_get_child()
> > > > [4/4] ACPI / bind: Redefine acpi_preset_companion()
> > > 
> > > This patchset caused the attached panic during boot on a system.
> > > acpi_pci_find_device() called acpi_find_child_device() with
> > > ACPI_COMPANION(dev->parent) being a NULL pointer when scanning bus 0xf.
> > > 
> > > This bus 0xf seems to be a chipset internal bus, which is not intended
> > > for the OS to use.  Therefore, ACPI does not list its PCI bridge device.
> > > 
> > > # lspci -tv
> > >    :
> > >  +-[0000:0f]-+-08.0  Intel Corporation Ivytown QPI Link 0
> > >  |           +-08.2  Intel Corporation Ivytown QPI Link 0
> > >    :
> > > 
> > > However, pcibios_fixup_peer_bridges(), called from pci_subsys_init(),
> > > finds this bus as it scans all the buses from 0 to pcibios_last_bus.
> > > Hence, this dev->parent does not have an associated ACPI device object. 
> > 
> > Thanks for the report!
> > 
> > I've dropped the patches from bleeding-edge for now.
> > 
> > Does "[1/4] ACPI / bind: Simplify child device lookup" alone work on that
> > system?
> 
> Yes, the system boots fine with 1/4 alone.

Thanks!

Can you please check if the following modified [2/4] also works on top of it?

Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: PCI / ACPI: Use acpi_find_child_device() for child devices lookup

It is much more efficient to use acpi_find_child_device()
for child devices lookup in acpi_pci_find_device() and pass
ACPI_COMPANION(dev->parent) to it directly instead of obtaining
ACPI_HANDLE() of ACPI_COMPANION(dev->parent) and passing it to
acpi_find_child() which has to run acpi_bus_get_device() to
obtain ACPI_COMPANION(dev->parent) from that again.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/glue.c    |    3 +++
 drivers/pci/pci-acpi.c |   16 ++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -309,7 +309,8 @@ void acpi_pci_remove_bus(struct pci_bus
 static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	bool is_bridge;
+	struct acpi_device *adev;
+	bool check_children;
 	u64 addr;
 
 	/*
@@ -317,14 +318,17 @@ static int acpi_pci_find_device(struct d
 	 * is set only after acpi_pci_find_device() has been called for the
 	 * given device.
 	 */
-	is_bridge = pci_dev->hdr_type == PCI_HEADER_TYPE_BRIDGE
+	check_children = pci_dev->hdr_type == PCI_HEADER_TYPE_BRIDGE
 			|| pci_dev->hdr_type == PCI_HEADER_TYPE_CARDBUS;
 	/* Please ref to ACPI spec for the syntax of _ADR */
 	addr = (PCI_SLOT(pci_dev->devfn) << 16) | PCI_FUNC(pci_dev->devfn);
-	*handle = acpi_find_child(ACPI_HANDLE(dev->parent), addr, is_bridge);
-	if (!*handle)
-		return -ENODEV;
-	return 0;
+	adev = acpi_find_child_device(ACPI_COMPANION(dev->parent), addr,
+				      check_children);
+	if (adev) {
+		*handle = adev->handle;
+		return 0;
+	}
+	return -ENODEV;
 }
 
 static void pci_acpi_setup(struct device *dev)
Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -106,6 +106,9 @@ struct acpi_device *acpi_find_child_devi
 	struct acpi_device *adev, *ret = NULL;
 	int ret_score = 0;
 
+	if (!parent)
+		return NULL;
+
 	list_for_each_entry(adev, &parent->children, node) {
 		unsigned long long addr;
 		acpi_status status;

