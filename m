Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3DPGmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:42:20 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:42962 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3DPGmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:42:19 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 03/15] KVM: x86: do not reuse rmap when memslot is moved
Date: Tue, 16 Apr 2013 14:32:41 +0800
Message-Id: <1366093973-2617-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-3568-0000-0000-000003702D5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let kvm do not reuse the rmap of the memslot which is being moved
then the rmap of moved or deleted memslot can only be unmapped, no
new spte can be added on it.

This is good for us to unmap rmap out of mmu-lock in the later patches

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 447789c..839e666 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6939,7 +6939,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
-	if (change == KVM_MR_CREATE)
+	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
 		if (kvm_arch_create_memslot(memslot))
 			return -ENOMEM;
 
-- 
1.7.7.6

