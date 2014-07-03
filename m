Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbaGCJlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:41:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52387 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030375AbaGCJY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 152/198] net/mlx4_core: pass pci_device_id.driver_data to __mlx4_init_one during reset
Date: Thu,  3 Jul 2014 10:19:55 +0100
Message-Id: <1404379241-8590-153-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <weiyang@linux.vnet.ibm.com>

[ No upstream commit, this is a cherry picked backport enabler. ]

The second parameter of __mlx4_init_one() is used to identify whether the
pci_dev is a PF or VF. Currently, when it is invoked in mlx4_pci_slot_reset()
this information is missed.

This patch match the pci_dev with mlx4_pci_table and passes the
pci_device_id.driver_data to __mlx4_init_one() in mlx4_pci_slot_reset().

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 36be3208786a..c495c604ead3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2522,7 +2522,11 @@ static pci_ers_result_t mlx4_pci_err_detected(struct pci_dev *pdev,
 
 static pci_ers_result_t mlx4_pci_slot_reset(struct pci_dev *pdev)
 {
-	int ret = __mlx4_init_one(pdev, 0);
+	const struct pci_device_id *id;
+	int ret;
+
+	id = pci_match_id(mlx4_pci_table, pdev);
+	ret = __mlx4_init_one(pdev, id->driver_data);
 
 	return ret ? PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_RECOVERED;
 }
-- 
1.9.1

