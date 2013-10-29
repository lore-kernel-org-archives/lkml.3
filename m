Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3J2Kaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:30:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab3J2Kax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:30:53 -0400
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-pci@vger.kernel.org
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, yinghai@kernel.org,
        Knut_Petersen@t-online.de, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 3/3] msi: always unregister ->msi_kset within free_msi_irqs()
Date: Tue, 29 Oct 2013 11:30:32 +0100
Message-Id: <1383042632-7102-4-git-send-email-vfalico@redhat.com>
In-Reply-To: <1383042632-7102-1-git-send-email-vfalico@redhat.com>
References: <1383042632-7102-1-git-send-email-vfalico@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we create and populate ->msi_kset while allocating irqs in
populate_msi_sysfs(), however if it fails and/or we want to free the
entries - we don't always remove it, and we might have problems if we've
failed to allocate irqs and try it again.

To fix that, move the unregister part to free_msi_irqs() and remove already
existing ones. Also, verify if it was actually created - we don't always
call free_msi_irqs() after populate_msi_sysfs().

CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---
 drivers/pci/msi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 0771508..dafda2b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -391,6 +391,11 @@ static void free_msi_irqs(struct pci_dev *dev)
 			kfree(entry);
 		}
 	}
+
+	if (dev->msi_kset) {
+		kset_unregister(dev->msi_kset);
+		dev->msi_kset = NULL;
+	}
 }
 
 static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
@@ -904,8 +909,6 @@ void pci_disable_msi(struct pci_dev *dev)
 
 	pci_msi_shutdown(dev);
 	free_msi_irqs(dev);
-	kset_unregister(dev->msi_kset);
-	dev->msi_kset = NULL;
 }
 EXPORT_SYMBOL(pci_disable_msi);
 
@@ -1002,8 +1005,6 @@ void pci_disable_msix(struct pci_dev *dev)
 
 	pci_msix_shutdown(dev);
 	free_msi_irqs(dev);
-	kset_unregister(dev->msi_kset);
-	dev->msi_kset = NULL;
 }
 EXPORT_SYMBOL(pci_disable_msix);
 
-- 
1.8.4

