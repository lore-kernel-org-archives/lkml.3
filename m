Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaJ0POg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:14:36 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28545 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbaJ0PNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:13:08 -0400
X-IronPort-AV: E=Sophos;i="5.04,796,1406592000"; 
   d="scan'208";a="185211235"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v7 5/8] xen/arm: use is_device_dma_coherent
Date: Mon, 27 Oct 2014 15:09:25 +0000
Message-ID: <1414422568-19103-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use is_device_dma_coherent to check whether we need to issue cache
maintenance operations rather than checking on the existence of a
particular dma_ops function for the device.

This is correct because coherent devices don't need cache maintenance
operations - arm_coherent_dma_ops does not set the hooks that we
were previously checking for existance.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/arm/xen/mm32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index 6153d61..d8ed359 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -76,7 +76,7 @@ void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		struct dma_attrs *attrs)
 
 {
-	if (!__generic_dma_ops(hwdev)->unmap_page)
+	if (is_device_dma_coherent(hwdev))
 		return;
 	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		return;
@@ -87,7 +87,7 @@ void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 void xen_dma_sync_single_for_cpu(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir)
 {
-	if (!__generic_dma_ops(hwdev)->sync_single_for_cpu)
+	if (is_device_dma_coherent(hwdev))
 		return;
 	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
 }
@@ -95,7 +95,7 @@ void xen_dma_sync_single_for_cpu(struct device *hwdev,
 void xen_dma_sync_single_for_device(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir)
 {
-	if (!__generic_dma_ops(hwdev)->sync_single_for_device)
+	if (is_device_dma_coherent(hwdev))
 		return;
 	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
 }
-- 
1.7.10.4

