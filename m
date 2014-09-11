Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaIKODK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:03:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:38216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbaIKODD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:03:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384739371"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part2 v1 16/21] x86, irq: Directly call native_compose_msi_msg() for DMAR IRQ
Date: Thu, 11 Sep 2014 22:03:43 +0800
Message-Id: <1410444228-3134-17-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMAR interrupt won't be remapped by interrupt remapping hardware,
so directly call native_compose_msi_msg() for DMAR IRQ to compose MSI
message data. This will help to simplify MSI code later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 5696703271af..4f2a349ccef0 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -375,12 +375,10 @@ static struct irq_chip dmar_msi_type = {
 
 int arch_setup_dmar_msi(unsigned int irq)
 {
-	int ret;
 	struct msi_msg msg;
+	struct irq_cfg *cfg = irq_cfg(irq);
 
-	ret = msi_compose_msg(NULL, irq, &msg, -1);
-	if (ret < 0)
-		return ret;
+	native_compose_msi_msg(NULL, irq, cfg->dest_apicid, &msg, -1);
 	dmar_msi_write(irq, &msg);
 	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
 				      "edge");
-- 
1.7.10.4

