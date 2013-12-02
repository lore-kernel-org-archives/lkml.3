Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab3LBV0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:26:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab3LBTHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:07:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.4 55/60] KVM: perform an invalid memslot step for gpa base change
Date: Mon,  2 Dec 2013 11:06:36 -0800
Message-Id: <20131202190342.319816544@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 12d6e7538e2d418c08f082b1b44ffa5fb7270ed8 upstream.

PPC must flush all translations before the new memory slot
is visible.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/kvm_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -774,7 +774,7 @@ int __kvm_set_memory_region(struct kvm *
 		/* destroy any largepage mappings for dirty tracking */
 	}
 
-	if (!npages) {
+	if (!npages || base_gfn != old.base_gfn) {
 		struct kvm_memory_slot *slot;
 
 		r = -ENOMEM;
@@ -790,8 +790,8 @@ int __kvm_set_memory_region(struct kvm *
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
-		/* From this point no new shadow pages pointing to a deleted
-		 * memslot will be created.
+		/* From this point no new shadow pages pointing to a deleted,
+		 * or moved, memslot will be created.
 		 *
 		 * validation of sp->gfn happens in:
 		 * 	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)


