Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3EaAhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:37:41 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:46713 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3EaAgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:36:44 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v8 01/11] KVM: x86: drop calling kvm_mmu_zap_all in emulator_fix_hypercall
Date: Fri, 31 May 2013 08:36:20 +0800
Message-Id: <1369960590-14138-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053100-8878-0000-0000-00000754082B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quote Gleb's mail:

| Back then kvm->lock protected memslot access so code like:
|
| mutex_lock(&vcpu->kvm->lock);
| kvm_mmu_zap_all(vcpu->kvm);
| mutex_unlock(&vcpu->kvm->lock);
|
| which is what 7aa81cc0 does was enough to guaranty that no vcpu will
| run while code is patched. This is no longer the case and
| mutex_lock(&vcpu->kvm->lock); is gone from that code path long time ago,
| so now kvm_mmu_zap_all() there is useless and the code is incorrect.

So we drop it and it will be fixed later

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8d28810..6739b1d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5523,13 +5523,6 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	char instruction[3];
 	unsigned long rip = kvm_rip_read(vcpu);
 
-	/*
-	 * Blow out the MMU to ensure that no other VCPU has an active mapping
-	 * to ensure that the updated hypercall appears atomically across all
-	 * VCPUs.
-	 */
-	kvm_mmu_zap_all(vcpu->kvm);
-
 	kvm_x86_ops->patch_hypercall(vcpu, instruction);
 
 	return emulator_write_emulated(ctxt, rip, instruction, 3, NULL);
-- 
1.7.7.6

