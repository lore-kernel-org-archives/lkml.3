Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3IINSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:18:45 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:44899 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab3IINRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:17:05 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>
CC: <linux-kernel@vger.kernel.org>, Mark Einon <mark.einon@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        <linux-rdma@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5/6] staging/et131x: Use cached pci_dev->pcie_mpss and pcie_set_readrq() to simplif code
Date: Mon, 9 Sep 2013 21:13:07 +0800
Message-ID: <1378732388-4508-6-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI core caches the "PCI-E Max Payload Size Supported" in
pci_dev->pcie_mpss, so use that instead of pcie_capability_read_dword().
Also use pcie_set_readrq() instead of pcie_capability_clear_and_set_word()
to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/staging/et131x/et131x.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index f73e58f..876881d 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3605,17 +3605,10 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 		goto err_out;
 	}
 
-	/* Let's set up the PORT LOGIC Register.  First we need to know what
-	 * the max_payload_size is
-	 */
-	if (pcie_capability_read_word(pdev, PCI_EXP_DEVCAP, &max_payload)) {
-		dev_err(&pdev->dev,
-		    "Could not read PCI config space for Max Payload Size\n");
-		goto err_out;
-	}
+	/* Let's set up the PORT LOGIC Register. */
 
 	/* Program the Ack/Nak latency and replay timers */
-	max_payload &= 0x07;
+	max_payload = pdev->pcie_mpss;
 
 	if (max_payload < 2) {
 		static const u16 acknak[2] = { 0x76, 0xD0 };
@@ -3645,8 +3638,7 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 	}
 
 	/* Change the max read size to 2k */
-	if (pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
-				PCI_EXP_DEVCTL_READRQ, 0x4 << 12)) {
+	if (pcie_set_readrq(pdev, 2048)) {
 		dev_err(&pdev->dev,
 			"Couldn't change PCI config space for Max read size\n");
 		goto err_out;
-- 
1.7.1


