Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaJJL4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:56:22 -0400
Received: from smtp.citrix.com ([66.165.176.89]:22994 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbaJJLyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:54:14 -0400
X-IronPort-AV: E=Sophos;i="5.04,691,1406592000"; 
   d="scan'208";a="180114185"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 4/7] xen/arm: use is_dma_coherent
Date: Fri, 10 Oct 2014 12:51:45 +0100
Message-ID: <1412941908-5850-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use is_dma_coherent to check whether we need to issue cache maintenance
operations rather than checking on the existence of a particular
dma_ops function for the device.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/mm32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index 6153d61..c7fa673 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -76,7 +76,7 @@ void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		struct dma_attrs *attrs)
 
 {
-	if (!__generic_dma_ops(hwdev)->unmap_page)
+	if (is_dma_coherent(hwdev))
 		return;
 	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		return;
@@ -87,7 +87,7 @@ void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 void xen_dma_sync_single_for_cpu(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir)
 {
-	if (!__generic_dma_ops(hwdev)->sync_single_for_cpu)
+	if (is_dma_coherent(hwdev))
 		return;
 	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
 }
@@ -95,7 +95,7 @@ void xen_dma_sync_single_for_cpu(struct device *hwdev,
 void xen_dma_sync_single_for_device(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir)
 {
-	if (!__generic_dma_ops(hwdev)->sync_single_for_device)
+	if (is_dma_coherent(hwdev))
 		return;
 	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
 }
-- 
1.7.10.4

