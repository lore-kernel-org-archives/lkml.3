Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3D0DOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 23:14:14 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55359 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab3D0DNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 23:13:37 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v4 6/6] KVM: MMU: make kvm_mmu_zap_all preemptable
Date: Sat, 27 Apr 2013 11:13:22 +0800
Message-Id: <1367032402-13729-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042703-4790-0000-0000-0000080A3CFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, kvm_mmu_zap_all is only called in the path of mmu_notifier->release,
at that time, vcpu has stopped that means no new page will be create, we
can use lock-break technique to avoid potential soft lockup

(Note: at this time, the mmu-lock still has contention between ->release
 and other mmu-notify handlers.)

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 63110c7..46d1d47 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4197,12 +4197,21 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
 
+	might_sleep();
+
 	spin_lock(&kvm->mmu_lock);
 restart:
-	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
+	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
 		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
 			goto restart;
 
+		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			cond_resched_lock(&kvm->mmu_lock);
+			goto restart;
+		}
+	}
+
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	spin_unlock(&kvm->mmu_lock);
 }
-- 
1.7.7.6

