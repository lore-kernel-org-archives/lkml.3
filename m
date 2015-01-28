Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbbA2JB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:28 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757058AbbA2JBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 060/176] tg3: tg3_disable_ints using uninitialized mailbox value to disable interrupts
Date: Wed, 28 Jan 2015 15:28:10 +0100
Message-Id: <e6f7e1dc44d6cbc3ca844b8d1f6c0bab6672f77a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prashant Sreedharan <prashant@broadcom.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/broadcom/tg3.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 8d45dce7cfdb..98ded21c37b2 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17572,23 +17572,6 @@ static int tg3_init_one(struct pci_dev *pdev,
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
@@ -17633,6 +17616,23 @@ static int tg3_init_one(struct pci_dev *pdev,
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
2.2.2

