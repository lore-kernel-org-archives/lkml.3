Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370Ab3CTIaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:30:52 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41331 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab3CTIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:30:45 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 2/7] KVM: x86: introduce memslot_set_lpage_disallowed
Date: Wed, 20 Mar 2013 16:30:22 +0800
Message-Id: <1363768227-4782-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032008-8878-0000-0000-0000065EB39C
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
index 6622ac0..e0a7f67 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6868,12 +6868,45 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 	}
 }
 
+static void
+memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
+			     unsigned long npages, int lpage_size,
+			     int lpages)
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
 int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
 {
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		unsigned long ugfn;
 		int lpages;
 		int level = i + 1;
 
@@ -6892,23 +6925,7 @@ int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
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
 
 	return 0;
-- 
1.7.7.6

