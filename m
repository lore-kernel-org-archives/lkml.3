Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaFXPws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:52:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbaFXPwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:52:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 25/52] net/mlx4_core: pass pci_device_id.driver_data to __mlx4_init_one during reset
Date: Tue, 24 Jun 2014 11:50:40 -0400
Message-Id: <20140624154715.011376622@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154713.428945460@linuxfoundation.org>
References: <20140624154713.428945460@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2517,7 +2517,11 @@ static pci_ers_result_t mlx4_pci_err_det
 
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


