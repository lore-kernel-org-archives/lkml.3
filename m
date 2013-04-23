Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab3DWVyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:54:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab3DWVyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:54:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Honig <ahonig@google.com>, Gleb Natapov <gleb@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 10/26] KVM: Allow cross page reads and writes from cached translations.
Date: Tue, 23 Apr 2013 14:53:50 -0700
Message-Id: <20130423215334.434556886@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215333.344045754@linuxfoundation.org>
References: <20130423215333.344045754@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Honig <ahonig@google.com>

commit 8f964525a121f2ff2df948dac908dcc65be21b5b upstream.

This patch adds support for kvm_gfn_to_hva_cache_init functions for
reads and writes that will cross a page.  If the range falls within
the same memslot, then this will be a fast operation.  If the range
is split between two memslots, then the slower kvm_read_guest and
kvm_write_guest are used.

Tested: Test against kvm_clock unit tests.

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c        |   13 +++++-------
 include/linux/kvm_host.h  |    2 -
 include/linux/kvm_types.h |    1 
 virt/kvm/kvm_main.c       |   47 ++++++++++++++++++++++++++++++++++++----------
 4 files changed, 45 insertions(+), 18 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1488,7 +1488,8 @@ static int kvm_pv_enable_async_pf(struct
 		return 0;
 	}
 
-	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa))
+	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
+					sizeof(u32)))
 		return 1;
 
 	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
@@ -1605,12 +1606,9 @@ int kvm_set_msr_common(struct kvm_vcpu *
 
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
@@ -1629,7 +1627,8 @@ int kvm_set_msr_common(struct kvm_vcpu *
 			return 1;
 
 		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.st.stime,
-							data & KVM_STEAL_VALID_BITS))
+						data & KVM_STEAL_VALID_BITS,
+						sizeof(struct kvm_steal_time)))
 			return 1;
 
 		vcpu->arch.st.msr_val = data;
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -427,7 +427,7 @@ int kvm_write_guest(struct kvm *kvm, gpa
 int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			   void *data, unsigned long len);
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
-			      gpa_t gpa);
+			      gpa_t gpa, unsigned long len);
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -71,6 +71,7 @@ struct gfn_to_hva_cache {
 	u64 generation;
 	gpa_t gpa;
 	unsigned long hva;
+	unsigned long len;
 	struct kvm_memory_slot *memslot;
 };
 
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1382,21 +1382,38 @@ int kvm_write_guest(struct kvm *kvm, gpa
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
@@ -1407,8 +1424,13 @@ int kvm_write_guest_cached(struct kvm *k
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
@@ -1428,8 +1450,13 @@ int kvm_read_guest_cached(struct kvm *kv
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


