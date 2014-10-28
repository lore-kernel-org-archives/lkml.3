Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaJ1DnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:43:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaJ1DnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:43:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.16 013/127] kvm: x86: fix stale mmio cache bug
Date: Tue, 28 Oct 2014 11:34:08 +0800
Message-Id: <20141028033421.499711621@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

commit 56f17dd3fbc44adcdbc3340fe3988ddb833a47a7 upstream.

The following events can lead to an incorrect KVM_EXIT_MMIO bubbling
up to userspace:

(1) Guest accesses gpa X without a memory slot. The gfn is cached in
struct kvm_vcpu_arch (mmio_gfn). On Intel EPT-enabled hosts, KVM sets
the SPTE write-execute-noread so that future accesses cause
EPT_MISCONFIGs.

(2) Host userspace creates a memory slot via KVM_SET_USER_MEMORY_REGION
covering the page just accessed.

(3) Guest attempts to read or write to gpa X again. On Intel, this
generates an EPT_MISCONFIG. The memory slot generation number that
was incremented in (2) would normally take care of this but we fast
path mmio faults through quickly_check_mmio_pf(), which only checks
the per-vcpu mmio cache. Since we hit the cache, KVM passes a
KVM_EXIT_MMIO up to userspace.

This patch fixes the issue by using the memslot generation number
to validate the mmio cache.

Signed-off-by: David Matlack <dmatlack@google.com>
[xiaoguangrong: adjust the code to make it simpler for stable-tree fix.]
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Tested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    2 +-
 arch/x86/kvm/x86.h              |   20 +++++++++++++++-----
 3 files changed, 17 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -479,6 +479,7 @@ struct kvm_vcpu_arch {
 	u64 mmio_gva;
 	unsigned access;
 	gfn_t mmio_gfn;
+	u64 mmio_gen;
 
 	struct kvm_pmu pmu;
 
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3163,7 +3163,7 @@ static void mmu_sync_roots(struct kvm_vc
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
 
-	vcpu_clear_mmio_info(vcpu, ~0ul);
+	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 	kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -78,15 +78,23 @@ static inline void vcpu_cache_mmio_info(
 	vcpu->arch.mmio_gva = gva & PAGE_MASK;
 	vcpu->arch.access = access;
 	vcpu->arch.mmio_gfn = gfn;
+	vcpu->arch.mmio_gen = kvm_memslots(vcpu->kvm)->generation;
+}
+
+static inline bool vcpu_match_mmio_gen(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mmio_gen == kvm_memslots(vcpu->kvm)->generation;
 }
 
 /*
- * Clear the mmio cache info for the given gva,
- * specially, if gva is ~0ul, we clear all mmio cache info.
+ * Clear the mmio cache info for the given gva. If gva is MMIO_GVA_ANY, we
+ * clear all mmio cache info.
  */
+#define MMIO_GVA_ANY (~(gva_t)0)
+
 static inline void vcpu_clear_mmio_info(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	if (gva != (~0ul) && vcpu->arch.mmio_gva != (gva & PAGE_MASK))
+	if (gva != MMIO_GVA_ANY && vcpu->arch.mmio_gva != (gva & PAGE_MASK))
 		return;
 
 	vcpu->arch.mmio_gva = 0;
@@ -94,7 +102,8 @@ static inline void vcpu_clear_mmio_info(
 
 static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned long gva)
 {
-	if (vcpu->arch.mmio_gva && vcpu->arch.mmio_gva == (gva & PAGE_MASK))
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gva &&
+	      vcpu->arch.mmio_gva == (gva & PAGE_MASK))
 		return true;
 
 	return false;
@@ -102,7 +111,8 @@ static inline bool vcpu_match_mmio_gva(s
 
 static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
-	if (vcpu->arch.mmio_gfn && vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gfn &&
+	      vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
 		return true;
 
 	return false;


