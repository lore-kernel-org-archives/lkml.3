Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab3EGEbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:31:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759586Ab3EGEZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:56 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=MNk2TI4VpEwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tup_G-iDIkkA:10 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=jIcLH5VglJ1Io0g3xBEA:9 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035852.598268876@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Honig <ahonig@google.com>, Gleb Natapov <gleb@redhat.com>
Subject: [070/126] KVM: Allow cross page reads and writes from cached translations.
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0070-KVM-Allow-cross-page-reads-and-writes-from-cached-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Andrew Honig <ahonig@google.com>

[ Upstream commit 8f964525a121f2ff2df948dac908dcc65be21b5b ]

This patch adds support for kvm_gfn_to_hva_cache_init functions for
reads and writes that will cross a page.  If the range falls within
the same memslot, then this will be a fast operation.  If the range
is split between two memslots, then the slower kvm_read_guest and
kvm_write_guest are used.

Tested: Test against kvm_clock unit tests.

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/lapic.c      |    2 +-
 arch/x86/kvm/x86.c        |   13 ++++++-------
 include/linux/kvm_host.h  |    2 +-
 include/linux/kvm_types.h |    1 +
 virt/kvm/kvm_main.c       |   47 +++++++++++++++++++++++++++++++++++----------
 5 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ce87878..f0ecc92 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1574,5 +1574,5 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data)
 	if (!pv_eoi_enabled(vcpu))
 		return 0;
 	return kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.pv_eoi.data,
-					 addr);
+					 addr, sizeof(u8));
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2bf95c0..f7a361f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1510,7 +1510,8 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 		return 0;
 	}
 
-	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa))
+	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
+					sizeof(u32)))
 		return 1;
 
 	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
@@ -1627,12 +1628,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 
 		gpa_offset = data & ~(PAGE_MASK | 1);
 
-		/* Check that the address is 32-byte aligned. */
-		if (gpa_offset & (sizeof(struct pvclock_vcpu_time_info) - 1))
-			break;
-
 		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
-		     &vcpu->arch.pv_time, data & ~1ULL))
+		     &vcpu->arch.pv_time, data & ~1ULL,
+		     sizeof(struct pvclock_vcpu_time_info)))
 			vcpu->arch.pv_time_enabled = false;
 		else
 			vcpu->arch.pv_time_enabled = true;
@@ -1651,7 +1649,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			return 1;
 
 		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.st.stime,
-							data & KVM_STEAL_VALID_BITS))
+						data & KVM_STEAL_VALID_BITS,
+						sizeof(struct kvm_steal_time)))
 			return 1;
 
 		vcpu->arch.st.msr_val = data;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b70b48b..5a0fa66 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -456,7 +456,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			   void *data, unsigned long len);
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
-			      gpa_t gpa);
+			      gpa_t gpa, unsigned long len);
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index fa7cc72..b0bcce0 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -71,6 +71,7 @@ struct gfn_to_hva_cache {
 	u64 generation;
 	gpa_t gpa;
 	unsigned long hva;
+	unsigned long len;
 	struct kvm_memory_slot *memslot;
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d617f69..f555d95 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1393,21 +1393,38 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 }
 
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
-			      gpa_t gpa)
+			      gpa_t gpa, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	int offset = offset_in_page(gpa);
-	gfn_t gfn = gpa >> PAGE_SHIFT;
+	gfn_t start_gfn = gpa >> PAGE_SHIFT;
+	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
+	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
+	gfn_t nr_pages_avail;
 
 	ghc->gpa = gpa;
 	ghc->generation = slots->generation;
-	ghc->memslot = gfn_to_memslot(kvm, gfn);
-	ghc->hva = gfn_to_hva_many(ghc->memslot, gfn, NULL);
-	if (!kvm_is_error_hva(ghc->hva))
+	ghc->len = len;
+	ghc->memslot = gfn_to_memslot(kvm, start_gfn);
+	ghc->hva = gfn_to_hva_many(ghc->memslot, start_gfn, &nr_pages_avail);
+	if (!kvm_is_error_hva(ghc->hva) && nr_pages_avail >= nr_pages_needed) {
 		ghc->hva += offset;
-	else
-		return -EFAULT;
-
+	} else {
+		/*
+		 * If the requested region crosses two memslots, we still
+		 * verify that the entire region is valid here.
+		 */
+		while (start_gfn <= end_gfn) {
+			ghc->memslot = gfn_to_memslot(kvm, start_gfn);
+			ghc->hva = gfn_to_hva_many(ghc->memslot, start_gfn,
+						   &nr_pages_avail);
+			if (kvm_is_error_hva(ghc->hva))
+				return -EFAULT;
+			start_gfn += nr_pages_avail;
+		}
+		/* Use the slow path for cross page reads and writes. */
+		ghc->memslot = NULL;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_hva_cache_init);
@@ -1418,8 +1435,13 @@ int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	int r;
 
+	BUG_ON(len > ghc->len);
+
 	if (slots->generation != ghc->generation)
-		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa);
+		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa, ghc->len);
+
+	if (unlikely(!ghc->memslot))
+		return kvm_write_guest(kvm, ghc->gpa, data, len);
 
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
@@ -1439,8 +1461,13 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	int r;
 
+	BUG_ON(len > ghc->len);
+
 	if (slots->generation != ghc->generation)
-		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa);
+		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa, ghc->len);
+
+	if (unlikely(!ghc->memslot))
+		return kvm_read_guest(kvm, ghc->gpa, data, len);
 
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
-- 
1.7.10.4


