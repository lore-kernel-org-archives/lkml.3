Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaAMQBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:01:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52888 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaAMQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu Ping Fan <pingfank@linux.vnet.ibm.com>, Alexander Graf <agraf@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 022/208] powerpc: kvm: fix rare but potential deadlock scene
Date: Mon, 13 Jan 2014 15:57:43 +0000
Message-Id: <1389628849-1614-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: pingfan liu <qemulist@gmail.com>

commit 91648ec09c1ef69c4d840ab6dab391bfb452d554 upstream.

Since kvmppc_hv_find_lock_hpte() is called from both virtmode and
realmode, so it can trigger the deadlock.

Suppose the following scene:

Two physical cpuM, cpuN, two VM instances A, B, each VM has a group of
vcpus.

If on cpuM, vcpu_A_1 holds bitlock X (HPTE_V_HVLOCK), then is switched
out, and on cpuN, vcpu_A_2 try to lock X in realmode, then cpuN will be
caught in realmode for a long time.

What makes things even worse if the following happens,
  On cpuM, bitlockX is hold, on cpuN, Y is hold.
  vcpu_B_2 try to lock Y on cpuM in realmode
  vcpu_A_2 try to lock X on cpuN in realmode

Oops! deadlock happens

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Reviewed-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 6 +++++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c | 4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 710d313..4b29ca8 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -473,11 +473,14 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 		slb_v = vcpu->kvm->arch.vrma_slb_v;
 	}
 
+	preempt_disable();
 	/* Find the HPTE in the hash table */
 	index = kvmppc_hv_find_lock_hpte(kvm, eaddr, slb_v,
 					 HPTE_V_VALID | HPTE_V_ABSENT);
-	if (index < 0)
+	if (index < 0) {
+		preempt_enable();
 		return -ENOENT;
+	}
 	hptep = (unsigned long *)(kvm->arch.hpt_virt + (index << 4));
 	v = hptep[0] & ~HPTE_V_HVLOCK;
 	gr = kvm->arch.revmap[index].guest_rpte;
@@ -485,6 +488,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	/* Unlock the HPTE */
 	asm volatile("lwsync" : : : "memory");
 	hptep[0] = v;
+	preempt_enable();
 
 	gpte->eaddr = eaddr;
 	gpte->vpage = ((v & HPTE_V_AVPN) << 4) | ((eaddr >> 12) & 0xfff);
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index fc25689..305b555 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -722,6 +722,10 @@ static int slb_base_page_shift[4] = {
 	20,	/* 1M, unsupported */
 };
 
+/* When called from virtmode, this func should be protected by
+ * preempt_disable(), otherwise, the holding of HPTE_V_HVLOCK
+ * can trigger deadlock issue.
+ */
 long kvmppc_hv_find_lock_hpte(struct kvm *kvm, gva_t eaddr, unsigned long slb_v,
 			      unsigned long valid)
 {
-- 
1.8.3.2

