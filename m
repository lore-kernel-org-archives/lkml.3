Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3IZJ7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:59:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547Ab3IZJ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:59:35 -0400
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-pci@vger.kernel.org
Cc: Veaceslav Falico <vfalico@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] msi: free msi_desc entry only after we've released the kobject
Date: Thu, 26 Sep 2013 11:59:51 +0200
Message-Id: <1380189591-1368-1-git-send-email-vfalico@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we first do kobject_put(&entry->kobj) and the kfree(entry),
however kobject_put() doesn't guarantee us that it was the last reference
and that the kobj isn't used currently by someone else, so after we
kfree(entry) with the struct kobject - other users will begin using the
freed memory, instead of the actual kobject.

Fix this by using the kobject->release callback, which is called last when
the kobject is indeed not used and is cleaned up - it's msi_kobj_release(),
which can do the kfree(entry) safely (kobject_put/cleanup doesn't use the
kobj itself after ->release() was called, so we're safe).

In case we've failed to create the sysfs directories - just kfree()
it - cause we don't have the kobjects attached.

Also, remove the same functionality from populate_msi_sysfs(), cause on
failure we anyway call free_msi_irqs(), which will take care of all the
kobjects properly.

And add the forgotten pci_dev_put(pdev) in case of failure to register the
kobject in populate_msi_sysfs().

CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---

Notes:
    v1  -> v2:
    Make it as a standalone patch, which is a bugfix, and add the forgotten
    pci_dev_put() so that it won't break bisecting. The pci_dev_put() will
    go away anyway in the following patchset, which cleans removes
    kobject_del and useless pci_dev_get/put().  Rebased on linux-pci/next.

 drivers/pci/msi.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d5f90d6..5d70f49 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -374,19 +374,22 @@ static void free_msi_irqs(struct pci_dev *dev)
 				iounmap(entry->mask_base);
 		}
 
+		list_del(&entry->list);
+
 		/*
 		 * Its possible that we get into this path
 		 * When populate_msi_sysfs fails, which means the entries
 		 * were not registered with sysfs.  In that case don't
-		 * unregister them.
+		 * unregister them, and just free. Otherwise the
+		 * kobject->release will take care of freeing the entry via
+		 * msi_kobj_release().
 		 */
 		if (entry->kobj.parent) {
 			kobject_del(&entry->kobj);
 			kobject_put(&entry->kobj);
+		} else {
+			kfree(entry);
 		}
-
-		list_del(&entry->list);
-		kfree(entry);
 	}
 }
 
@@ -509,6 +512,7 @@ static void msi_kobj_release(struct kobject *kobj)
 	struct msi_desc *entry = to_msi_desc(kobj);
 
 	pci_dev_put(entry->dev);
+	kfree(entry);
 }
 
 static struct kobj_type msi_irq_ktype = {
@@ -522,7 +526,6 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
 	struct msi_desc *entry;
 	struct kobject *kobj;
 	int ret;
-	int count = 0;
 
 	pdev->msi_kset = kset_create_and_add("msi_irqs", NULL, &pdev->dev.kobj);
 	if (!pdev->msi_kset)
@@ -534,23 +537,13 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
 		pci_dev_get(pdev);
 		ret = kobject_init_and_add(kobj, &msi_irq_ktype, NULL,
 				     "%u", entry->irq);
-		if (ret)
-			goto out_unroll;
-
-		count++;
+		if (ret) {
+			pci_dev_put(pdev);
+			return ret;
+		}
 	}
 
 	return 0;
-
-out_unroll:
-	list_for_each_entry(entry, &pdev->msi_list, list) {
-		if (!count)
-			break;
-		kobject_del(&entry->kobj);
-		kobject_put(&entry->kobj);
-		count--;
-	}
-	return ret;
 }
 
 /**
-- 
1.8.4

