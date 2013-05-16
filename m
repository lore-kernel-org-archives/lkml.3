Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3EPMSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:18:33 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59073 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab3EPMSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:18:15 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 8/8] KVM: MMU: zap pages in batch
Date: Thu, 16 May 2013 20:17:53 +0800
Message-Id: <1368706673-8530-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051612-3864-0000-0000-0000082D9AB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zap at lease 10 pages before releasing mmu-lock to reduce the overload
caused by requiring lock

[ It improves kernel building 0.6% ~ 1% ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e12f431..9c27fda 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4216,10 +4216,12 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
+#define BATCH_ZAP_PAGES	10
 static void zap_invalid_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
+	int batch = 0;
 
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
@@ -4256,11 +4258,14 @@ restart:
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
-			goto restart;
+		batch += kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+		goto restart;
 	}
 
 	/*
-- 
1.7.7.6

