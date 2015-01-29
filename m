Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbbA2JWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:22:32 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46104 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760403AbbA2JWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:25 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/24] vfio: powerpc/iommu: Check that TCE page size is equal to it_page_size
Date: Thu, 29 Jan 2015 20:21:43 +1100
Message-Id: <1422523325-1389-3-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0025-0000-0000-000000FBD8FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This checks that the TCE table page size is not bigger that the size of
a page we just pinned and going to put its physical address to the table.

Otherwise the hardware gets unwanted access to physical memory between
the end of the actual page and the end of the aligned up TCE page.

Since compound_order() and compound_head() work correctly on non-huge
pages, there is no need for additional check whether the page is huge.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v5:
* check is done for all page sizes now, not just for huge pages
* failed check returns EFAULT now (was EINVAL)
* moved the check to VFIO SPAPR IOMMU driver
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index dc4a886..99b98fa 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -47,6 +47,22 @@ struct tce_container {
 	bool enabled;
 };
 
+static bool tce_check_page_size(struct page *page, unsigned page_shift)
+{
+	unsigned shift;
+
+	/*
+	 * Check that the TCE table granularity is not bigger than the size of
+	 * a page we just found. Otherwise the hardware can get access to
+	 * a bigger memory chunk that it should.
+	 */
+	shift = PAGE_SHIFT + compound_order(compound_head(page));
+	if (shift >= page_shift)
+		return true;
+
+	return false;
+}
+
 static int tce_iommu_enable(struct tce_container *container)
 {
 	int ret = 0;
@@ -199,6 +215,12 @@ static long tce_iommu_build(struct tce_container *container,
 			ret = -EFAULT;
 			break;
 		}
+
+		if (!tce_check_page_size(page, tbl->it_page_shift)) {
+			ret = -EFAULT;
+			break;
+		}
+
 		hva = (unsigned long) page_address(page) +
 			(tce & IOMMU_PAGE_MASK(tbl) & ~PAGE_MASK);
 
-- 
2.0.0

