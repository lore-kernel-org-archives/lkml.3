Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaKZXNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:13:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58508 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaKZXNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:13:10 -0500
Date: Wed, 26 Nov 2014 15:12:22 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-232d47f45baeb4a6784503b9bffd7c8e78b400b1@git.kernel.org>
Cc: gregkh@linuxfoundation.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, tony.luck@intel.com, bp@alien8.de,
        benh@kernel.crashing.org, yinghai@kernel.org, joro@8bytes.org,
        tglx@linutronix.de, konrad.wilk@oracle.com, mingo@kernel.org,
        rdunlap@infradead.org, rjw@rjwysocki.net, bhelgaas@google.com
Reply-To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        hpa@zytor.com, benh@kernel.crashing.org, bp@alien8.de,
        tony.luck@intel.com, jiang.liu@linux.intel.com, tglx@linutronix.de,
        mingo@kernel.org, konrad.wilk@oracle.com, yinghai@kernel.org,
        joro@8bytes.org, rdunlap@infradead.org, bhelgaas@google.com,
        rjw@rjwysocki.net
In-Reply-To: <1416894816-23245-27-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-27-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Implement irq_chip.irq_write_msi_msg for MSI/DMAR/HPET irq_chips
Git-Commit-ID: 232d47f45baeb4a6784503b9bffd7c8e78b400b1
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

Commit-ID:  232d47f45baeb4a6784503b9bffd7c8e78b400b1
Gitweb:     http://git.kernel.org/tip/232d47f45baeb4a6784503b9bffd7c8e78b400b1
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:26 +0100

x86, irq: Implement irq_chip.irq_write_msi_msg for MSI/DMAR/HPET irq_chips

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
 arch/x86/kernel/apic/msi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 15429aa..f5b8995 100644
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
 
