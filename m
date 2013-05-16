Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3EPVOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:14:25 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48914 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab3EPVNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:13:22 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v6 4/7] KVM: MMU: zap pages in batch
Date: Fri, 17 May 2013 05:12:59 +0800
Message-Id: <1368738782-18649-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051621-3864-0000-0000-0000082F48F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zap at lease 10 pages before releasing mmu-lock to reduce the overload
caused by requiring lock

[ It improves kernel building 0.6% ~ 1% ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 891ad2c..7ad0e50 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4207,14 +4207,18 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
+#define BATCH_ZAP_PAGES	10
 static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
+	int batch = 0;
 
 restart:
 	list_for_each_entry_safe_reverse(sp, node,
 	      &kvm->arch.active_mmu_pages, link) {
+		int ret;
+
 		/*
 		 * No obsolete page exists before new created page since
 		 * active_mmu_pages is the FIFO list.
@@ -4252,10 +4256,16 @@ restart:
 		 * Need not flush tlb since we only zap the sp with invalid
 		 * generation number.
 		 */
-		if (cond_resched_lock(&kvm->mmu_lock))
+		if ((batch >= BATCH_ZAP_PAGES) &&
+		      cond_resched_lock(&kvm->mmu_lock)) {
+			batch = 0;
 			goto restart;
+		}
 
-		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
+		ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+		batch += ret;
+
+		if (ret)
 			goto restart;
 	}
 
-- 
1.7.7.6

