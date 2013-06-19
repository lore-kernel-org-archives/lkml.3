Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430Ab3FSJJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:09:51 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41480 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934376Ab3FSJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:09:48 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 6/7] KVM: MMU: document fast invalidate all pages
Date: Wed, 19 Jun 2013 17:09:24 +0800
Message-Id: <1371632965-20077-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061909-6102-0000-0000-000003B9AFE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document it to Documentation/virtual/kvm/mmu.txt

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/mmu.txt | 23 +++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h   |  5 +++++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index b5ce7dd..f5c4de9 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -210,6 +210,10 @@ Shadow pages contain the following information:
     A bitmap indicating which sptes in spt point (directly or indirectly) at
     pages that may be unsynchronized.  Used to quickly locate all unsychronized
     pages reachable from a given page.
+  mmu_valid_gen:
+    It is the generation number of the page which cooperates with
+    kvm->arch.mmu_valid_gen to fast invalidate all pages.
+    (see "Fast invalidate all pages" below.)
   clear_spte_count:
     It is only used on 32bit host which helps us to detect whether updating the
     64bit spte is complete so that we can avoid reading the truncated value out
@@ -373,6 +377,25 @@ causes its write_count to be incremented, thus preventing instantiation of
 a large spte.  The frames at the end of an unaligned memory slot have
 artificially inflated ->write_counts so they can never be instantiated.
 
+Fast invalidate all pages
+===========
+For the large memory and large vcpus guests, zapping all pages is a challenge
+since they have large number of pages need to be zapped, walking and zapping
+these pages are really slow and it should hold mmu-lock which stops the memory
+access on all vcpus.
+
+To make it be more scalable, kvm maintains a global mmu valid
+generation-number which is stored in kvm->arch.mmu_valid_gen and every shadow
+page stores the current global generation-number into sp->mmu_valid_gen when
+it is created.
+
+When KVM need zap all shadow pages sptes, it just simply increases the global
+generation-number then reload root shadow pages on all vcpus. Vcpu will create
+a new shadow page table according to current kvm's generation-number. It
+ensures the old pages are not used any more. The invalid-gen pages
+(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen) are zapped by using lock-break
+technique.
+
 Further reading
 ===============
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5eb5382..c4f90f6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -222,6 +222,11 @@ struct kvm_mmu_page {
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
+
+	/*
+	 * the generation number of the page which cooperates with
+	 * kvm->arch.mmu_valid_gen to fast invalidate all pages.
+	 */
 	unsigned long mmu_valid_gen;
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
-- 
1.8.1.4

