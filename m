Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3BVJj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:39:56 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:36233 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab3BVJjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:39:45 -0500
Date: Fri, 22 Feb 2013 10:39:20 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] x86: fix warning for sta2x11
Message-ID: <20130222093920.GA6513@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .free field of struct dma_map_ops features a prototype that is
different from what lib/swiotlb.c offers. The new "attrs" argument in
dma_ops.free is missing from the generic implementation.

This removes the build warning by providing a function that just calls
swiotlb_free_coherent() without passing "attrs", like others do.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---

NOTE: The real solution, in my opinion, would be adding "attrs" as
argument to the exported swiotlb_free_coherent() and remove this new
empty function for sta2x11 as well as the identical empty functions
found in other 6 files within arch.

If you ack, I can do that.

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
