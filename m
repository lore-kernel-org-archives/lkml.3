Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBGOor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:44:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbaBGOoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:44:46 -0500
Date: Fri, 7 Feb 2014 15:46:40 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        linux-pci@vger.kernel.org
Subject: [PATCH] wil6210: Fix switch operator "missing break?" warning
Message-ID: <20140207144639.GA10939@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <aedc9b7eb82232204a7d65b4c7d3302ba6ba3892.1389904167.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aedc9b7eb82232204a7d65b4c7d3302ba6ba3892.1389904167.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update fixes a warning introduced with commit bc977ba1
("wil6210: Use pci_enable_msi_range() instead of pci_enable_msi_block()")

drivers/net/wireless/ath/wil6210/pcie_bus.c:65 wil_if_pcie_enable()
warn: missing break? reassigning 'use_msi'

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 4e1bf54..e1c8cc4 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -51,16 +51,12 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 		use_msi = 1;
 	}
 
-	switch (use_msi) {
-	case 3:
-		if (pci_enable_msi_range(pdev, 3, 3) > 0)
-			break;
+	if (use_msi == 3 && pci_enable_msi_range(pdev, 3, 3) < 0) {
 		wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
 		use_msi = 1;
-		/* fallthrough */
-	case 1:
-		if (!pci_enable_msi(pdev))
-			break;
+	}
+
+	if (use_msi == 1 && pci_enable_msi(pdev)) {
 		wil_err(wil, "pci_enable_msi failed, use INTx\n");
 		use_msi = 0;
 	}
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
