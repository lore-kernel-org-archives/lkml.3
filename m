Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbaBWGzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 01:55:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaBWGzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 01:55:12 -0500
Date: Sun, 23 Feb 2014 07:57:05 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 1/2] IB/mthca: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140223065704.GB24747@dhcp-26-207.brq.redhat.com>
References: <cover.1392733151.git.agordeev@redhat.com>
 <479c40ee9e4f3efa45aa6f57647ed1a1918e9deb.1392733151.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479c40ee9e4f3efa45aa6f57647ed1a1918e9deb.1392733151.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/infiniband/hw/mthca/mthca_main.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 87897b9..ded76c1 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -858,13 +858,9 @@ static int mthca_enable_msi_x(struct mthca_dev *mdev)
 	entries[1].entry = 1;
 	entries[2].entry = 2;
 
-	err = pci_enable_msix(mdev->pdev, entries, ARRAY_SIZE(entries));
-	if (err) {
-		if (err > 0)
-			mthca_info(mdev, "Only %d MSI-X vectors available, "
-				   "not using MSI-X\n", err);
+	err = pci_enable_msix_exact(mdev->pdev, entries, ARRAY_SIZE(entries));
+	if (err)
 		return err;
-	}
 
 	mdev->eq_table.eq[MTHCA_EQ_COMP ].msi_x_vector = entries[0].vector;
 	mdev->eq_table.eq[MTHCA_EQ_ASYNC].msi_x_vector = entries[1].vector;
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
