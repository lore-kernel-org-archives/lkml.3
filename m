Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3GXTwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:52:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38368 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3GXTwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:52:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 0/30] ACPI / hotplug / PCI: Major rework + Thunderbolt workarounds
Date: Wed, 24 Jul 2013 22:02:35 +0200
Message-ID: <1393554.usuhpOuYgm@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo6z9CqCyLFbXpuJMtHHjLRNbo=gx87W_0_7TCHbvwrCRw@mail.gmail.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <6958813.eThhpoh5QO@vostro.rjw.lan> <CAErSpo6z9CqCyLFbXpuJMtHHjLRNbo=gx87W_0_7TCHbvwrCRw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 24, 2013 10:06:01 AM Bjorn Helgaas wrote:
> On Wed, Jul 24, 2013 at 6:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, July 23, 2013 07:20:53 PM Yinghai Lu wrote:
> >> On Tue, Jul 23, 2013 at 2:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > [...]
> >
> >> [  102.631369] pci_host_bridge pci0000:00: freeing pci_host_bridge info
> >
> > By the way this looks fishy:
> >
> >> [  102.633091] ACPI: Device does not support D3cold
> 
> This and other printks in that function don't give any clue what
> device is involved, even though we have an acpi_device pointer.  It'd
> be nice to fix that, too.

As it turns out, I have that patch ready as well.  Appended for completeness.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / PM: Make messages in acpi_device_set_power() print device name

Modify acpi_device_set_power() so that diagnostic messages printed by
it to the kernel log always contain the name of the device to make it
possible to identify the device if need be.  Also replace
printk(KERN_WARNING ) with dev_warn() everywhere in that function.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -166,20 +166,20 @@ int acpi_device_set_power(struct acpi_de
 	/* Make sure this is a valid target state */
 
 	if (state == device->power.state) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at %s\n",
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] already in %s\n",
+				  device->pnp.bus_id,
 				  acpi_power_state_string(state)));
 		return 0;
 	}
 
 	if (!device->power.states[state].flags.valid) {
-		printk(KERN_WARNING PREFIX "Device does not support %s\n",
-		       acpi_power_state_string(state));
+		dev_warn(&device->dev, "Power state %s not supported\n",
+			 acpi_power_state_string(state));
 		return -ENODEV;
 	}
 	if (device->parent && (state < device->parent->power.state)) {
-		printk(KERN_WARNING PREFIX
-			      "Cannot set device to a higher-powered"
-			      " state than parent\n");
+		dev_warn(&device->dev, "Cannot transition to a higher-powered "
+			 "state than parent\n");
 		return -ENODEV;
 	}
 
@@ -192,8 +192,8 @@ int acpi_device_set_power(struct acpi_de
 
 	if (state < device->power.state && state != ACPI_STATE_D0
 	    && device->power.state >= ACPI_STATE_D3_HOT) {
-		printk(KERN_WARNING PREFIX
-			"Cannot transition to non-D0 state from D3\n");
+		dev_warn(&device->dev,
+			 "Cannot transition to non-D0 state from D3\n");
 		return -ENODEV;
 	}
 
@@ -220,10 +220,8 @@ int acpi_device_set_power(struct acpi_de
 
  end:
 	if (result) {
-		printk(KERN_WARNING PREFIX
-			      "Device [%s] failed to transition to %s\n",
-			      device->pnp.bus_id,
-			      acpi_power_state_string(state));
+		dev_warn(&device->dev, "Failed to change power state to %s\n",
+			 acpi_power_state_string(state));
 	} else {
 		device->power.state = state;
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,

