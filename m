Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaGNSWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:22:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaGNSW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:22:28 -0400
Date: Mon, 14 Jul 2014 11:22:10 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-a4355e6749113d424cd15852c73e22c1ef1bb004@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, jiang.liu@linux.intel.com,
        hpa@zytor.com, mingo@kernel.org, yinghai@kernel.org,
        david.a.cohen@linux.intel.com, tony.luck@intel.com, tglx@linutronix.de,
        feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        david.a.cohen@linux.intel.com, tony.luck@intel.com, tglx@linutronix.de,
        feng.tang@intel.com
In-Reply-To: <1403490643-26187-1-git-send-email-jiang.liu@linux.intel.com>
References: <1403490643-26187-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: intel-mid: Use the new io_apic interfaces
Git-Commit-ID: a4355e6749113d424cd15852c73e22c1ef1bb004
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

Commit-ID:  a4355e6749113d424cd15852c73e22c1ef1bb004
Gitweb:     http://git.kernel.org/tip/a4355e6749113d424cd15852c73e22c1ef1bb004
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 23 Jun 2014 10:30:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Jul 2014 20:17:09 +0200

x86: intel-mid: Use the new io_apic interfaces

Commit 9f354b0252b8 "x86, irq: Clean up unused IOAPIC interface" kills
interface io_apic_set_pci_routing(), so change arch/x86/platform/
intel-mid/device_libs/platform_wdt.c to use new interfaces.

Due to hardware resource restriction, this patch only passes compilation
without functional tests.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: David Cohen <david.a.cohen@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Tang Feng <feng.tang@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/1403490643-26187-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 .../platform/intel-mid/device_libs/platform_wdt.c  | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
index 973cf3b..0b283d4 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
@@ -26,28 +26,18 @@ static struct platform_device wdt_dev = {
 
 static int tangier_probe(struct platform_device *pdev)
 {
-	int ioapic;
-	int irq;
+	int gsi;
 	struct intel_mid_wdt_pdata *pdata = pdev->dev.platform_data;
-	struct io_apic_irq_attr irq_attr = { 0 };
 
 	if (!pdata)
 		return -EINVAL;
 
-	irq = pdata->irq;
-	ioapic = mp_find_ioapic(irq);
-	if (ioapic >= 0) {
-		int ret;
-		irq_attr.ioapic = ioapic;
-		irq_attr.ioapic_pin = irq;
-		irq_attr.trigger = 1;
-		/* irq_attr.polarity = 0; -> Active high */
-		ret = io_apic_set_pci_routing(NULL, irq, &irq_attr);
-		if (ret)
-			return ret;
-	} else {
+	/* IOAPIC builds identity mapping between GSI and IRQ on MID */
+	gsi = pdata->irq;
+	if (mp_set_gsi_attr(gsi, 1, 0, cpu_to_node(0)) ||
+	    mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC) <= 0) {
 		dev_warn(&pdev->dev, "cannot find interrupt %d in ioapic\n",
-			 irq);
+			 gsi);
 		return -EINVAL;
 	}
 
