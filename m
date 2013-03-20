Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475Ab3CTIba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:31:30 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49964 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934445Ab3CTIbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:31:04 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 5/7] KVM: MMU: split kvm_mmu_prepare_zap_page
Date: Wed, 20 Mar 2013 16:30:25 +0800
Message-Id: <1363768227-4782-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032008-5816-0000-0000-000007304B00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then the new function __kvm_mmu_prepare_zap_page only zaps the shadow page
without KVM_REQ_MMU_RELOAD. Later, we will use it to batch free root shadow
pages

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5578c91..e880cdd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2066,8 +2066,9 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 	return zapped;
 }
 
-static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-				    struct list_head *invalid_list)
+static int
+__kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			   struct list_head *invalid_list)
 {
 	int ret;
 
@@ -2088,15 +2089,24 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 		ret++;
 		list_move(&sp->link, invalid_list);
 		kvm_mod_used_mmu_pages(kvm, -1);
-	} else {
+	} else
 		list_move(&sp->link, &kvm->arch.active_mmu_pages);
-		kvm_reload_remote_mmus(kvm);
-	}
 
 	sp->role.invalid = 1;
 	return ret;
 }
 
+static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				    struct list_head *invalid_list)
+{
+	int ret = __kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+
+	if (sp->root_count)
+		kvm_reload_remote_mmus(kvm);
+
+	return ret;
+}
+
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list)
 {
-- 
1.7.7.6

