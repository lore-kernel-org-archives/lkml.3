Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaKYFva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:51:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:10479 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaKYFv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:51:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,453,1413270000"; 
   d="scan'208";a="627797526"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v6 03/27] x86, hpet: Use new irqdomain interfaces to allocate/free IRQ
Date: Tue, 25 Nov 2014 13:53:12 +0800
Message-Id: <1416894816-23245-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new irqdomain interfaces to allocate/free IRQ for HPET, so we could
kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/hpet.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 319bcb9372fe..24db2d33fab7 100644
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
-- 
1.7.10.4

