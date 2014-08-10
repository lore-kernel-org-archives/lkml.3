Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaHJUBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 16:01:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36098 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHJUBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 16:01:13 -0400
Date: Mon, 11 Aug 2014 01:31:08 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] NFC: st21nfcb: drop kfree of devm_kzalloc's data
Message-ID: <20140810200107.GA4170@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kfree to free data allocated with devm_kzalloc causes double frees.

The Coccinelle semantic patch that fixes this problem is as follows:

// <smpl>
@@
expression x;
@@

x = devm_kzalloc(...)
...
?-kfree(x);
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/nfc/st21nfcb/st21nfcb.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/nfc/st21nfcb/st21nfcb.c b/drivers/nfc/st21nfcb/st21nfcb.c
index 4d95863..b0c4a0f9 100644
--- a/drivers/nfc/st21nfcb/st21nfcb.c
+++ b/drivers/nfc/st21nfcb/st21nfcb.c
@@ -94,8 +94,7 @@ int st21nfcb_nci_probe(struct llt_ndlc *ndlc, int phy_headroom,
 					phy_headroom, phy_tailroom);
 	if (!ndlc->ndev) {
 		pr_err("Cannot allocate nfc ndev\n");
-		r = -ENOMEM;
-		goto err_alloc_ndev;
+		return -ENOMEM;
 	}
 	info->ndlc = ndlc;
 
@@ -109,19 +108,14 @@ int st21nfcb_nci_probe(struct llt_ndlc *ndlc, int phy_headroom,
 err_regdev:
 	nci_free_device(ndlc->ndev);
 
-err_alloc_ndev:
-	kfree(info);
 	return r;
 }
 EXPORT_SYMBOL_GPL(st21nfcb_nci_probe);
 
 void st21nfcb_nci_remove(struct nci_dev *ndev)
 {
-	struct st21nfcb_nci_info *info = nci_get_drvdata(ndev);
-
 	nci_unregister_device(ndev);
 	nci_free_device(ndev);
-	kfree(info);
 }
 EXPORT_SYMBOL_GPL(st21nfcb_nci_remove);
 
-- 
1.9.1

