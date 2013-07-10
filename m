Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3GJIX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:23:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab3GJIXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:23:24 -0400
Date: Wed, 10 Jul 2013 11:24:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] kvm: reset arch memslot info on memslot creation
Message-ID: <20130710082439.GA1482@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86, kvm_arch_create_memslot assumes that rmap/lpage_info for the
slot are zeroed out: if they weren't, error handling code after out_free
label will free memory which wasn't allocated here.
This always happens to be the case because on KVM_MR_DELETE we clear the
whole arch structure.  So there's no bug, but it's cleaner not to rely
on this here.

Make the code more robust by clearing the rmap/lpage_info explicitly.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e8ba99c..96e6eb4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6922,6 +6922,10 @@ int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
 {
 	int i;
 
+	/* Reset in case slot had some rmap/lpage_info. */
+	memset(&slot->arch.rmap, 0, sizeof slot->arch.rmap);
+	memset(&slot->arch.lpage_info, 0, sizeof slot->arch.lpage_info);
+
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
 		unsigned long ugfn;
 		int lpages;
-- 
MST
