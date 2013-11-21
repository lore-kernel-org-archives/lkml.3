Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3KUAVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:21:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:21265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab3KUAVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:21:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="412103082"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 3/9] ntb: Fix missed call to pci_enable_msix()
Date: Wed, 20 Nov 2013 17:21:24 -0700
Message-Id: <1384993290-10107-4-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
References: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Gordeev <agordeev@redhat.com>

Current MSI-X enablement code assumes MSI-Xs were successfully
allocated in case less than requested vectors were available.
That assumption is wrong, since MSI-Xs should be enabled with
a repeated call to pci_enable_msix(). This update fixes this.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index a9b065f..fa97948 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1084,6 +1084,10 @@ static int ntb_setup_msix(struct ntb_device *ndev)
 			 "Only %d MSI-X vectors.  Limiting the number of queues to that number.\n",
 			 rc);
 		msix_entries = rc;
+
+		rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
+		if (rc)
+			goto err1;
 	}
 
 	for (i = 0; i < msix_entries; i++) {
-- 
1.7.9.5

