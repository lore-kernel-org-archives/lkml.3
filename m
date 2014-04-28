Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaD1QBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:01:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61027 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbaD1Pxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:53:53 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v5 03/11] VFIO_IOMMU_TYPE1 for platform bus devices on ARM
Date: Mon, 28 Apr 2014 17:52:43 +0200
Message-Id: <1398700371-20096-4-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to make use of the VFIO_IOMMU_TYPE1 driver with platform
devices on ARM in addition to PCI. This is required in order to use the
Exynos SMMU, or ARM SMMU driver with VFIO_IOMMU_TYPE1.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/Kconfig            | 2 +-
 drivers/vfio/vfio_iommu_type1.c | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index af7b204..3a598ed 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -11,7 +11,7 @@ config VFIO_IOMMU_SPAPR_TCE
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
-	select VFIO_IOMMU_TYPE1 if X86
+	select VFIO_IOMMU_TYPE1 if X86 || ARM
 	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
 	select ANON_INODES
 	help
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 1f90344..4dc989d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -30,6 +30,7 @@
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/pci.h>		/* pci_bus_type */
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -721,13 +722,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	INIT_LIST_HEAD(&domain->group_list);
 	list_add(&group->next, &domain->group_list);
 
-	if (!allow_unsafe_interrupts &&
+#ifdef CONFIG_PCI
+	if (bus == &pci_bus_type && !allow_unsafe_interrupts &&
 	    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_INTR_REMAP)) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
 		ret = -EPERM;
 		goto out_detach;
 	}
+#endif
 
 	if (iommu_domain_has_cap(domain->domain, IOMMU_CAP_CACHE_COHERENCY))
 		domain->prot |= IOMMU_CACHE;
-- 
1.8.3.2

