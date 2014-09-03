Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbaICJ6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:58:12 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57440 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932348AbaICJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 45/56] KVM: x86: always exit on EOIs for interrupts listed in the IOAPIC redir table
Date: Wed,  3 Sep 2014 11:27:04 +0200
Message-Id: <46497989e1a3a3665cdf51475e21bc02ce106501.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0f6c0a740b7d3e1f3697395922d674000f83d060 upstream.

Currently, the EOI exit bitmap (used for APICv) does not include
interrupts that are masked.  However, this can cause a bug that manifests
as an interrupt storm inside the guest.  Alex Williamson reported the
bug and is the one who really debugged this; I only wrote the patch. :)

The scenario involves a multi-function PCI device with OHCI and EHCI
USB functions and an audio function, all assigned to the guest, where
both USB functions use legacy INTx interrupts.

As soon as the guest boots, interrupts for these devices turn into an
interrupt storm in the guest; the host does not see the interrupt storm.
Basically the EOI path does not work, and the guest continues to see the
interrupt over and over, even after it attempts to mask it at the APIC.
The bug is only visible with older kernels (RHEL6.5, based on 2.6.32
with not many changes in the area of APIC/IOAPIC handling).

Alex then tried forcing bit 59 (corresponding to the USB functions' IRQ)
on in the eoi_exit_bitmap and TMR, and things then work.  What happens
is that VFIO asserts IRQ11, then KVM recomputes the EOI exit bitmap.
It does not have set bit 59 because the RTE was masked, so the IOAPIC
never sees the EOI and the interrupt continues to fire in the guest.

My guess was that the guest is masking the interrupt in the redirection
table in the interrupt routine, i.e. while the interrupt is set in a
LAPIC's ISR, The simplest fix is to ignore the masking state, we would
rather have an unnecessary exit rather than a missed IRQ ACK and anyway
IOAPIC interrupts are not as performance-sensitive as for example MSIs.
Alex tested this patch and it fixed his bug.

[Thanks to Alex for his precise description of the problem
 and initial debugging effort.  A lot of the text above is
 based on emails exchanged with him.]

Reported-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 virt/kvm/ioapic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 39dc5bc742e0..5eaf18f90e83 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -203,10 +203,9 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap,
 	spin_lock(&ioapic->lock);
 	for (index = 0; index < IOAPIC_NUM_PINS; index++) {
 		e = &ioapic->redirtbl[index];
-		if (!e->fields.mask &&
-			(e->fields.trig_mode == IOAPIC_LEVEL_TRIG ||
-			 kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC,
-				 index) || index == RTC_GSI)) {
+		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG ||
+		    kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index) ||
+		    index == RTC_GSI) {
 			if (kvm_apic_match_dest(vcpu, NULL, 0,
 				e->fields.dest_id, e->fields.dest_mode)) {
 				__set_bit(e->fields.vector,
-- 
2.1.0

