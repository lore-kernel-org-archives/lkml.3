Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab3IZOLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab3IZOLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:11:09 -0400
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-pci@vger.kernel.org
Cc: Veaceslav Falico <vfalico@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] pci: remove redundant pci_dev_get/put() on kobject (un)register
Date: Thu, 26 Sep 2013 16:11:13 +0200
Message-Id: <1380204675-18238-1-git-send-email-vfalico@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we're pci_dev_get/put()-ing pci device on every kobject
creation/removal. It's useless per se - the kobject is part of the device
itself, so it should be removed when there are no users of the pdev, and is
not a user of it.

CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---
 drivers/pci/msi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5d70f49..0771508 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -511,7 +511,6 @@ static void msi_kobj_release(struct kobject *kobj)
 {
 	struct msi_desc *entry = to_msi_desc(kobj);
 
-	pci_dev_put(entry->dev);
 	kfree(entry);
 }
 
@@ -534,13 +533,10 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
 	list_for_each_entry(entry, &pdev->msi_list, list) {
 		kobj = &entry->kobj;
 		kobj->kset = pdev->msi_kset;
-		pci_dev_get(pdev);
 		ret = kobject_init_and_add(kobj, &msi_irq_ktype, NULL,
 				     "%u", entry->irq);
-		if (ret) {
-			pci_dev_put(pdev);
+		if (ret)
 			return ret;
-		}
 	}
 
 	return 0;
-- 
1.8.4

