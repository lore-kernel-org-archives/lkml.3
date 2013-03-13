Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab3CME5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:57:49 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59348 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3CME5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:57:48 -0400
Message-ID: <5140072E.30008@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 12:57:18 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/6] KVM: x86: introduce memslot_set_lpage_disallowed
References: <514006AC.2020904@linux.vnet.ibm.com>
In-Reply-To: <514006AC.2020904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031304-3568-0000-0000-00000347E263
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
index 7083568..2cf3722 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6847,12 +6847,45 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
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

@@ -6871,23 +6904,7 @@ int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
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

