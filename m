Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaLEOIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:08:19 -0500
Received: from smtp.citrix.com ([66.165.176.89]:58474 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaLEOIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:08:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,522,1413244800"; 
   d="scan'208";a="200351495"
From: David Vrabel <david.vrabel@citrix.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4/4] x86/xen: assume a 64-bit DMA mask is required
Date: Fri, 5 Dec 2014 14:08:03 +0000
Message-ID: <1417788483-662-5-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
References: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a Xen PV guest the DMA addresses and physical addresses are not 1:1
(such as Xen PV guests) and the generic dma_get_required_mask() does
not return the correct mask (since it uses max_pfn).

Some device drivers (such as mptsas, mpt2sas) use
dma_get_required_mask() to set the device's DMA mask to allow them to
use only 32-bit DMA addresses in hardware structures.  This results in
unnecessary use of the SWIOTLB if DMA addresses are more than 32-bits,
impacting performance significantly.

We could base the DMA mask on the maximum MFN but:

a) The hypercall op to get the maximum MFN (XENMEM_maximum_ram_page)
will truncate the result to an int in 32-bit guests.

b) Future uses of the IOMMU in Xen may map frames at bus addresses
above the end of RAM.

So, just assume a 64-bit DMA mask is always required.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 0e98e5d..35774f8 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -18,6 +18,11 @@
 
 int xen_swiotlb __read_mostly;
 
+static u64 xen_swiotlb_get_required_mask(struct device *dev)
+{
+	return DMA_BIT_MASK(64);
+}
+
 static struct dma_map_ops xen_swiotlb_dma_ops = {
 	.mapping_error = xen_swiotlb_dma_mapping_error,
 	.alloc = xen_swiotlb_alloc_coherent,
@@ -31,6 +36,7 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
 	.map_page = xen_swiotlb_map_page,
 	.unmap_page = xen_swiotlb_unmap_page,
 	.dma_supported = xen_swiotlb_dma_supported,
+	.get_required_mask = xen_swiotlb_get_required_mask,
 };
 
 /*
-- 
1.7.10.4

