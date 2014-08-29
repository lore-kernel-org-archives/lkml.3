Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaH2ICk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:02:40 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60273 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaH2H7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:59:32 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH 09/13] powerpc/pseries/lpar: Enable VFIO
Date: Fri, 29 Aug 2014 17:59:12 +1000
Message-Id: <1409299156-618-10-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082907-3568-0000-0000-00000021DB58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch introduced iommu_table_ops::exchange() callback
which effectively disabled VFIO on pseries. This implements exchange()
for pseries/lpar so VFIO can work in nested guests.

Since exchaange() callback returns an old TCE, it has to call H_GET_TCE
for every TCE being put to the table so VFIO performance in guests
running under PR KVM is expected to be slower than in guests running under
HV KVM or bare metal hosts.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/pseries/iommu.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 9a7364f..ae15b5a 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -138,13 +138,14 @@ static void tce_freemulti_pSeriesLP(struct iommu_table*, long, long);
 
 static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
 				long npages, unsigned long uaddr,
+				unsigned long *old_tces,
 				enum dma_data_direction direction,
 				struct dma_attrs *attrs)
 {
 	u64 rc = 0;
 	u64 proto_tce, tce;
 	u64 rpn;
-	int ret = 0;
+	int ret = 0, i = 0;
 	long tcenum_start = tcenum, npages_start = npages;
 
 	rpn = __pa(uaddr) >> TCE_SHIFT;
@@ -154,6 +155,9 @@ static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
 
 	while (npages--) {
 		tce = proto_tce | (rpn & TCE_RPN_MASK) << TCE_RPN_SHIFT;
+		if (old_tces)
+			plpar_tce_get((u64)tbl->it_index, (u64)tcenum << 12,
+					&old_tces[i++]);
 		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, tce);
 
 		if (unlikely(rc == H_NOT_ENOUGH_RESOURCES)) {
@@ -179,8 +183,9 @@ static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
 
 static DEFINE_PER_CPU(__be64 *, tce_page);
 
-static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
+static int tce_xchg_pSeriesLP(struct iommu_table *tbl, long tcenum,
 				     long npages, unsigned long uaddr,
+				     unsigned long *old_tces,
 				     enum dma_data_direction direction,
 				     struct dma_attrs *attrs)
 {
@@ -195,6 +200,7 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 
 	if ((npages == 1) || !firmware_has_feature(FW_FEATURE_MULTITCE)) {
 		return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
+					   old_tces,
 		                           direction, attrs);
 	}
 
@@ -211,6 +217,7 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 		if (!tcep) {
 			local_irq_restore(flags);
 			return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
+					    old_tces,
 					    direction, attrs);
 		}
 		__get_cpu_var(tce_page) = tcep;
@@ -232,6 +239,10 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 		for (l = 0; l < limit; l++) {
 			tcep[l] = cpu_to_be64(proto_tce | (rpn & TCE_RPN_MASK) << TCE_RPN_SHIFT);
 			rpn++;
+			if (old_tces)
+				plpar_tce_get((u64)tbl->it_index,
+						(u64)(tcenum + l) << 12,
+						&old_tces[tcenum + l]);
 		}
 
 		rc = plpar_tce_put_indirect((u64)tbl->it_index,
@@ -262,6 +273,15 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	return ret;
 }
 
+static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
+				     long npages, unsigned long uaddr,
+				     enum dma_data_direction direction,
+				     struct dma_attrs *attrs)
+{
+	return tce_xchg_pSeriesLP(tbl, tcenum, npages, uaddr, NULL,
+			direction, attrs);
+}
+
 static void tce_free_pSeriesLP(struct iommu_table *tbl, long tcenum, long npages)
 {
 	u64 rc;
@@ -637,6 +657,7 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 
 struct iommu_table_ops iommu_table_lpar_multi_ops = {
 	.set = tce_buildmulti_pSeriesLP,
+	.exchange = tce_xchg_pSeriesLP,
 	.clear = tce_freemulti_pSeriesLP,
 	.get = tce_get_pSeriesLP
 };
-- 
2.0.0

