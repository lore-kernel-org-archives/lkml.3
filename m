Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaAQQXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:23:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbaAQQXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:23:34 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 1/9] ahci: Fix broken fallback to single MSI mode
Date: Fri, 17 Jan 2014 17:02:15 +0100
Message-Id: <e05f8749ee0fa300c56a0c6f09298c96a3706071.1389904166.git.agordeev@redhat.com>
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7b92b4f ("PCI/MSI: Remove pci_enable_msi_block_auto()")
introduced a regression - in case multiple MSIs initialization
fails the code falls back to INTx rather than to single MSI.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ata/ahci.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 8516f4d..df24eef4 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1117,8 +1117,10 @@ int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 
 	nvec = rc;
 	rc = pci_enable_msi_block(pdev, nvec);
-	if (rc)
+	if (rc < 0)
 		goto intx;
+	else if (rc > 0)
+		goto single_msi;
 
 	return nvec;
 
-- 
1.7.7.6

