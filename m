Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3I1LNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 07:13:52 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50149 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3I1LNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 07:13:49 -0400
From: Xiangliang Yu <yxlraid@gmail.com>
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiangliang Yu <yxlraid@gmail.com>
Subject: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset
Date: Sat, 28 Sep 2013 19:13:36 +0800
Message-Id: <1380366816-16221-1-git-send-email-yxlraid@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device is attached to port multiplier, the detection process
look like this:
	ahci_hardreset(link, class, deadline)
	if (class == ATA_DEV_PMP) {
		sata_pmp_attach(dev)    /* will enable FBS */
		sata_pmp_init_links(ap, nr_ports);
		ata_for_each_link(link, ap, EDGE) {
			sata_std_hardreset(link, class, deadline);
			if (link_is_online)
				ahci_softreset(link, class, deadline);
		}
	}
But, according to chapter 9.3.9 in AHCI spec: Prior to issuing software reset,
software shall clear PxCMD.ST to '0' and then clear PxFBS.EN to '0'.

Signed-off-by: Xiangliang Yu <yxlraid@gmail.com>
---
 drivers/ata/libahci.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index acfd0f7..8d024a4 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1267,9 +1267,11 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 {
 	struct ata_port *ap = link->ap;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
 	const char *reason = NULL;
 	unsigned long now, msecs;
 	struct ata_taskfile tf;
+	bool flag = FALSE;
 	int rc;
 
 	DPRINTK("ENTER\n");
@@ -1279,6 +1281,11 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	if (rc && rc != -EOPNOTSUPP)
 		ata_link_warn(link, "failed to reset engine (errno=%d)\n", rc);
 
+	if (!ata_is_host_link(link) && pp->fbs_enabled) {
+		ahci_disable_fbs(ap);
+		flag = TRUE;
+	}
+
 	ata_tf_init(link->device, &tf);
 
 	/* issue the first D2H Register FIS */
@@ -1319,6 +1326,9 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	} else
 		*class = ahci_dev_classify(ap);
 
+	if (flag)
+		ahci_enable_fbs(ap);
+
 	DPRINTK("EXIT, class=%u\n", *class);
 	return 0;
 
-- 
1.7.1

