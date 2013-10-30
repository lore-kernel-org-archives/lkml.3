Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3J3Q1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab3J3Q1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:33 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 09/12] sb_edac: enable multiple PCI id tables to be used
Date: Wed, 30 Oct 2013 12:27:03 -0400
Message-Id: <1383150426-24730-10-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to allow separated PCI id tables for Sandy Bridge and Ivy
Bridge.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index bf305a2..3e07c28 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1088,12 +1088,6 @@ static void sbridge_put_all_devices(void)
 	}
 }
 
-/*
- *	sbridge_get_all_devices	Find and perform 'get' operation on the MCH's
- *			device/functions we want to reference for this driver
- *
- *			Need to 'get' device 16 func 1 and func 2
- */
 static int sbridge_get_onedevice(struct pci_dev **prev,
 				 u8 *num_mc,
 				 const struct pci_id_table *table,
@@ -1195,11 +1189,21 @@ static int sbridge_get_onedevice(struct pci_dev **prev,
 	return 0;
 }
 
-static int sbridge_get_all_devices(u8 *num_mc)
+/*
+ * sbridge_get_all_devices - Find and perform 'get' operation on the MCH's
+ *			     device/functions we want to reference for this driver.
+ *			     Need to 'get' device 16 func 1 and func 2.
+ * @num_mc: pointer to the memory controllers count, to be incremented in case
+ * 	    of success.
+ * @table: model specific table
+ *
+ * returns 0 in case of success or error code
+ */
+static int sbridge_get_all_devices(u8 *num_mc,
+				   const struct pci_id_table *table)
 {
 	int i, rc;
 	struct pci_dev *pdev = NULL;
-	const struct pci_id_table *table = pci_dev_descr_sbridge_table;
 
 	while (table && table->descr) {
 		for (i = 0; i < table->n_devs; i++) {
@@ -1719,7 +1723,7 @@ static int sbridge_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	probed++;
 
-	rc = sbridge_get_all_devices(&num_mc);
+	rc = sbridge_get_all_devices(&num_mc, pci_dev_descr_sbridge_table);
 	if (unlikely(rc < 0))
 		goto fail0;
 	mc = 0;
-- 
1.7.1

