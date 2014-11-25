Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaKYFxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:53:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:56278 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbaKYFxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:53:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,453,1413270000"; 
   d="scan'208";a="627798132"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v6 14/27] x86, irq: Directly call native_compose_msi_msg() for DMAR IRQ
Date: Tue, 25 Nov 2014 13:53:23 +0800
Message-Id: <1416894816-23245-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com>
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
index e82ab7973477..fa2dd6ebcaea 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -259,12 +259,10 @@ static struct irq_chip dmar_msi_type = {
 
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

