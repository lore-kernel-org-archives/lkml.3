Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbaAFXaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:30:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbaAFWkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Ping Fan <pingfank@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>
Subject: [PATCH 3.10 004/129] powerpc: kvm: fix rare but potential deadlock scene
Date: Mon,  6 Jan 2014 14:37:13 -0800
Message-Id: <20140106223859.715653298@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_64_mmu_hv.c |    6 +++++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c |    4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -473,11 +473,14 @@ static int kvmppc_mmu_book3s_64_hv_xlate
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
@@ -485,6 +488,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate
 	/* Unlock the HPTE */
 	asm volatile("lwsync" : : : "memory");
 	hptep[0] = v;
+	preempt_enable();
 
 	gpte->eaddr = eaddr;
 	gpte->vpage = ((v & HPTE_V_AVPN) << 4) | ((eaddr >> 12) & 0xfff);
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -724,6 +724,10 @@ static int slb_base_page_shift[4] = {
 	20,	/* 1M, unsupported */
 };
 
+/* When called from virtmode, this func should be protected by
+ * preempt_disable(), otherwise, the holding of HPTE_V_HVLOCK
+ * can trigger deadlock issue.
+ */
 long kvmppc_hv_find_lock_hpte(struct kvm *kvm, gva_t eaddr, unsigned long slb_v,
 			      unsigned long valid)
 {


