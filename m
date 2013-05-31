Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3EaAia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:38:30 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:42537 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3EaAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:37:00 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v8 11/11] KVM: MMU: reduce KVM_REQ_MMU_RELOAD when root page is zapped
Date: Fri, 31 May 2013 08:36:30 +0800
Message-Id: <1369960590-14138-12-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053100-4790-0000-0000-0000088CB3E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Quote Gleb's mail:
| why don't we check for sp->role.invalid in
| kvm_mmu_prepare_zap_page before calling kvm_reload_remote_mmus()?

and

| Actually we can add check for is_obsolete_sp() there too since
| kvm_mmu_invalidate_all_pages() already calls kvm_reload_remote_mmus()
| after incrementing mmu_valid_gen.

[ Xiao: add some comments and the check of is_obsolete_sp() ]

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 79af88a..6941fa7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2108,7 +2108,13 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 		kvm_mod_used_mmu_pages(kvm, -1);
 	} else {
 		list_move(&sp->link, &kvm->arch.active_mmu_pages);
-		kvm_reload_remote_mmus(kvm);
+
+		/*
+		 * The obsolete pages can not be used on any vcpus.
+		 * See the comments in kvm_mmu_invalidate_zap_all_pages().
+		 */
+		if (!sp->role.invalid && !is_obsolete_sp(kvm, sp))
+			kvm_reload_remote_mmus(kvm);
 	}
 
 	sp->role.invalid = 1;
-- 
1.7.7.6

