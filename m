Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaFJNJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:09:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaFJNJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:09:31 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, iommu@lists.linux-foundation.org,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 3/3] AHCI: Use pci_enable_msi_partial() to conserve on 10/16 MSIs
Date: Tue, 10 Jun 2014 15:10:32 +0200
Message-Id: <dba9f0f8e9cccd7625d0f3fab94457482e1a2bd7.1402405331.git.agordeev@redhat.com>
In-Reply-To: <cover.1402405331.git.agordeev@redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new pci_enable_msi_partial() interface and
conserve on othewise wasted interrupt resources for 10 out
of 16 unused MSI vectors on Intel chipsets.

Cc: x86@kernel.org
Cc: xen-devel@lists.xenproject.org
Cc: iommu@lists.linux-foundation.org
Cc: linux-ide@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ata/ahci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6070781..0c7a0f3 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1194,7 +1194,7 @@ static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 	if (nvec < n_ports)
 		goto single_msi;
 
-	rc = pci_enable_msi_exact(pdev, nvec);
+	rc = pci_enable_msi_partial(pdev, n_ports, nvec);
 	if (rc == -ENOSPC)
 		goto single_msi;
 	else if (rc < 0)
@@ -1207,7 +1207,7 @@ static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 		goto single_msi;
 	}
 
-	return nvec;
+	return n_ports;
 
 single_msi:
 	if (pci_enable_msi(pdev))
-- 
1.7.7.6

