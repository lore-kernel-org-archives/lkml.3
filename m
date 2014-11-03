Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaKCLKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:10:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaKCLK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:10:28 -0500
Date: Mon, 3 Nov 2014 02:58:55 -0800
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-8cda974ab278dd8d4a9024085535f71175ddf38d@git.kernel.org>
Cc: rdunlap@infradead.org, sebastian@breakpoint.cc, benh@kernel.crashing.org,
        konrad.wilk@oracle.com, jiang.liu@linux.intel.com, mingo@kernel.org,
        bhelgaas@google.com, hpa@zytor.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org, bp@alien8.de, rjw@rjwysocki.net,
        yinghai@kernel.org, joro@8bytes.org, tony.luck@intel.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        grant.likely@linaro.org
Reply-To: tglx@linutronix.de, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, rjw@rjwysocki.net, gregkh@linuxfoundation.org,
        tony.luck@intel.com, hpa@zytor.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org, bp@alien8.de, rdunlap@infradead.org,
        sebastian@breakpoint.cc, konrad.wilk@oracle.com,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        bhelgaas@google.com, mingo@kernel.org
In-Reply-To: <1414387308-27148-10-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-10-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Split out alloc_ioapic_save_registers()
Git-Commit-ID: 8cda974ab278dd8d4a9024085535f71175ddf38d
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

Commit-ID:  8cda974ab278dd8d4a9024085535f71175ddf38d
Gitweb:     http://git.kernel.org/tip/8cda974ab278dd8d4a9024085535f71175ddf38d
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Oct 2014 13:21:39 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 11:56:07 +0100

x86, irq: Split out alloc_ioapic_save_registers()

Split out alloc_ioapic_save_registers() from early_irq_init(),
so it could be used for ioapic hotplug later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414387308-27148-10-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1183d54..acaee90 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -237,6 +237,19 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
 }
 
+static void alloc_ioapic_saved_registers(int idx)
+{
+	size_t size;
+
+	if (ioapics[idx].saved_registers)
+		return;
+
+	size = sizeof(struct IO_APIC_route_entry) * ioapics[idx].nr_registers;
+	ioapics[idx].saved_registers = kzalloc(size, GFP_KERNEL);
+	if (!ioapics[idx].saved_registers)
+		pr_err("IOAPIC %d: suspend/resume impossible!\n", idx);
+}
+
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
@@ -245,13 +258,8 @@ int __init arch_early_irq_init(void)
 	if (!nr_legacy_irqs())
 		io_apic_irqs = ~0UL;
 
-	for_each_ioapic(i) {
-		ioapics[i].saved_registers =
-			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				ioapics[i].nr_registers, GFP_KERNEL);
-		if (!ioapics[i].saved_registers)
-			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
-	}
+	for_each_ioapic(i)
+		alloc_ioapic_saved_registers(i);
 
 	/*
 	 * For legacy IRQ's, start with assigning irq0 to irq15 to
