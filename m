Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbbATDLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:11:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:3394 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbbATDLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:11:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442529566"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v7 26/38] x86/irq: Implement irq_chip.irq_write_msi_msg for MSI/DMAR/HPET irq_chips
Date: Tue, 20 Jan 2015 11:08:29 +0800
Message-Id: <1421723321-8386-27-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement irq_chip.irq_write_msi_msg for MSI/DMAR/HPET irq_chips, they
will be used to share common code later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416894816-23245-27-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/msi.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 15429aa112fe..f5b899514634 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -192,6 +192,11 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
+static void dmar_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	dmar_msi_write(data->irq, msg);
+}
+
 static struct irq_chip dmar_msi_controller = {
 	.name			= "DMAR-MSI",
 	.irq_unmask		= dmar_msi_unmask,
@@ -200,6 +205,7 @@ static struct irq_chip dmar_msi_controller = {
 	.irq_set_affinity	= dmar_msi_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
+	.irq_write_msi_msg	= dmar_msi_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -322,6 +328,11 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	return ret;
 }
 
+static void hpet_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	hpet_msi_write(data->handler_data, msg);
+}
+
 static struct irq_chip hpet_msi_controller = {
 	.name = "HPET-MSI",
 	.irq_unmask = hpet_msi_unmask,
@@ -330,6 +341,7 @@ static struct irq_chip hpet_msi_controller = {
 	.irq_set_affinity = hpet_msi_set_affinity,
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg = irq_msi_compose_msg,
+	.irq_write_msi_msg = hpet_msi_write_msg,
 	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
-- 
1.7.10.4

