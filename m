Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3LRVLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:11:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3LRVLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:11:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars Bull <larsbull@google.com>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.10 16/78] KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)
Date: Wed, 18 Dec 2013 13:10:44 -0800
Message-Id: <20131218211112.364315650@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Natapov <gleb@redhat.com>

commit 17d68b763f09a9ce824ae23eb62c9efc57b69271 upstream.

A guest can cause a BUG_ON() leading to a host kernel crash.
When the guest writes to the ICR to request an IPI, while in x2apic
mode the following things happen, the destination is read from
ICR2, which is a register that the guest can control.

kvm_irq_delivery_to_apic_fast uses the high 16 bits of ICR2 as the
cluster id.  A BUG_ON is triggered, which is a protection against
accessing map->logical_map with an out-of-bounds access and manages
to avoid that anything really unsafe occurs.

The logic in the code is correct from real HW point of view. The problem
is that KVM supports only one cluster with ID 0 in clustered mode, but
the code that has the bug does not take this into account.

Reported-by: Lars Bull <larsbull@google.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -153,6 +153,8 @@ static inline int kvm_apic_id(struct kvm
 	return (kvm_apic_get_reg(apic, APIC_ID) >> 24) & 0xff;
 }
 
+#define KVM_X2APIC_CID_BITS 0
+
 static void recalculate_apic_map(struct kvm *kvm)
 {
 	struct kvm_apic_map *new, *old = NULL;
@@ -190,7 +192,8 @@ static void recalculate_apic_map(struct
 		if (apic_x2apic_mode(apic)) {
 			new->ldr_bits = 32;
 			new->cid_shift = 16;
-			new->cid_mask = new->lid_mask = 0xffff;
+			new->cid_mask = (1 << KVM_X2APIC_CID_BITS) - 1;
+			new->lid_mask = 0xffff;
 		} else if (kvm_apic_sw_enabled(apic) &&
 				!new->cid_mask /* flat mode */ &&
 				kvm_apic_get_reg(apic, APIC_DFR) == APIC_DFR_CLUSTER) {


