Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab3HGKXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:23:25 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56288 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458Ab3HGKXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:23:08 -0400
Date: Wed, 7 Aug 2013 12:16:30 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 01/26] x86: fix warning for sta2x11
Message-ID: <ecfa93f64262f5428da9400740f86786ff04d346.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .free fied of struct dma_map_ops features a prototype that is
different from what lib/swiotlb.c offers. The new "attrs" argument in
dma_ops.free is missing from the generic implementation.

This removes the build warning by providing a function that just calls
swiotlb_free_coherent() without passing "attrs".

The real solution, in my opinion, would be adding "attrs" as argument
to swiotlb_free_coherent() and remove this new empty function as well
as the identical ones found in other 6 files within arch.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/pci/sta2x11-fixup.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index 9d8a509..5c24ccb 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -180,10 +180,17 @@ static void *sta2x11_swiotlb_alloc_coherent(struct device *dev,
 	return vaddr;
 }
 
+static void sta2x11_swiotlb_free_coherent(struct device *dev, size_t size,
+					  void *vaddr, dma_addr_t dma_addr,
+					  struct dma_attrs *attrs)
+{
+	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
+}
+
 /* We have our own dma_ops: the same as swiotlb but from alloc (above) */
 static struct dma_map_ops sta2x11_dma_ops = {
 	.alloc = sta2x11_swiotlb_alloc_coherent,
-	.free = swiotlb_free_coherent,
+	.free = sta2x11_swiotlb_free_coherent,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
 	.map_sg = swiotlb_map_sg_attrs,
-- 
1.7.7.2
