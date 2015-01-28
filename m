Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322AbbA2Chn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:37:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47004 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbbA2Chh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 005/139] tg3: tg3_disable_ints using uninitialized mailbox value to disable interrupts
Date: Wed, 28 Jan 2015 14:19:08 -0800
Message-Id: <1422483682-15393-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashant Sreedharan <prashant@broadcom.com>

[ Upstream commit 05b0aa579397b734f127af58e401a30784a1e315 ]

During driver load in tg3_init_one, if the driver detects DMA activity before
intializing the chip tg3_halt is called. As part of tg3_halt interrupts are
disabled using routine tg3_disable_ints. This routine was using mailbox value
which was not initialized (default value is 0). As a result driver was writing
0x00000001 to pci config space register 0, which is the vendor id / device id.

This driver bug was exposed because of the commit a7877b17a667 (PCI: Check only
the Vendor ID to identify Configuration Request Retry). Also this issue is only
seen in older generation chipsets like 5722 because config space write to offset
0 from driver is possible. The newer generation chips ignore writes to offset 0.
Also without commit a7877b17a667, for these older chips when a GRC reset is
issued the Bootcode would reprogram the vendor id/device id, which is the reason
this bug was masked earlier.

Fixed by initializing the interrupt mailbox registers before calling tg3_halt.

Please queue for -stable.

Reported-by: Nils Holland <nholland@tisys.org>
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Prashant Sreedharan <prashant@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index bbb9bd9..fd16844 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17566,23 +17566,6 @@ static int tg3_init_one(struct pci_dev *pdev,
 		goto err_out_apeunmap;
 	}
 
-	/*
-	 * Reset chip in case UNDI or EFI driver did not shutdown
-	 * DMA self test will enable WDMAC and we'll see (spurious)
-	 * pending DMA on the PCI bus at that point.
-	 */
-	if ((tr32(HOSTCC_MODE) & HOSTCC_MODE_ENABLE) ||
-	    (tr32(WDMAC_MODE) & WDMAC_MODE_ENABLE)) {
-		tw32(MEMARB_MODE, MEMARB_MODE_ENABLE);
-		tg3_halt(tp, RESET_KIND_SHUTDOWN, 1);
-	}
-
-	err = tg3_test_dma(tp);
-	if (err) {
-		dev_err(&pdev->dev, "DMA engine test failed, aborting\n");
-		goto err_out_apeunmap;
-	}
-
 	intmbx = MAILBOX_INTERRUPT_0 + TG3_64BIT_REG_LOW;
 	rcvmbx = MAILBOX_RCVRET_CON_IDX_0 + TG3_64BIT_REG_LOW;
 	sndmbx = MAILBOX_SNDHOST_PROD_IDX_0 + TG3_64BIT_REG_LOW;
@@ -17627,6 +17610,23 @@ static int tg3_init_one(struct pci_dev *pdev,
 			sndmbx += 0xc;
 	}
 
+	/*
+	 * Reset chip in case UNDI or EFI driver did not shutdown
+	 * DMA self test will enable WDMAC and we'll see (spurious)
+	 * pending DMA on the PCI bus at that point.
+	 */
+	if ((tr32(HOSTCC_MODE) & HOSTCC_MODE_ENABLE) ||
+	    (tr32(WDMAC_MODE) & WDMAC_MODE_ENABLE)) {
+		tw32(MEMARB_MODE, MEMARB_MODE_ENABLE);
+		tg3_halt(tp, RESET_KIND_SHUTDOWN, 1);
+	}
+
+	err = tg3_test_dma(tp);
+	if (err) {
+		dev_err(&pdev->dev, "DMA engine test failed, aborting\n");
+		goto err_out_apeunmap;
+	}
+
 	tg3_init_coal(tp);
 
 	pci_set_drvdata(pdev, dev);
-- 
1.9.1

