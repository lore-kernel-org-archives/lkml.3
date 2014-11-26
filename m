Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaKZXHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:07:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaKZXHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:07:21 -0500
Date: Wed, 26 Nov 2014 15:06:24 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-654eda5170093e5dc6fe63c044be390b933b172c@git.kernel.org>
Cc: benh@kernel.crashing.org, rjw@rjwysocki.net, tony.luck@intel.com,
        tglx@linutronix.de, hpa@zytor.com, jiang.liu@linux.intel.com,
        yinghai@kernel.org, luto@amacapital.net, bp@alien8.de,
        mingo@kernel.org, joro@8bytes.org, rdunlap@infradead.org,
        konrad.wilk@oracle.com, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org
Reply-To: rjw@rjwysocki.net, tony.luck@intel.com, tglx@linutronix.de,
        benh@kernel.crashing.org, mingo@kernel.org, joro@8bytes.org,
        rdunlap@infradead.org, jiang.liu@linux.intel.com, hpa@zytor.com,
        bp@alien8.de, luto@amacapital.net, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org,
        srivatsa.bhat@linux.vnet.ibm.com
In-Reply-To: <1416894816-23245-4-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-4-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, hpet:
  Use new irqdomain interfaces to allocate/free IRQ
Git-Commit-ID: 654eda5170093e5dc6fe63c044be390b933b172c
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

Commit-ID:  654eda5170093e5dc6fe63c044be390b933b172c
Gitweb:     http://git.kernel.org/tip/654eda5170093e5dc6fe63c044be390b933b172c
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:12 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:24 +0100

x86, hpet: Use new irqdomain interfaces to allocate/free IRQ

Use new irqdomain interfaces to allocate/free IRQ for HPET, so we could
kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ later.

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
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/1416894816-23245-4-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/hpet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 319bcb9..24db2d3 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -11,6 +11,7 @@
 #include <linux/cpu.h>
 #include <linux/pm.h>
 #include <linux/io.h>
+#include <linux/irqdomain.h>
 
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
@@ -476,7 +477,7 @@ static int hpet_msi_next_event(unsigned long delta,
 static int hpet_setup_msi_irq(unsigned int irq)
 {
 	if (x86_msi.setup_hpet_msi(irq, hpet_blockid)) {
-		irq_free_hwirq(irq);
+		irq_domain_free_irqs(irq, 1);
 		return -EINVAL;
 	}
 	return 0;
@@ -484,9 +485,10 @@ static int hpet_setup_msi_irq(unsigned int irq)
 
 static int hpet_assign_irq(struct hpet_dev *dev)
 {
-	unsigned int irq = irq_alloc_hwirq(-1);
+	int irq;
 
-	if (!irq)
+	irq = irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
+	if (irq <= 0)
 		return -EINVAL;
 
 	irq_set_handler_data(irq, dev);
