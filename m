Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935449AbaICXnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:43:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333AbaICWF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:05:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.10 29/55] KVM: x86: always exit on EOIs for interrupts listed in the IOAPIC redir table
Date: Wed,  3 Sep 2014 15:05:19 -0700
Message-Id: <20140903220458.667203431@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/ioapic.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -203,10 +203,9 @@ void kvm_ioapic_scan_entry(struct kvm_vc
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


