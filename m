Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3ASC1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 21:27:19 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:34307 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3ASC1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 21:27:01 -0500
From: Craig Hada <craig.hada@hp.com>
To: netdev@vger.kernel.org, craig.hada@hp.com
Cc: sathya.perla@emulex.com, subbu.seetharaman@emulex.com,
        ajit.khaparde@emulex.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] drivers/net: Enable IOMMU pass through for be2net
Date: Fri, 18 Jan 2013 18:23:15 -0800
Message-Id: <1358562195-2028-2-git-send-email-craig.hada@hp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1358562195-2028-1-git-send-email-craig.hada@hp.com>
References: <1358562195-2028-1-git-send-email-craig.hada@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the coherent DMA mask to 64-bit after the be2net driver
has been acknowledged that the system is 64-bit DMA capable. The coherent
DMA mask is examined by the Intel IOMMU driver to determine whether to
allow pass through context mapping for all devices. With this patch, the
be2net driver combined with be2net compatible hardware provides
comparable performance to the case where vt-d is disabled. The main use
case for this change is to decrease the time necessary to copy virtual
machine memory during KVM live migration instantiations.

This patch was tested on a system that enables the IOMMU in non-coherent
mode. Two DMA remapper issues were encountered in the previous version and
both patches have been committed.
    commit ea2447f700cab264019b52e2b417d689e052dcfd
    commit 2e12bc29fc5a12242d68e11875db3dd58efad9ff

Signed-off-by: Craig Hada <craig.hada@hp.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 9dca22b..b507e99 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4052,6 +4052,12 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 
 	status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 	if (!status) {
+		status = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
+		if (status < 0) {
+			dev_err(&pdev->dev,
+				"dma_set_coherent_mask failed, aborting\n");
+			goto free_netdev;
+		}
 		netdev->features |= NETIF_F_HIGHDMA;
 	} else {
 		status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-- 
1.7.1

