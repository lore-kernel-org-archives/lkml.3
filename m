Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaLSOEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:04:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45823 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaLSOEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:04:14 -0500
Date: Fri, 19 Dec 2014 06:03:09 -0800
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-7e8994196a5196fbe6f344ff9f0616e08d440506@git.kernel.org>
Cc: benh@kernel.crashing.org, bhelgaas@google.com, sebastian@breakpoint.cc,
        yinghai@kernel.org, joro@8bytes.org, mingo@kernel.org,
        grant.likely@linaro.org, rdunlap@infradead.org, tony.luck@intel.com,
        jiang.liu@linux.intel.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com, hpa@zytor.com,
        gregkh@linuxfoundation.org, rjw@rjwysocki.net, tglx@linutronix.de,
        bp@alien8.de
Reply-To: benh@kernel.crashing.org, yinghai@kernel.org, bhelgaas@google.com,
        sebastian@breakpoint.cc, joro@8bytes.org, mingo@kernel.org,
        rdunlap@infradead.org, grant.likely@linaro.org, tony.luck@intel.com,
        jiang.liu@linux.intel.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com, hpa@zytor.com,
        rjw@rjwysocki.net, gregkh@linuxfoundation.org, tglx@linutronix.de,
        bp@alien8.de
In-Reply-To: <1414387308-27148-10-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-10-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Split out alloc_ioapic_save_registers()
Git-Commit-ID: 7e8994196a5196fbe6f344ff9f0616e08d440506
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

Commit-ID:  7e8994196a5196fbe6f344ff9f0616e08d440506
Gitweb:     http://git.kernel.org/tip/7e8994196a5196fbe6f344ff9f0616e08d440506
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Oct 2014 13:21:39 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:15 +0100

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
index a157b66..654b69b 100644
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
