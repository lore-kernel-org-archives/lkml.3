Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbaKEROQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:14:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41734 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaKEROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:14:11 -0500
Date: Wed, 5 Nov 2014 09:12:46 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-ba28a8505a43074cceab7b5f454cb1a107159b00@git.kernel.org>
Cc: rdunlap@infradead.org, gregkh@linuxfoundation.org, yinghai@kernel.org,
        konrad.wilk@oracle.com, pavel@ucw.cz, tglx@linutronix.de, bp@alien8.de,
        benh@kernel.crashing.org, joro@8bytes.org, bhelgaas@google.com,
        hpa@zytor.com, jiang.liu@linux.intel.com, mingo@kernel.org,
        rjw@rjwysocki.net, len.brown@intel.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org, rjw@rjwysocki.net,
        len.brown@intel.com, tony.luck@intel.com, tglx@linutronix.de,
        bp@alien8.de, joro@8bytes.org, benh@kernel.crashing.org,
        bhelgaas@google.com, hpa@zytor.com, jiang.liu@linux.intel.com,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, yinghai@kernel.org, pavel@ucw.cz
In-Reply-To: <1414397531-28254-2-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-2-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] ACPI, irq, x86:
  Get rid of special handling of GSI for ACPI SCI
Git-Commit-ID: ba28a8505a43074cceab7b5f454cb1a107159b00
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba28a8505a43074cceab7b5f454cb1a107159b00
Gitweb:     http://git.kernel.org/tip/ba28a8505a43074cceab7b5f454cb1a107159b00
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:11:52 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 18:10:45 +0100

ACPI, irq, x86: Get rid of special handling of GSI for ACPI SCI

The IOAPIC has logic to track IOAPIC pin status, so there's no need for
special treatment for GSI used by ACPI SCI in function mp_register_gsi()
and mp_unregister_gsi().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Link: http://lkml.kernel.org/r/1414397531-28254-2-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 1ae52e0..a0e095f 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -408,10 +408,6 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
 
-	/* Don't set up the ACPI SCI because it's already set up */
-	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
-
 	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
 	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
 	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
@@ -424,7 +420,8 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (irq < 0)
 		return irq;
 
-	if (enable_update_mptable)
+	/* Don't set up the ACPI SCI because it's already set up */
+	if (enable_update_mptable && acpi_gbl_FADT.sci_interrupt != gsi)
 		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
 	return irq;
@@ -437,9 +434,6 @@ static void mp_unregister_gsi(u32 gsi)
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return;
 
-	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return;
-
 	irq = mp_map_gsi_to_irq(gsi, 0);
 	if (irq > 0)
 		mp_unmap_irq(irq);
