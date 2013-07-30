Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3G3NDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:03:34 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47761 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3G3ND3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:03:29 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 04/12] KVM: MMU: log dirty page after marking spte writable
Date: Tue, 30 Jul 2013 21:02:02 +0800
Message-Id: <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073012-1396-0000-0000-000003565060
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we can see the writable spte before the dirt bitmap is visible

We do this is for kvm_vm_ioctl_get_dirty_log() write-protects the spte based
on the dirty bitmap, we should ensure the writable spte can be found in rmap
before the dirty bitmap is visible. Otherwise, we cleared the dirty bitmap and
failed to write-protect the page

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 35d4b50..0fe56ad 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2486,12 +2486,12 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		}
 	}
 
-	if (pte_access & ACC_WRITE_MASK)
-		mark_page_dirty(vcpu->kvm, gfn);
-
 set_pte:
 	if (mmu_spte_update(sptep, spte))
 		kvm_flush_remote_tlbs(vcpu->kvm);
+
+	if (pte_access & ACC_WRITE_MASK)
+		mark_page_dirty(vcpu->kvm, gfn);
 done:
 	return ret;
 }
-- 
1.8.1.4

