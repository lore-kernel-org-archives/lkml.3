Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637Ab3EGEbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:31:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561Ab3EGEZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:55 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=EIy5b9oFKFwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6ScgiKT_VsAA:10 a=Q-fNiiVtAAAA:8 a=J1Y8HTJGAAAA:8 a=WcIMHjBjCJjNHtekeVEA:9 a=Rm3zHy7k_-gA:10 a=lcTMV_K9oDIA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035853.100062783@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [073/126] tg3: Add 57766 device support.
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0073-tg3-Add-57766-device-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

[ Upstream commit d3f677afb8076d09d090ff0a5d1229c9dd9f136e ]

The patch also adds a couple of fixes

 - For the 57766 and non Ax versions of 57765, bootcode needs to setup
   the PCIE Fast Training Sequence (FTS) value to prevent transmit hangs.
   Unfortunately, it does not have enough room in the selfboot case (i.e.
   devices with no NVRAM).  The driver needs to implement this.

 - For performance reasons, the 2k DMA engine mode on the 57766 should
   be enabled and dma size limited to 2k for standard sized packets.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/broadcom/tg3.c |   18 +++++++++++++++++-
 drivers/net/ethernet/broadcom/tg3.h |    2 ++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 440e963..fbc21a9 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -301,6 +301,7 @@ static DEFINE_PCI_DEVICE_TABLE(tg3_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_5719)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_5720)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_57762)},
+	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_57766)},
 	{PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, PCI_DEVICE_ID_SYSKONNECT_9DXX)},
 	{PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, PCI_DEVICE_ID_SYSKONNECT_9MXX)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ALTIMA, PCI_DEVICE_ID_ALTIMA_AC1000)},
@@ -8784,7 +8785,14 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 		}
 
 		if (GET_CHIP_REV(tp->pci_chip_rev_id) != CHIPREV_57765_AX) {
-			u32 grc_mode = tr32(GRC_MODE);
+			u32 grc_mode;
+
+			/* Fix transmit hangs */
+			val = tr32(TG3_CPMU_PADRNG_CTL);
+			val |= TG3_CPMU_PADRNG_CTL_RDIV2;
+			tw32(TG3_CPMU_PADRNG_CTL, val);
+
+			grc_mode = tr32(GRC_MODE);
 
 			/* Access the lower 1K of DL PCIE block registers. */
 			val = grc_mode & ~GRC_MODE_PCIE_PORT_MASK;
@@ -9088,6 +9096,14 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 	if (tg3_flag(tp, PCI_EXPRESS))
 		rdmac_mode |= RDMAC_MODE_FIFO_LONG_BURST;
 
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_57766) {
+		tp->dma_limit = 0;
+		if (tp->dev->mtu <= ETH_DATA_LEN) {
+			rdmac_mode |= RDMAC_MODE_JMB_2K_MMRR;
+			tp->dma_limit = TG3_TX_BD_DMA_MAX_2K;
+		}
+	}
+
 	if (tg3_flag(tp, HW_TSO_1) ||
 	    tg3_flag(tp, HW_TSO_2) ||
 	    tg3_flag(tp, HW_TSO_3))
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 6d52cb2..3a58339 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -1120,6 +1120,8 @@
 #define  CPMU_MUTEX_GNT_DRIVER		 0x00001000
 #define TG3_CPMU_PHY_STRAP		0x00003664
 #define TG3_CPMU_PHY_STRAP_IS_SERDES	 0x00000020
+#define TG3_CPMU_PADRNG_CTL		0x00003668
+#define  TG3_CPMU_PADRNG_CTL_RDIV2	 0x00040000
 /* 0x3664 --> 0x36b0 unused */
 
 #define TG3_CPMU_EEE_MODE		0x000036b0
-- 
1.7.10.4


