Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaJ1DnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:43:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaJ1DnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:43:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.16 015/127] KVM: do not bias the generation number in kvm_current_mmio_generation
Date: Tue, 28 Oct 2014 11:34:10 +0800
Message-Id: <20141028033421.591164195@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit 00f034a12fdd81210d58116326d92780aac5c238 upstream.

The next patch will give a meaning (a la seqcount) to the low bit of the
generation number.  Ensure that it matches between kvm->memslots->generation
and kvm_current_mmio_generation().

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c  |    7 +------
 virt/kvm/kvm_main.c |    7 +++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -240,12 +240,7 @@ static unsigned int get_mmio_spte_genera
 
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
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -472,6 +472,13 @@ static struct kvm *kvm_create_vm(unsigne
 	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!kvm->memslots)
 		goto out_err_no_srcu;
+
+	/*
+	 * Init kvm generation close to the maximum to easily test the
+	 * code of handling generation number wrap-around.
+	 */
+	kvm->memslots->generation = -150;
+
 	kvm_init_memslots_id(kvm);
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;


