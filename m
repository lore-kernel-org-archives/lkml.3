Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967323AbaLLG7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:59:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51711 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758499AbaLLGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Matlack" <dmatlack@google.com>,
        "Xiao Guangrong" <xiaoguangrong@linux.vnet.ibm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.401836014@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 001/164] kvm: x86: fix stale mmio cache bug
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.c              |  2 +-
 arch/x86/kvm/x86.h              | 20 +++++++++++++++-----
 3 files changed, 17 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -435,6 +435,7 @@ struct kvm_vcpu_arch {
 	u64 mmio_gva;
 	unsigned access;
 	gfn_t mmio_gfn;
+	u64 mmio_gen;
 
 	/* used for guest single stepping over the given code position */
 	unsigned long singlestep_rip;
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2842,7 +2842,7 @@ static void mmu_sync_roots(struct kvm_vc
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
 
-	vcpu_clear_mmio_info(vcpu, ~0ul);
+	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -81,15 +81,23 @@ static inline void vcpu_cache_mmio_info(
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
@@ -97,7 +105,8 @@ static inline void vcpu_clear_mmio_info(
 
 static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned long gva)
 {
-	if (vcpu->arch.mmio_gva && vcpu->arch.mmio_gva == (gva & PAGE_MASK))
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gva &&
+	      vcpu->arch.mmio_gva == (gva & PAGE_MASK))
 		return true;
 
 	return false;
@@ -105,7 +114,8 @@ static inline bool vcpu_match_mmio_gva(s
 
 static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
-	if (vcpu->arch.mmio_gfn && vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gfn &&
+	      vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
 		return true;
 
 	return false;

