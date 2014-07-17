Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbaGQN6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:58:19 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:9211
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932660AbaGQN6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:58:16 -0400
X-WSS-ID: 0N8V04W-08-92X-02
X-M-MSG: 
Message-ID: <53C7D666.6000405@amd.com>
Date: Thu, 17 Jul 2014 16:57:58 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: [PATCH v2 01/25] mm: Add kfd_process pointer to mm_struct
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(55674003)(31966008)(46102001)(65956001)(92726001)(79102001)(44976005)(87266999)(107046002)(19580395003)(21056001)(20776003)(92566001)(64706001)(76176999)(54356999)(47776003)(105586002)(86362001)(87936001)(83072002)(106466001)(68736004)(102836001)(81542001)(50466002)(229853001)(64126003)(99396002)(50986999)(81342001)(19580405001)(84676001)(65816999)(97736001)(95666004)(77982001)(33656002)(65806001)(83322001)(74502001)(85852003)(36756003)(74662001)(85306003)(4396001)(101416001)(23676002)(59896001)(76482001)(80022001)(83506001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB035;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to add mm mailing list. Sorry.

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

