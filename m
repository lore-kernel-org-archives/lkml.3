Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3D0DOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 23:14:02 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51405 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3D0DNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 23:13:33 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v4 2/6] KVM: x86: introduce memslot_set_lpage_disallowed
Date: Sat, 27 Apr 2013 11:13:18 +0800
Message-Id: <1367032402-13729-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042703-2000-0000-0000-00000BE33E56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is used to set disallowed large page on the specified level, can be
used in later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   53 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91dd9f4..52b4e97 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6917,12 +6917,45 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
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
 int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
 {
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		unsigned long ugfn;
 		int lpages;
 		int level = i + 1;
 
@@ -6941,23 +6974,7 @@ int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
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

