Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaGQNat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:30:49 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:50183
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932139AbaGQNar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:30:47 -0400
X-WSS-ID: 0N8UYV5-08-6ST-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 01/25] mm: Add kfd_process pointer to mm_struct
Date: Thu, 17 Jul 2014 16:29:08 +0300
Message-ID: <1405603773-32688-2-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(55674003)(189002)(199002)(76482001)(79102001)(77982001)(104166001)(83072002)(97736001)(107046002)(74502001)(74662001)(50226001)(4396001)(46102001)(44976005)(19580405001)(19580395003)(33646002)(21056001)(81542001)(83322001)(31966008)(102836001)(80022001)(92726001)(93916002)(86362001)(85852003)(64706001)(92566001)(20776003)(47776003)(81342001)(68736004)(88136002)(105586002)(36756003)(77156001)(87286001)(87936001)(106466001)(229853001)(76176999)(48376002)(99396002)(89996001)(50986999)(62966002)(50466002)(95666004)(85306003)(77096002)(84676001)(101416001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB037;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the amdkfd driver to retrieve the kfd_process
object from the process's mm_struct. This is needed because kfd_process
lifespan is bound to the process's mm_struct lifespan.

When amdkfd is notified about an mm_struct tear-down, it checks if the
kfd_process pointer is valid. If so, it releases the kfd_process object
and all relevant resources.

In v3 of the patchset I will update the binding to match the final discussions
on [PATCH 1/8] mmput: use notifier chain to call subsystem exit handler.
In the meantime, I'm going to try and see if I can drop the kfd_process
in mm_struct and remove the use of the new notification chain in mmput.
Instead, I will try to use the mmu release notifier.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 include/linux/mm_types.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 678097c..ff71496 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -20,6 +20,10 @@
 struct hmm;
 #endif
 
+#if defined(CONFIG_HSA_RADEON) || defined(CONFIG_HSA_RADEON_MODULE)
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

