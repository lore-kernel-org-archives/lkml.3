Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbaGOHeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:34:24 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:45677 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751AbaGOHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:34:22 -0400
From: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
To: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Heiko Carstens <heicars2@linux.vnet.ibm.com>,
        Torsten Duwe <duwe@suse.de>, Hendrik Brueckner <brueckner@de.ibm.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@de.ibm.com>,
        Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>
Subject: 
Date: Tue, 15 Jul 2014 09:34:16 +0200
Message-Id: <1405409656-45117-1-git-send-email-ingo.tuchscherer@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
Author: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071507-8372-0000-0000-0000008960B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: s390/zcrypt: improve device probing for zcrypt adapter cards
    
    Improve device probing process for zcrypt adapters to
    transmit service request during registration process.
    
    Signed-off-by: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 69ef4f8..4038437 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -901,10 +901,15 @@ static int ap_device_probe(struct device *dev)
 	int rc;
 
 	ap_dev->drv = ap_drv;
+
+	spin_lock_bh(&ap_device_list_lock);
+	list_add(&ap_dev->list, &ap_device_list);
+	spin_unlock_bh(&ap_device_list_lock);
+
 	rc = ap_drv->probe ? ap_drv->probe(ap_dev) : -ENODEV;
-	if (!rc) {
+	if (rc) {
 		spin_lock_bh(&ap_device_list_lock);
-		list_add(&ap_dev->list, &ap_device_list);
+		list_del_init(&ap_dev->list);
 		spin_unlock_bh(&ap_device_list_lock);
 	}
 	return rc;

