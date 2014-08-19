Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaHSI2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaHSI2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:28:31 -0400
Message-ID: <53F30AA4.4050803@redhat.com>
Date: Tue, 19 Aug 2014 10:28:20 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        David Matlack <dmatlack@google.com>
CC: Gleb Natapov <gleb@kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com> <53F24A49.2010807@redhat.com> <A07DA8BD-8756-427D-9925-B8696E47C73A@gmail.com> <CALzav=fNoXeStA6ETDW0tNqyXBxWN0i8N5P-Ht7jtwgS_r7qmw@mail.gmail.com> <53F2C997.6070605@linux.vnet.ibm.com>
In-Reply-To: <53F2C997.6070605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2014 05:50, Xiao Guangrong ha scritto:
> 
> Note in the step *, my approach detects the invalid generation-number which
> will invalidate the mmio spte properly .

You are right, in fact my mail included another part: "Another 
alternative could be to use the low bit to mark an in-progress change, 
*and skip the caching if the low bit is set*."

I think if you always treat the low bit as zero in mmio sptes, you can 
do that without losing a bit of the generation.

Something like this (untested/uncompiled):

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 931467881da7..3a56d377c6d7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -199,16 +199,20 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask)
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
 /*
- * spte bits of bit 3 ~ bit 11 are used as low 9 bits of generation number,
- * the bits of bits 52 ~ bit 61 are used as high 10 bits of generation
- * number.
+ * the low bit of the generation number is always presumed to be zero.
+ * This disables mmio caching during memslot updates.  The concept is
+ * similar to a seqcount but instead of retrying the access we just punt
+ * and ignore the cache.
+ *
+ * spte bits 3-11 are used as bits 1-9 of the generation number,
+ * the bits 52-61 are used as bits 10-19 of the generation number.
  */
-#define MMIO_SPTE_GEN_LOW_SHIFT		3
+#define MMIO_SPTE_GEN_LOW_SHIFT		2
 #define MMIO_SPTE_GEN_HIGH_SHIFT	52
 
-#define MMIO_GEN_SHIFT			19
-#define MMIO_GEN_LOW_SHIFT		9
-#define MMIO_GEN_LOW_MASK		((1 << MMIO_GEN_LOW_SHIFT) - 1)
+#define MMIO_GEN_SHIFT			20
+#define MMIO_GEN_LOW_SHIFT		10
+#define MMIO_GEN_LOW_MASK		((1 << MMIO_GEN_LOW_SHIFT) - 2)
 #define MMIO_GEN_MASK			((1 << MMIO_GEN_SHIFT) - 1)
 #define MMIO_MAX_GEN			((1 << MMIO_GEN_SHIFT) - 1)
 
@@ -236,12 +240,7 @@ static unsigned int get_mmio_spte_generation(u64 spte)
 
 static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
 {
-	/*
-	 * Init kvm generation close to MMIO_MAX_GEN to easily test the
-	 * code of handling generation number wrap-around.
-	 */
-	return (kvm_memslots(kvm)->generation +
-		      MMIO_MAX_GEN - 150) & MMIO_GEN_MASK;
+	return kvm_memslots(kvm)->generation & MMIO_GEN_MASK;
 }
 
 static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a69a623938b8..c7e2800313b8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -474,6 +476,13 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!kvm->memslots)
 		goto out_err_no_srcu;
+
+	/*
+	 * Init kvm generation close to MMIO_MAX_GEN to easily test the
+	 * code of handling generation number wrap-around.
+	 */
+	kvm->memslots->generation = -150;
+
 	kvm_init_memslots_id(kvm);
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
@@ -725,6 +732,8 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	synchronize_srcu_expedited(&kvm->srcu);
 
 	kvm_arch_memslots_updated(kvm);
+	slots->generation++;
+	WARN_ON(slots->generation & 1);
 
 	return old_memslots;
 }

(modulo the changes to always set the generation in install_new_memslots, which
I'm eliding for clarity).

Moving the initialization to kvm_create_vm ensures that the low bit is untouched
between install_new_memslots and kvm_current_mmio_generation.
