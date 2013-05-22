Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3EVT4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:56:32 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45521 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab3EVT40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:56:26 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v7 11/11] KVM: MMU: reduce KVM_REQ_MMU_RELOAD when root page is zapped
Date: Thu, 23 May 2013 03:56:00 +0800
Message-Id: <1369252560-11611-12-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052219-1396-0000-0000-000003027D20
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
index 5e34056..055d675 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2097,7 +2097,13 @@ __kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
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

