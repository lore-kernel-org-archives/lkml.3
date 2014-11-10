Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaKJQSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:18:13 -0500
Received: from smtp.citrix.com ([66.165.176.89]:10305 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbaKJQSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:18:09 -0500
X-IronPort-AV: E=Sophos;i="5.07,353,1413244800"; 
   d="scan'208";a="189800779"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v8 13/13] swiotlb-xen: remove BUG_ON in xen_bus_to_phys
Date: Mon, 10 Nov 2014 16:14:05 +0000
Message-ID: <1415636045-24669-13-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 truncation cannot occur because config XEN depends on X86_64 ||
(X86_32 && X86_PAE).

On ARM truncation can occur without CONFIG_ARM_LPAE, when the dma
operation involves foreign grants. However in that case the physical
address returned by xen_bus_to_phys is actually invalid (there is no mfn
to pfn tracking for foreign grants on ARM) and it is not used.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/swiotlb-xen.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 498b654..153cf14 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -96,8 +96,6 @@ static inline phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
 	dma_addr_t dma = (dma_addr_t)pfn << PAGE_SHIFT;
 	phys_addr_t paddr = dma;
 
-	BUG_ON(paddr != dma); /* truncation has occurred, should never happen */
-
 	paddr |= baddr & ~PAGE_MASK;
 
 	return paddr;
-- 
1.7.10.4

