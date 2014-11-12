Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaKLLlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:41:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:60341 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaKLLlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:41:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,368,1413244800"; 
   d="scan'208";a="191920929"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 06/13] xen/arm: use is_device_dma_coherent
Date: Wed, 12 Nov 2014 11:40:47 +0000
Message-ID: <1415792454-23161-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com>
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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/arm/xen/mm32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index 5bb8391..3ce9dc1 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -48,7 +48,7 @@ void __xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		struct dma_attrs *attrs)
 
 {
-	if (!__generic_dma_ops(hwdev)->unmap_page)
+	if (is_device_dma_coherent(hwdev))
 		return;
 	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		return;
@@ -59,7 +59,7 @@ void __xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 void __xen_dma_sync_single_for_cpu(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir)
 {
-	if (!__generic_dma_ops(hwdev)->sync_single_for_cpu)
+	if (is_device_dma_coherent(hwdev))
 		return;
 	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
 }
@@ -67,7 +67,7 @@ void __xen_dma_sync_single_for_cpu(struct device *hwdev,
 void __xen_dma_sync_single_for_device(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir)
 {
-	if (!__generic_dma_ops(hwdev)->sync_single_for_device)
+	if (is_device_dma_coherent(hwdev))
 		return;
 	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
 }
-- 
1.7.10.4

