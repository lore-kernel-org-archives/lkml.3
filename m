Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab3JKLCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:02:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52538 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757718Ab3JKLCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:02:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
Date: Fri, 11 Oct 2013 13:13:47 +0200
Message-ID: <2096980.ZtIelfoX39@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CA+55aFwqf7kkh0dy6AhCvB87XYkQ03YUpsYEDJmnkiRe8GQfMQ@mail.gmail.com>
References: <20131010165905.7815defa@gandalf.local.home> <18685640.N2BnVjDmHD@vostro.rjw.lan> <CA+55aFwqf7kkh0dy6AhCvB87XYkQ03YUpsYEDJmnkiRe8GQfMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 10, 2013 06:42:56 PM Linus Torvalds wrote:
> On Thu, Oct 10, 2013 at 6:45 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >
> >         /* Register slots for ejectable funtions only. */
> > -       if (acpi_pci_check_ejectable(pbus, handle)  || is_dock_device(handle)) {
> > +       if ((acpi_pci_check_ejectable(pbus, handle) || is_dock_device(handle))
> > +           && !(pdev && device_is_managed_by_native_pciehp(pdev))) {
> >                 unsigned long long sun;
> >                 int retval;
> 
> I can't even begin to say whether this is a good solution or not,
> because that if-conditional makes me want to go out and kill some
> homeless people to let my aggressions out.
> 
> Can we please agree to *never* write code like this? Ever?
> 
> Use a well-named inline helper function where the name describes what
> the f*ck the code is trying to do, and then comment the separate
> issues. Because none of the above line noise makes me go "Ahh, it's
> the test for an ejectable function".
> 
> What the heck _is_ an "ejectable function" anyway? The only comment
> there just makes the code even less sensible.
> 
> Please?

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / hotplug / PCI: Accept coexistence with native PCIe hotplug

Allow ACPIPHP (ACPI-based PCI hotplug) to handle event signaling for
devices that have already been claimed by the native PCIe hotplug
(pciehp).

The ACPI hotplug events are essentially re-scan, remove and eject
requests.  Re-scan and remove should work regardless, because they
may be triggered by user space via sysfs and the ACPI eject (_EJ0)
should work if the BIOS wants us to use it.  There may be an issue
if the BIOS signals ACPI eject and wants us to use the native eject,
but that doesn't work without this change anyway.

This change prevents the WARN_ON() in acpiphp_enumerate_slots() from
triggering unnecessarily for bridges whose parents are managed by
pciehp.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -259,6 +259,31 @@ static void acpiphp_dock_release(void *d
 	put_bridge(context->func.parent);
 }
 
+/**
+ * slot_should_be_exposed - Check whether or not to expose a slot to userland.
+ * @bridge: ACPIPHP bridge the slot belongs to.
+ * @handle: ACPI handle of a device in the slot.
+ */
+static inline bool slot_should_be_exposed(struct acpiphp_bridge *bridge,
+					  acpi_handle handle)
+{
+	struct pci_bus *pbus = bridge->pci_bus;
+	struct pci_dev *pdev = bridge->pci_dev;
+
+	/*
+	 * Do not expose slots whose bridges are managed by pciehp, because they
+	 * will be exposed to user space by the pciehp driver.
+	 */
+	if (pdev && device_is_managed_by_native_pciehp(pdev))
+		return false;
+
+	/*
+	 * Expose slots for devices with either _EJ0 or _RMV and for devices
+	 * on docking stations.
+	 */
+	return acpi_pci_check_ejectable(pbus, handle) || is_dock_device(handle);
+}
+
 /* callback routine to register each ACPI PCI slot object */
 static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
 				 void **rv)
@@ -271,12 +296,8 @@ static acpi_status register_slot(acpi_ha
 	unsigned long long adr;
 	int device, function;
 	struct pci_bus *pbus = bridge->pci_bus;
-	struct pci_dev *pdev = bridge->pci_dev;
 	u32 val;
 
-	if (pdev && device_is_managed_by_native_pciehp(pdev))
-		return AE_OK;
-
 	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
 	if (ACPI_FAILURE(status)) {
 		acpi_handle_warn(handle, "can't evaluate _ADR (%#x)\n", status);
@@ -325,8 +346,7 @@ static acpi_status register_slot(acpi_ha
 
 	list_add_tail(&slot->node, &bridge->slots);
 
-	/* Register slots for ejectable funtions only. */
-	if (acpi_pci_check_ejectable(pbus, handle)  || is_dock_device(handle)) {
+	if (slot_should_be_exposed(bridge, handle)) {
 		unsigned long long sun;
 		int retval;
 

