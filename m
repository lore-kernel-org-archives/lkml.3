Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3DAEG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 00:06:58 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33081 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3DAEGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 00:06:21 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 1/2] KVM: MMU: make kvm_mmu_zap_all preemptable
Date: Mon,  1 Apr 2013 12:06:08 +0800
Message-Id: <1364789169-11761-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364789169-11761-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1364789169-11761-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040104-9574-0000-0000-00000746B1C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_mmu_zap_all is a slow path, break the mmu-lock if needed to
avoid potential soft lockup

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 633e30c..1ebca53 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4181,12 +4181,21 @@ void kvm_mmu_zap_all(struct kvm *kvm)
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

