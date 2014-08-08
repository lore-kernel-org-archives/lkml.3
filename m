Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbaHHVW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:22:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaHHUu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:50:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 227/259] net/mlx4_core: pass pci_device_id.driver_data to __mlx4_init_one during reset
Date: Fri,  8 Aug 2014 13:40:50 -0700
Message-Id: <1407530482-4483-228-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 01fc651..c239a9a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2567,7 +2567,11 @@ static pci_ers_result_t mlx4_pci_err_detected(struct pci_dev *pdev,
 
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

