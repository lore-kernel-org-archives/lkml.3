Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbaIOW32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:29:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428AbaIOWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 114/187] KVM: x86: always exit on EOIs for interrupts listed in the IOAPIC redir table
Date: Mon, 15 Sep 2014 15:08:44 -0700
Message-Id: <1410818997-9432-115-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 virt/kvm/ioapic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 39dc5bc..5eaf18f 100644
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
1.9.1

