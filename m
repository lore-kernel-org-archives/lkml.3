Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3DPGfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:35:19 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41835 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab3DPGfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:35:16 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 10/15] KVM: x86: introduce memslot_set_lpage_disallowed
Date: Tue, 16 Apr 2013 14:32:48 +0800
Message-Id: <1366093973-2617-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-9574-0000-0000-0000077A8B77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is used to set disallowed lage page on the specified level, can be
used in later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   53 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bec83cd..0c5bb2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6875,13 +6875,46 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 	}
 }
 
+static void memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
+					 unsigned long npages,
+					 int lpage_size, int lpages)
+{
+	struct kvm_lpage_info *lpage_info;
+	unsigned long ugfn;
+	int level = lpage_size + 1;
+
+	WARN_ON(!lpage_size);
+
+	lpage_info = slot->arch.lpage_info[lpage_size - 1];
+
+	if (slot->base_gfn & (KVM_PAGES_PER_HPAGE(level) - 1))
+		lpage_info[0].write_count = 1;
+
+	if ((slot->base_gfn + npages) & (KVM_PAGES_PER_HPAGE(level) - 1))
+		lpage_info[lpages - 1].write_count = 1;
+
+	ugfn = slot->userspace_addr >> PAGE_SHIFT;
+
+	/*
+	 * If the gfn and userspace address are not aligned wrt each
+	 * other, or if explicitly asked to, disable large page
+	 * support for this slot
+	 */
+	if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1) ||
+	      !kvm_largepages_enabled()) {
+		unsigned long j;
+
+		for (j = 0; j < lpages; ++j)
+			lpage_info[j].write_count = 1;
+	}
+}
+
 static int kvm_arch_create_memslot(struct kvm_memory_slot *slot)
 {
 	unsigned long npages = slot->npages;
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		unsigned long ugfn;
 		int lpages;
 		int level = i + 1;
 
@@ -6900,23 +6933,7 @@ static int kvm_arch_create_memslot(struct kvm_memory_slot *slot)
 		if (!slot->arch.lpage_info[i - 1])
 			goto out_free;
 
-		if (slot->base_gfn & (KVM_PAGES_PER_HPAGE(level) - 1))
-			slot->arch.lpage_info[i - 1][0].write_count = 1;
-		if ((slot->base_gfn + npages) & (KVM_PAGES_PER_HPAGE(level) - 1))
-			slot->arch.lpage_info[i - 1][lpages - 1].write_count = 1;
-		ugfn = slot->userspace_addr >> PAGE_SHIFT;
-		/*
-		 * If the gfn and userspace address are not aligned wrt each
-		 * other, or if explicitly asked to, disable large page
-		 * support for this slot
-		 */
-		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1) ||
-		    !kvm_largepages_enabled()) {
-			unsigned long j;
-
-			for (j = 0; j < lpages; ++j)
-				slot->arch.lpage_info[i - 1][j].write_count = 1;
-		}
+		memslot_set_lpage_disallowed(slot, npages, i, lpages);
 	}
 
 	init_memslot_rmap_ops(slot);
-- 
1.7.7.6

