Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaBRPHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:07:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534AbaBRPHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:07:15 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 1/2] mthca: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 16:09:01 +0100
Message-Id: <479c40ee9e4f3efa45aa6f57647ed1a1918e9deb.1392733151.git.agordeev@redhat.com>
In-Reply-To: <cover.1392733151.git.agordeev@redhat.com>
References: <cover.1392733151.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/infiniband/hw/mthca/mthca_main.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 87897b9..959d600 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -858,13 +858,10 @@ static int mthca_enable_msi_x(struct mthca_dev *mdev)
 	entries[1].entry = 1;
 	entries[2].entry = 2;
 
-	err = pci_enable_msix(mdev->pdev, entries, ARRAY_SIZE(entries));
-	if (err) {
-		if (err > 0)
-			mthca_info(mdev, "Only %d MSI-X vectors available, "
-				   "not using MSI-X\n", err);
+	err = pci_enable_msix_range(mdev->pdev, entries,
+				    ARRAY_SIZE(entries), ARRAY_SIZE(entries));
+	if (err < 0)
 		return err;
-	}
 
 	mdev->eq_table.eq[MTHCA_EQ_COMP ].msi_x_vector = entries[0].vector;
 	mdev->eq_table.eq[MTHCA_EQ_ASYNC].msi_x_vector = entries[1].vector;
-- 
1.7.7.6

