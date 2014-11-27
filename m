Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaK0RXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:23:34 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44760 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaK0RXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:23:31 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 4/6] vfio: type1: replace domain wide protection flags with supported capabilities
Date: Thu, 27 Nov 2014 18:22:54 +0100
Message-Id: <1417108976-10113-5-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417108976-10113-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417108976-10113-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO_IOMMU_TYPE1 keeps track for each domain it knows a list of protection
flags it always applies to all mappings in the domain. This is used for
domains that support IOMMU_CAP_CACHE_COHERENCY.

Refactor this slightly, by keeping track instead that a given domain
supports the capability, and applying the IOMMU_CACHE protection flag when
doing the actual DMA mappings.

This will allow us to reuse the behavior for IOMMU_CAP_NOEXEC, which we
also want to keep track of, but without applying it to all domains that
support it unless the user explicitly requests it.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/vfio_iommu_type1.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4a9d666..c54dab8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -65,7 +65,7 @@ struct vfio_domain {
 	struct iommu_domain	*domain;
 	struct list_head	next;
 	struct list_head	group_list;
-	int			prot;		/* IOMMU_CACHE */
+	int			caps;
 };
 
 struct vfio_dma {
@@ -486,7 +486,7 @@ static int map_try_harder(struct vfio_domain *domain, dma_addr_t iova,
 	for (i = 0; i < npage; i++, pfn++, iova += PAGE_SIZE) {
 		ret = iommu_map(domain->domain, iova,
 				(phys_addr_t)pfn << PAGE_SHIFT,
-				PAGE_SIZE, prot | domain->prot);
+				PAGE_SIZE, prot);
 		if (ret)
 			break;
 	}
@@ -504,11 +504,16 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 	int ret;
 
 	list_for_each_entry(d, &iommu->domain_list, next) {
+		int dprot = prot;
+
+		if (d->caps & IOMMU_CAP_CACHE_COHERENCY)
+			dprot |= IOMMU_CACHE;
+
 		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
-				npage << PAGE_SHIFT, prot | d->prot);
+				npage << PAGE_SHIFT, dprot);
 		if (ret) {
 			if (ret != -EBUSY ||
-			    map_try_harder(d, iova, pfn, npage, prot))
+			    map_try_harder(d, iova, pfn, npage, dprot))
 				goto unwind;
 		}
 	}
@@ -621,6 +626,10 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	struct vfio_domain *d;
 	struct rb_node *n;
 	int ret;
+	int dprot = 0;
+
+	if (domain->caps & IOMMU_CAP_CACHE_COHERENCY)
+		dprot |= IOMMU_CACHE;
 
 	/* Arbitrarily pick the first domain in the list for lookups */
 	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
@@ -654,7 +663,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				size += PAGE_SIZE;
 
 			ret = iommu_map(domain->domain, iova, phys,
-					size, dma->prot | domain->prot);
+					size, dma->prot | dprot);
 			if (ret)
 				return ret;
 
@@ -731,7 +740,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	}
 
 	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
-		domain->prot |= IOMMU_CACHE;
+		domain->caps |= IOMMU_CAP_CACHE_COHERENCY;
 
 	/*
 	 * Try to match an existing compatible domain.  We don't want to
@@ -742,7 +751,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 */
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		if (d->domain->ops == domain->domain->ops &&
-		    d->prot == domain->prot) {
+		    d->caps == domain->caps) {
 			iommu_detach_group(domain->domain, iommu_group);
 			if (!iommu_attach_group(d->domain, iommu_group)) {
 				list_add(&group->next, &d->group_list);
@@ -884,7 +893,7 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 
 	mutex_lock(&iommu->lock);
 	list_for_each_entry(domain, &iommu->domain_list, next) {
-		if (!(domain->prot & IOMMU_CACHE)) {
+		if (!(domain->caps & IOMMU_CAP_CACHE_COHERENCY)) {
 			ret = 0;
 			break;
 		}
-- 
2.1.3

