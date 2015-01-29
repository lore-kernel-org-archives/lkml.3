Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796AbbA2Jbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:31:34 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34513 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbbA2JWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:21 -0500
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
Subject: [PATCH v3 05/24] vfio: powerpc/spapr: Move locked_vm accounting to helpers
Date: Thu, 29 Jan 2015 20:21:46 +1100
Message-Id: <1422523325-1389-6-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0029-0000-0000-0000010FD5B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There moves locked pages accounting to helpers.
Later they will be reused for Dynamic DMA windows (DDW).

While we are here, update the comment explaining why RLIMIT_MEMLOCK
might be required to be bigger than the guest RAM. This also prints
pid of the current process in pr_warn/pr_debug.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 72 +++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index c596053..29d5708 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -29,6 +29,47 @@
 static void tce_iommu_detach_group(void *iommu_data,
 		struct iommu_group *iommu_group);
 
+#define IOMMU_TABLE_PAGES(tbl) \
+		(((tbl)->it_size << (tbl)->it_page_shift) >> PAGE_SHIFT)
+
+static long try_increment_locked_vm(long npages)
+{
+	long ret = 0, locked, lock_limit;
+
+	if (!current || !current->mm)
+		return -ESRCH; /* process exited */
+
+	down_write(&current->mm->mmap_sem);
+	locked = current->mm->locked_vm + npages;
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
+		pr_warn("[%d] RLIMIT_MEMLOCK (%ld) exceeded\n",
+				current->pid, rlimit(RLIMIT_MEMLOCK));
+		ret = -ENOMEM;
+	} else {
+		current->mm->locked_vm += npages;
+	}
+	pr_debug("[%d] RLIMIT_MEMLOCK+ %ld pages\n", current->pid,
+			current->mm->locked_vm);
+	up_write(&current->mm->mmap_sem);
+
+	return ret;
+}
+
+static void decrement_locked_vm(long npages)
+{
+	if (!current || !current->mm)
+		return; /* process exited */
+
+	down_write(&current->mm->mmap_sem);
+	if (npages > current->mm->locked_vm)
+		npages = current->mm->locked_vm;
+	current->mm->locked_vm -= npages;
+	pr_debug("[%d] RLIMIT_MEMLOCK- %ld pages\n", current->pid,
+			current->mm->locked_vm);
+	up_write(&current->mm->mmap_sem);
+}
+
 /*
  * VFIO IOMMU fd for SPAPR_TCE IOMMU implementation
  *
@@ -66,8 +107,6 @@ static bool tce_check_page_size(struct page *page, unsigned page_shift)
 static int tce_iommu_enable(struct tce_container *container)
 {
 	int ret = 0;
-	unsigned long locked, lock_limit, npages;
-	struct iommu_table *tbl = container->tbl;
 
 	if (!container->tbl)
 		return -ENXIO;
@@ -95,21 +134,19 @@ static int tce_iommu_enable(struct tce_container *container)
 	 * Also we don't have a nice way to fail on H_PUT_TCE due to ulimits,
 	 * that would effectively kill the guest at random points, much better
 	 * enforcing the limit based on the max that the guest can map.
+	 *
+	 * Unfortunately at the moment it counts whole tables, no matter how
+	 * much memory the guest has. I.e. for 4GB guest and 4 IOMMU groups
+	 * each with 2GB DMA window, 8GB will be counted here. The reason for
+	 * this is that we cannot tell here the amount of RAM used by the guest
+	 * as this information is only available from KVM and VFIO is
+	 * KVM agnostic.
 	 */
-	down_write(&current->mm->mmap_sem);
-	npages = (tbl->it_size << tbl->it_page_shift) >> PAGE_SHIFT;
-	locked = current->mm->locked_vm + npages;
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
-		pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
-				rlimit(RLIMIT_MEMLOCK));
-		ret = -ENOMEM;
-	} else {
+	ret = try_increment_locked_vm(IOMMU_TABLE_PAGES(container->tbl));
+	if (ret)
+		return ret;
 
-		current->mm->locked_vm += npages;
-		container->enabled = true;
-	}
-	up_write(&current->mm->mmap_sem);
+	container->enabled = true;
 
 	return ret;
 }
@@ -124,10 +161,7 @@ static void tce_iommu_disable(struct tce_container *container)
 	if (!container->tbl || !current->mm)
 		return;
 
-	down_write(&current->mm->mmap_sem);
-	current->mm->locked_vm -= (container->tbl->it_size <<
-			container->tbl->it_page_shift) >> PAGE_SHIFT;
-	up_write(&current->mm->mmap_sem);
+	decrement_locked_vm(IOMMU_TABLE_PAGES(container->tbl));
 }
 
 static void *tce_iommu_open(unsigned long arg)
-- 
2.0.0

