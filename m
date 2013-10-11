Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3JKBdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:33:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64105 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751902Ab3JKBdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:33:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
Date: Fri, 11 Oct 2013 03:45:31 +0200
Message-ID: <18685640.N2BnVjDmHD@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2679976.SxBsymIdoJ@vostro.rjw.lan>
References: <20131010165905.7815defa@gandalf.local.home> <CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com> <2679976.SxBsymIdoJ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 11, 2013 01:09:33 AM Rafael J. Wysocki wrote:
> On Thursday, October 10, 2013 02:37:15 PM Linus Torvalds wrote:
> > On Thu, Oct 10, 2013 at 2:35 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > >
> > > Well, I must have overlooked the original report.  Is it available anywhere
> > > I can find it?
> > 
> > I think Steven has some buggered email system, he has other emails
> > being eaten by lkml too, and apparently other mail gateways (because
> > you were direct-cc'd on the original).
> 
> Mailer issues aside, I've just seen the original (Bjorn forwarded it to me,
> thanks!) and I'm wondering if the message added by the debug patch below is
> triggered along with the WARN_ON().  If it is, I think it's better to drop
> the WARN_ON(), at least for now (until we sort out the acpiphp/pciehp
> coexistence).
>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -991,6 +991,11 @@ void acpiphp_enumerate_slots(struct pci_
>  
>  	if (!pci_is_root_bus(bridge->pci_bus)) {
>  		struct acpiphp_context *context;
> +		struct pci_dev *parent = bridge->pci_bus->parent->self;
> +
> +		if (parent && device_is_managed_by_native_pciehp(parent))
> +			dev_warn(&bridge->pci_dev->dev,
> +				 "Parent is managed by pciehp!\n");
>  
>  		/*
>  		 * This bridge should have been registered as a hotplug function
> 

Steve told me over IRC that the message added by the above triggered along
with the WARN_ON(), so this really was the issue I had in mind.  So, I asked
Steve to test the appended patch and it worked for him.

Well, I admit this is a gray area, because we've never tried it, but I think
we'll need to try it at one point anyway and see how it goes, so why don't we
actually do that now?

If it turns out to cause problems to happen for people, we can simply revert
it and remove the WARN_ON() instead.  And then we'll know that this is
problematic.

What do you think?

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / hotplug / PCI: Accept coexistence with native PCIe hotplug

Allow ACPIPHP (ACPI-based PCI hotplug) to handle event signaling for
devices that have already been claimed by the native PCIe hotplug
(pciehp).

This change prevents the WARN_ON() in acpiphp_enumerate_slots() from
triggering unnecessarily for bridges whose parents are managed by
pciehp.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -274,9 +274,6 @@ static acpi_status register_slot(acpi_ha
 	struct pci_dev *pdev = bridge->pci_dev;
 	u32 val;
 
-	if (pdev && device_is_managed_by_native_pciehp(pdev))
-		return AE_OK;
-
 	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
 	if (ACPI_FAILURE(status)) {
 		acpi_handle_warn(handle, "can't evaluate _ADR (%#x)\n", status);
@@ -326,7 +323,8 @@ static acpi_status register_slot(acpi_ha
 	list_add_tail(&slot->node, &bridge->slots);
 
 	/* Register slots for ejectable funtions only. */
-	if (acpi_pci_check_ejectable(pbus, handle)  || is_dock_device(handle)) {
+	if ((acpi_pci_check_ejectable(pbus, handle) || is_dock_device(handle))
+	    && !(pdev && device_is_managed_by_native_pciehp(pdev))) {
 		unsigned long long sun;
 		int retval;
 

