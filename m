Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3I1UNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:13:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18606 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3I1UNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:13:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: Workaround missing pci_set_master in pci drivers
Date: Sat, 28 Sep 2013 13:13:07 -0700
Message-Id: <1380399187-4962-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380337550.27811.71.camel@pasglop>
References: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BenH found:
| 928bea964827d7824b548c1f8e06eccbbc4d0d7d
| PCI: Delay enabling bridges until they're needed

break PCI on powerpc.  The reason is that the PCIe port driver will
call pci_enable_device() on the bridge, so device enabled (but skip
pci_set_master because pcie_port_auto and no acpi on powerpc ).

Because of that, pci_enable_bridge() later on (called as a result of the
child device driver doing pci_enable_device) will see the bridge as
already enabled and will not call pci_set_master() on it.

Fixed by add checking in pci_enable_bridge, and call pci_set_master
if driver skip that.
That will make the code more robot and wade off problem for missing
pci_set_master in drivers.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1156,8 +1156,14 @@ static void pci_enable_bridge(struct pci
 
 	pci_enable_bridge(dev->bus->self);
 
-	if (pci_is_enabled(dev))
+	if (pci_is_enabled(dev)) {
+		if (!dev->is_busmaster) {
+			dev_warn(&dev->dev, "driver skip pci_set_master, fix it!\n");
+			pci_set_master(dev);
+		}
 		return;
+	}
+
 	retval = pci_enable_device(dev);
 	if (retval)
 		dev_err(&dev->dev, "Error enabling bridge (%d), continuing\n",
