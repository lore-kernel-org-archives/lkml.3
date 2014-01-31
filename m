Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbaAaPUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:20:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307AbaAaPHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:04 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 03/34] tg3: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:22 +0100
Message-Id: <21689343cc3c785d2bae8d1187741f404b03c84d.1391172839.git.agordeev@redhat.com>
In-Reply-To: <cover.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/broadcom/tg3.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index e2ca03e..fca9996 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -11361,12 +11361,10 @@ static bool tg3_enable_msix(struct tg3 *tp)
 		msix_ent[i].vector = 0;
 	}
 
-	rc = pci_enable_msix(tp->pdev, msix_ent, tp->irq_cnt);
+	rc = pci_enable_msix_range(tp->pdev, msix_ent, 1, tp->irq_cnt);
 	if (rc < 0) {
 		return false;
-	} else if (rc != 0) {
-		if (pci_enable_msix(tp->pdev, msix_ent, rc))
-			return false;
+	} else if (rc < tp->irq_cnt) {
 		netdev_notice(tp->dev, "Requested %d MSI-X vectors, received %d\n",
 			      tp->irq_cnt, rc);
 		tp->irq_cnt = rc;
-- 
1.7.7.6

