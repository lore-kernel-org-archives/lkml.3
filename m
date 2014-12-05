Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaLEHfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:35:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:58912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaLEHf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:35:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="425384878"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: bhelgaas@google.com, rjw@rjwysocki.net, mister.freeman@laposte.net,
        aaron.lu@intel.com, tj@kernel.org, chuansheng.liu@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] PCI: Add disabling pm async quirk for JMicron chips
Date: Fri,  5 Dec 2014 15:17:37 +0800
Message-Id: <1417763857-11993-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some history from
commit e6b7e41cdd8c ("ata: Disabling the async PM for JMicron chip 363/361")
==
Since v3.15, the PM feature of async noirq
commit 76569faa62c4 ("PM / sleep: Asynchronous threads for resume_noirq") is introduced.

Then Jay hit one system resuming issue that one of the JMicron controller
can not be powered up successfully.

His device tree is like below:
                 +-1c.4-[02]--+-00.0  JMicron Technology Corp. JMB363 SATA/IDE Controller
                 |            \-00.1  JMicron Technology Corp. JMB363 SATA/IDE Controller

After investigation, we found the the Micron chip 363 included
one SATA controller(0000:02:00.0) and one PATA controller(0000:02:00.1),
these two controllers do not have parent-children relationship,
but the PATA controller only can be powered on after the SATA controller
has finished the powering on.

If we enabled the async noirq(), then the below error is hit during noirq
phase:
pata_jmicron 0000:02:00.1: Refused to change power state, currently in D3
Here for JMicron chip 363/361, we need forcedly to disable the async method.

Bug detail: https://bugzilla.kernel.org/show_bug.cgi?id=81551
==

After that, Barto reported the same issue, but his Jmicron chip is JMB368,
so it can not be covered by
commit e6b7e41cdd8c ("ata: Disabling the async PM for JMicron chip 363/361").

Bug link:
https://bugzilla.kernel.org/show_bug.cgi?id=84861

Here we think Jmicron chips have the same issue as describled in
commit e6b7e41cdd8c ("ata: Disabling the async PM for JMicron chip 363/361"),

so here add one quirk to disable the JMicron chips' PM async feature.

Cc: stable@vger.kernel.org # 3.15+
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/pci/quirks.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 90acb32..1963080 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1501,6 +1501,21 @@ static void quirk_jmicron_ata(struct pci_dev *pdev)
 	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &class);
 	pdev->class = class >> 8;
 }
+
+/*
+ * For JMicron chips, we need to disable the async_suspend method, otherwise
+ * they will hit the power-on issue when doing device resume, add one quirk
+ * solution to disable the async_suspend method.
+ */
+static void pci_async_suspend_fixup(struct pci_dev *pdev)
+{
+	    /*
+		 * disabling the async_suspend method for JMicron chips to
+		 * avoid device resuming issue.
+		 */
+	    device_disable_async_suspend(&pdev->dev);
+}
+
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB362, quirk_jmicron_ata);
@@ -1519,6 +1534,8 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB3
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB369, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_JMICRON, PCI_ANY_ID,
+		pci_async_suspend_fixup);
 
 #endif
 
-- 
1.7.9.5

