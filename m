Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3IQBro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab3IQBra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:47:30 -0400
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Veaceslav Falico <vfalico@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/3] msi: always unregister ->msi_kset within free_msi_irqs()
Date: Tue, 17 Sep 2013 03:47:43 +0200
Message-Id: <1379382464-7920-3-git-send-email-vfalico@redhat.com>
In-Reply-To: <1379382464-7920-1-git-send-email-vfalico@redhat.com>
References: <1379382464-7920-1-git-send-email-vfalico@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we create and populate ->msi_kset while allocating irqs in
populate_msi_sysfs(), however if it fails and/or we want to free the
entries - we don't always remove it, and we might have problems if we've
failed to allocate irqs and try it again.

To fix that, move the unregister part to free_msi_irqs() and remove already
existing ones.

CC: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---
 drivers/pci/msi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 14bf578..68da921 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -388,6 +388,9 @@ static void free_msi_irqs(struct pci_dev *dev)
 		list_del(&entry->list);
 		kfree(entry);
 	}
+
+	kset_unregister(dev->msi_kset);
+	dev->msi_kset = NULL;
 }
 
 static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
@@ -917,8 +920,6 @@ void pci_disable_msi(struct pci_dev *dev)
 
 	pci_msi_shutdown(dev);
 	free_msi_irqs(dev);
-	kset_unregister(dev->msi_kset);
-	dev->msi_kset = NULL;
 }
 EXPORT_SYMBOL(pci_disable_msi);
 
@@ -1015,8 +1016,6 @@ void pci_disable_msix(struct pci_dev *dev)
 
 	pci_msix_shutdown(dev);
 	free_msi_irqs(dev);
-	kset_unregister(dev->msi_kset);
-	dev->msi_kset = NULL;
 }
 EXPORT_SYMBOL(pci_disable_msix);
 
-- 
1.8.4

