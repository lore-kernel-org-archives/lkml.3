Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888Ab3BKFJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 00:09:20 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36959 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3BKFJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 00:09:18 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>, kvm-ppc@vger.kernel.org
Subject: [PATCH] iommu: adding missing kvm_iommu_map_pages/kvm_iommu_unmap_pages
Date: Mon, 11 Feb 2013 16:09:02 +1100
Message-Id: <1360559342-21423-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IOMMU API implements groups creating/deletion, device binding
and IOMMU map/unmap operations.

The POWERPC implementation uses most of the API except map/unmap
operations which are implemented on POWERPC using hypercalls.

However in order to link a kernel with the CONFIG_IOMMU_API enabled,
the empty kvm_iommu_map_pages/kvm_iommu_unmap_pages have to be
defined, so does the patch.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: David Gibson <david@gibson.dropbear.id.au>
---
 arch/powerpc/kernel/iommu.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 31c4fdc..7c309fe 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -36,6 +36,7 @@
 #include <linux/hash.h>
 #include <linux/fault-inject.h>
 #include <linux/pci.h>
+#include <linux/kvm_host.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/iommu.h>
@@ -860,3 +861,19 @@ void iommu_free_coherent(struct iommu_table *tbl, size_t size,
 		free_pages((unsigned long)vaddr, get_order(size));
 	}
 }
+
+#ifdef CONFIG_IOMMU_API
+/*
+ * SPAPR TCE API
+ */
+
+/* POWERPC does not use IOMMU API for mapping/unmapping */
+int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	return 0;
+}
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+}
+
+#endif /* CONFIG_IOMMU_API */
-- 
1.7.10.4

