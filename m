Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3CNOtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:49:43 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:45513 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab3CNOtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:49:41 -0400
Subject: [PATCH bugfix 3.9] PCI: Don't try to disable Bus Master on
 disconnected PCI devices
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jeff Garzik <jgarzik@pobox.com>,
        Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 14 Mar 2013 18:49:37 +0400
Message-ID: <20130314144936.10073.2403.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is fix for commit 7897e6022761ace7377f0f784fca059da55f5d71 from v3.9-rc1
("PCI: Disable Bus Master unconditionally in pci_device_shutdown()")
in turn that was fix for b566a22c23327f18ce941ffad0ca907e50a53d41 from v3.5-rc1
("PCI: disable Bus Master on PCI device shutdown")

Unfortunately fixing one bug uncovers another:
->shutdown() callback might switch device to deep sleep state.
PCI config space no longer available after that.

Link: https://lkml.org/lkml/2013/3/12/529
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-and-Tested-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pci-driver.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 1fa1e48..79277fb 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -390,9 +390,10 @@ static void pci_device_shutdown(struct device *dev)
 
 	/*
 	 * Turn off Bus Master bit on the device to tell it to not
-	 * continue to do DMA
+	 * continue to do DMA. Don't touch devices in D3cold or unknown states.
 	 */
-	pci_clear_master(pci_dev);
+	if (pci_dev->current_state <= PCI_D3hot)
+		pci_clear_master(pci_dev);
 }
 
 #ifdef CONFIG_PM

