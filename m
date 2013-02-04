Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3BDL4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:56:05 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:56171 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab3BDL4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:03 -0500
Subject: [PATCH v2 2/7] PCI: don't touch enable_cnt in pci_device_shutdown()
To: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Khalid Aziz <khalid.aziz@hp.com>,
        Andi Kleen <ak@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg@redhat.com>
Date: Mon, 04 Feb 2013 15:55:58 +0400
Message-ID: <20130204115557.5569.9748.stgit@zurg>
In-Reply-To: <20130204115246.5569.85829.stgit@zurg>
References: <20130204115246.5569.85829.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

comment in commit b566a22c23327f18ce941ffad0ca907e50a53d41
("PCI: disable Bus Master on PCI device shutdown") says:
| Disable Bus Master bit on the device in pci_device_shutdown() to ensure PCI
| devices do not continue to DMA data after shutdown.  This can cause memory
| corruption in case of a kexec where the current kernel shuts down and
| transfers control to a new kernel while a PCI device continues to DMA to
| memory that does not belong to it any more in the new kernel.

Seems like pci_clear_master() must be used here instead of pci_disable_device(),
because it disables Bus Muster unconditionally and doesn't changes enable_cnt.

Matthew Garrett and Alan Cox said (see LKML link below) that clearing bus-master
for all PCI devices may lead to unpredictable consequences, some devices ignores
this bit and continues DMA, some of them hang after that or crash whole system.
Probably we should leave here only warning and disable bus-mastering for each
driver individually in ->shutdown() callback.

Link: https://lkml.org/lkml/2012/6/6/278
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Khalid Aziz <khalid.aziz@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
---
 drivers/pci/pci-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f79cbcd..dc5bdce 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -392,7 +392,7 @@ static void pci_device_shutdown(struct device *dev)
 	 * Turn off Bus Master bit on the device to tell it to not
 	 * continue to do DMA
 	 */
-	pci_disable_device(pci_dev);
+	pci_clear_master(pci_dev);
 }
 
 #ifdef CONFIG_PM

