Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3FYTIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:08:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3FYSdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 33/95] ACPI / resources: call acpi_get_override_irq() only for legacy IRQ resources
Date: Tue, 25 Jun 2013 11:32:20 -0700
Message-Id: <20130625182157.377668058@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 204ebc0aa30a7115f300cac39fbb7eeb66524881 upstream.

acpi_get_override_irq() was added because there was a problem with
buggy BIOSes passing wrong IRQ() resource for the RTC IRQ.  The
commit that added the workaround was 61fd47e0c8476 (ACPI: fix two
IRQ8 issues in IOAPIC mode).

With ACPI 5 enumerated devices there are typically one or more
extended IRQ resources per device (and these IRQs can be shared).
However, the acpi_get_override_irq() workaround forces all IRQs in
range 0 - 15 (the legacy ISA IRQs) to be edge triggered, active high
as can be seen from the dmesg below:

	ACPI: IRQ 6 override to edge, high
	ACPI: IRQ 7 override to edge, high
	ACPI: IRQ 7 override to edge, high
	ACPI: IRQ 13 override to edge, high

Also /proc/interrupts for the I2C controllers (INT33C2 and INT33C3) shows
the same thing:

	7:          4          0          0          0   IO-APIC-edge INT33C2:00, INT33C3:00

The _CSR method for INT33C2 (and INT33C3) device returns following
resource:

	Interrupt (ResourceConsumer, Level, ActiveLow, Shared,,, )
	{
		0x00000007,
	}

which states that this is supposed to be level triggered, active low,
shared IRQ instead.

Fix this by making sure that acpi_get_override_irq() gets only called
when we are dealing with legacy IRQ() or IRQNoFlags() descriptors.

While we are there, correct pr_warning() to print the right triggering
value.

This change turns out to be necessary to make DMA work correctly on
systems based on the Intel Lynxpoint PCH (Platform Controller Hub).

[rjw: Changelog]
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/resource.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -304,7 +304,8 @@ static void acpi_dev_irqresource_disable
 }
 
 static void acpi_dev_get_irqresource(struct resource *res, u32 gsi,
-				     u8 triggering, u8 polarity, u8 shareable)
+				     u8 triggering, u8 polarity, u8 shareable,
+				     bool legacy)
 {
 	int irq, p, t;
 
@@ -317,14 +318,19 @@ static void acpi_dev_get_irqresource(str
 	 * In IO-APIC mode, use overrided attribute. Two reasons:
 	 * 1. BIOS bug in DSDT
 	 * 2. BIOS uses IO-APIC mode Interrupt Source Override
+	 *
+	 * We do this only if we are dealing with IRQ() or IRQNoFlags()
+	 * resource (the legacy ISA resources). With modern ACPI 5 devices
+	 * using extended IRQ descriptors we take the IRQ configuration
+	 * from _CRS directly.
 	 */
-	if (!acpi_get_override_irq(gsi, &t, &p)) {
+	if (legacy && !acpi_get_override_irq(gsi, &t, &p)) {
 		u8 trig = t ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
 		u8 pol = p ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
 
 		if (triggering != trig || polarity != pol) {
 			pr_warning("ACPI: IRQ %d override to %s, %s\n", gsi,
-				   t ? "edge" : "level", p ? "low" : "high");
+				   t ? "level" : "edge", p ? "low" : "high");
 			triggering = trig;
 			polarity = pol;
 		}
@@ -373,7 +379,7 @@ bool acpi_dev_resource_interrupt(struct
 		}
 		acpi_dev_get_irqresource(res, irq->interrupts[index],
 					 irq->triggering, irq->polarity,
-					 irq->sharable);
+					 irq->sharable, true);
 		break;
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 		ext_irq = &ares->data.extended_irq;
@@ -383,7 +389,7 @@ bool acpi_dev_resource_interrupt(struct
 		}
 		acpi_dev_get_irqresource(res, ext_irq->interrupts[index],
 					 ext_irq->triggering, ext_irq->polarity,
-					 ext_irq->sharable);
+					 ext_irq->sharable, false);
 		break;
 	default:
 		return false;


