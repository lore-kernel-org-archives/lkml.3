Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148Ab3BNRfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:35:17 -0500
Received: from xes-mad.com ([216.165.139.218]:17914 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759993Ab3BNRfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:35:12 -0500
Date: Thu, 14 Feb 2013 11:35:04 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lpc_ich: use devres API to allocate private data
Message-ID: <9be5e8ee-d1b9-4509-b147-879281e10efc@zimbra>
In-Reply-To: <774339a2-e7cc-4204-a935-0a1b59e2ece8@zimbra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC24 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
---
 drivers/mfd/lpc_ich.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index a0cfdf9..1264b68 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -878,7 +878,8 @@ static int lpc_ich_probe(struct pci_dev *dev,
 	int ret;
 	bool cell_added = false;
 
-	priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
+	priv = devm_kzalloc(&dev->dev,
+			    sizeof(struct lpc_ich_priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -914,7 +915,6 @@ static int lpc_ich_probe(struct pci_dev *dev,
 		dev_warn(&dev->dev, "No MFD cells added\n");
 		lpc_ich_restore_config_space(dev);
 		pci_set_drvdata(dev, NULL);
-		kfree(priv);
 		return -ENODEV;
 	}
 
@@ -923,12 +923,9 @@ static int lpc_ich_probe(struct pci_dev *dev,
 
 static void lpc_ich_remove(struct pci_dev *dev)
 {
-	void *priv = pci_get_drvdata(dev);
-
 	mfd_remove_devices(&dev->dev);
 	lpc_ich_restore_config_space(dev);
 	pci_set_drvdata(dev, NULL);
-	kfree(priv);
 }
 
 static struct pci_driver lpc_ich_driver = {
-- 
1.7.9.5
