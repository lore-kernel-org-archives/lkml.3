Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaENGfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 02:35:22 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:21483
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750717AbaENGfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 02:35:17 -0400
X-WSS-ID: 0N5JWYO-07-LHS-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <sherry.hurwitz@amd.com>, <kim.naru@amd.com>,
        <linux-kernel@vger.kernel.org>, Jay Cornwall <jay.cornwall@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] iommu/amd: Fix for L2 race with VM invalidation
Date: Wed, 14 May 2014 01:34:12 -0500
Message-ID: <1400049252-4213-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(19580405001)(46102001)(21056001)(2009001)(79102001)(33646001)(92566001)(88136002)(80022001)(20776003)(102836001)(87286001)(47776003)(76482001)(50226001)(74502001)(44976005)(62966002)(77982001)(19580395003)(77156001)(97736001)(53416003)(36756003)(81342001)(84676001)(68736004)(83322001)(85852003)(86362001)(92726001)(64706001)(86152002)(87936001)(93916002)(50986999)(48376002)(50466002)(101416001)(89996001)(83072002)(31966008)(4396001)(99396002)(74662001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB050;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0211965D06
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cornwall <jay.cornwall@amd.com>

Do not disassociate the process page tables from a PASID during VM
invalidation. Invalidate the IOMMU TLB and IOTLBs before invalidation.

L2 translations may fail during VM range invalidation. The current
implementation associates an empty page table with a PASID within
the critical section to avoid races with the VM. This causes
unconditional failure of all translations during this period.

A low probability race exists with this fix. Translations received
within the critical section to PTEs which are concurrently being
invalidated may resolve to stale mappings.

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd_iommu.c       |   40 +++++++++++++++++++++++++++++++++++----
 drivers/iommu/amd_iommu_proto.h |    2 ++
 drivers/iommu/amd_iommu_v2.c    |   40 ++++++---------------------------------
 3 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c949520..da43985 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3667,12 +3667,12 @@ out:
 	return ret;
 }
 
-static int __amd_iommu_flush_page(struct protection_domain *domain, int pasid,
-				  u64 address)
+static int __amd_iommu_flush_pages(struct protection_domain *domain, int pasid,
+				  u64 address, bool size)
 {
 	INC_STATS_COUNTER(invalidate_iotlb);
 
-	return __flush_pasid(domain, pasid, address, false);
+	return __flush_pasid(domain, pasid, address, size);
 }
 
 int amd_iommu_flush_page(struct iommu_domain *dom, int pasid,
@@ -3683,13 +3683,45 @@ int amd_iommu_flush_page(struct iommu_domain *dom, int pasid,
 	int ret;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	ret = __amd_iommu_flush_page(domain, pasid, address);
+	ret = __amd_iommu_flush_pages(domain, pasid, address, 0);
 	spin_unlock_irqrestore(&domain->lock, flags);
 
 	return ret;
 }
 EXPORT_SYMBOL(amd_iommu_flush_page);
 
+int amd_iommu_flush_page_range(struct iommu_domain *dom, int pasid,
+			u64 start, u64 end)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long flags;
+	unsigned long pages;
+	int ret;
+	u64 addr;
+	bool size;
+
+	pages = iommu_num_pages(start, end - start, PAGE_SIZE);
+
+	/*
+	 * If we have to flush more than one page, flush all
+	 * pages for this PASID
+	 */
+	if (pages > 1) {
+		addr = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+		size = 1;
+	} else {
+		addr = start;
+		size = 0;
+	}
+
+	spin_lock_irqsave(&domain->lock, flags);
+	ret = __amd_iommu_flush_pages(domain, pasid, addr, size);
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_flush_page_range);
+
 static int __amd_iommu_flush_tlb(struct protection_domain *domain, int pasid)
 {
 	INC_STATS_COUNTER(invalidate_iotlb_all);
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index 95ed6de..3919dfc 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -50,6 +50,8 @@ extern void amd_iommu_domain_direct_map(struct iommu_domain *dom);
 extern int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids);
 extern int amd_iommu_flush_page(struct iommu_domain *dom, int pasid,
 				u64 address);
+extern int amd_iommu_flush_page_range(struct iommu_domain *dom, int pasid,
+				u64 start, u64 end);
 extern int amd_iommu_flush_tlb(struct iommu_domain *dom, int pasid);
 extern int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, int pasid,
 				     unsigned long cr3);
diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 5208828..592de33f 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -90,13 +90,6 @@ static DEFINE_SPINLOCK(ps_lock);
 
 static struct workqueue_struct *iommu_wq;
 
-/*
- * Empty page table - Used between
- * mmu_notifier_invalidate_range_start and
- * mmu_notifier_invalidate_range_end
- */
-static u64 *empty_page_table;
-
 static void free_pasid_states(struct device_state *dev_state);
 static void unbind_pasid(struct device_state *dev_state, int pasid);
 static int task_exit(struct notifier_block *nb, unsigned long e, void *data);
@@ -443,22 +436,12 @@ static void mn_invalidate_range_start(struct mmu_notifier *mn,
 	pasid_state = mn_to_state(mn);
 	dev_state   = pasid_state->device_state;
 
-	amd_iommu_domain_set_gcr3(dev_state->domain, pasid_state->pasid,
-				  __pa(empty_page_table));
-}
-
-static void mn_invalidate_range_end(struct mmu_notifier *mn,
-				    struct mm_struct *mm,
-				    unsigned long start, unsigned long end)
-{
-	struct pasid_state *pasid_state;
-	struct device_state *dev_state;
-
-	pasid_state = mn_to_state(mn);
-	dev_state   = pasid_state->device_state;
-
-	amd_iommu_domain_set_gcr3(dev_state->domain, pasid_state->pasid,
-				  __pa(pasid_state->mm->pgd));
+	/*
+	 * FIXME: A low probability race exists if
+	 * IOTLB actively using page range being invalidated
+	 */
+	amd_iommu_flush_page_range(dev_state->domain,
+				pasid_state->pasid, start, end);
 }
 
 static struct mmu_notifier_ops iommu_mn = {
@@ -466,7 +449,6 @@ static struct mmu_notifier_ops iommu_mn = {
 	.change_pte             = mn_change_pte,
 	.invalidate_page        = mn_invalidate_page,
 	.invalidate_range_start = mn_invalidate_range_start,
-	.invalidate_range_end   = mn_invalidate_range_end,
 };
 
 static void set_pri_tag_status(struct pasid_state *pasid_state,
@@ -947,19 +929,11 @@ static int __init amd_iommu_v2_init(void)
 	if (iommu_wq == NULL)
 		goto out_free;
 
-	ret = -ENOMEM;
-	empty_page_table = (u64 *)get_zeroed_page(GFP_KERNEL);
-	if (empty_page_table == NULL)
-		goto out_destroy_wq;
-
 	amd_iommu_register_ppr_notifier(&ppr_nb);
 	profile_event_register(PROFILE_TASK_EXIT, &profile_nb);
 
 	return 0;
 
-out_destroy_wq:
-	destroy_workqueue(iommu_wq);
-
 out_free:
 	free_pages((unsigned long)state_table, get_order(state_table_size));
 
@@ -1000,8 +974,6 @@ static void __exit amd_iommu_v2_exit(void)
 
 	state_table_size = MAX_DEVICES * sizeof(struct device_state *);
 	free_pages((unsigned long)state_table, get_order(state_table_size));
-
-	free_page((unsigned long)empty_page_table);
 }
 
 module_init(amd_iommu_v2_init);
-- 
1.7.10.4

