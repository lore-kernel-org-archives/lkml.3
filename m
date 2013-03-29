Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3C2WOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 18:14:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27691 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab3C2WOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 18:14:18 -0400
Message-ID: <1364595238.26110.3.camel@concerto>
Subject: [PATCH] Avoid unnecessary calls to sandybridge mce decoder on
 incompatible platform
From: Khalid Aziz <khalid.aziz@oracle.com>
To: mchehab@redhat.com, dougthompson@xmission.com
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        khalid@gonehiking.org
Date: Fri, 29 Mar 2013 16:13:58 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MCE decoder to MCE decode chain in probe routine instead
of in init routine so that handler is not called unless the
driver is indeed running on SandyBridge.


Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---
 drivers/edac/sb_edac.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 57244f9..6f05ffd 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1724,6 +1724,7 @@ static int sbridge_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto fail1;
 	}
 
+	mce_register_decode_chain(&sbridge_mce_dec);
 	sbridge_printk(KERN_INFO, "Driver loaded.\n");
 
 	mutex_unlock(&sbridge_edac_lock);
@@ -1803,10 +1804,8 @@ static int __init sbridge_init(void)
 
 	pci_rc = pci_register_driver(&sbridge_driver);
 
-	if (pci_rc >= 0) {
-		mce_register_decode_chain(&sbridge_mce_dec);
+	if (pci_rc >= 0)
 		return 0;
-	}
 
 	sbridge_printk(KERN_ERR, "Failed to register device with error %d.\n",
 		      pci_rc);
-- 
1.7.10.4



