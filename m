Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab3IZOLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:11:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab3IZOLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:11:06 -0400
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-pci@vger.kernel.org
Cc: Veaceslav Falico <vfalico@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] msi: remove useless kobject_del() in free_msi_irqs()
Date: Thu, 26 Sep 2013 16:11:15 +0200
Message-Id: <1380204675-18238-3-git-send-email-vfalico@redhat.com>
In-Reply-To: <1380204675-18238-1-git-send-email-vfalico@redhat.com>
References: <1380204675-18238-1-git-send-email-vfalico@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need to kobject_put() on removal (which will, eventually, call
kobject_del()). kobject_del() should be implicitly used only on circular
references (per documentation), however it's not the case here.

CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---
 drivers/pci/msi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index dafda2b..d62c468 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -384,12 +384,10 @@ static void free_msi_irqs(struct pci_dev *dev)
 		 * kobject->release will take care of freeing the entry via
 		 * msi_kobj_release().
 		 */
-		if (entry->kobj.parent) {
-			kobject_del(&entry->kobj);
+		if (entry->kobj.parent)
 			kobject_put(&entry->kobj);
-		} else {
+		else
 			kfree(entry);
-		}
 	}
 
 	if (dev->msi_kset) {
-- 
1.8.4

