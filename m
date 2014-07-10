Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaGJVsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:48:01 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:58399 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaGJVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:48:00 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, linux-mm <linux-mm@kvack.org>,
        Oded Gabbay <oded.gabbay@amd.com>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 01/83] mm: Add kfd_process pointer to mm_struct
Date: Fri, 11 Jul 2014 00:47:26 +0300
Message-Id: <1405028848-5660-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the KFD to retrieve the kfd_process
object from the process's mm_struct. This is needed because kfd_process
lifespan is bound to the process's mm_struct lifespan.

When KFD is notified about an mm_struct tear-down, it checks if the
kfd_process pointer is valid. If so, it releases the kfd_process object
and all relevant resources.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 include/linux/mm_types.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 678097c..6179107 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -20,6 +20,10 @@
 struct hmm;
 #endif
 
+#ifdef CONFIG_HSA_RADEON
+struct kfd_process;
+#endif
+
 #ifndef AT_VECTOR_SIZE_ARCH
 #define AT_VECTOR_SIZE_ARCH 0
 #endif
@@ -439,6 +443,16 @@ struct mm_struct {
 	 */
 	struct hmm *hmm;
 #endif
+#if defined(CONFIG_HSA_RADEON) || defined(CONFIG_HSA_RADEON_MODULE)
+	/*
+	 * kfd always register an mmu_notifier we rely on mmu notifier to keep
+	 * refcount on mm struct as well as forbiding registering kfd on a
+	 * dying mm
+	 *
+	 * This field is set with mmap_sem old in write mode.
+	 */
+	struct kfd_process *kfd_process;
+#endif
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
 #endif
-- 
1.9.1

