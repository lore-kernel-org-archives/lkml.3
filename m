Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaG3Qv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbaG3QvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:51:24 -0400
Message-ID: <1406739083.2963.78.camel@ul30vt.home>
Subject: Re: [PATCH] KVM: x86: always exit on EOIs for interrupts listed in
 the IOAPIC redir table
From: Alex Williamson <alex.williamson@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 30 Jul 2014 10:51:23 -0600
In-Reply-To: <1406736728-8516-1-git-send-email-pbonzini@redhat.com>
References: <1406736728-8516-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 18:12 +0200, Paolo Bonzini wrote:
> Currently, the EOI exit bitmap (used for APICv) does not include
> interrupts that are masked.  However, this can cause a bug that manifests
> as an interrupt storm inside the guest.  Alex Williamson reported the
> bug and is the one who really debugged this; I only wrote the patch. :)
> 
> The scenario involves a multi-function PCI device with OHCI and EHCI
> USB functions and an audio function, all assigned to the guest, where
> both USB functions use legacy INTx interrupts.
> 
> As soon as the guest boots, interrupts for these devices turn into an
> interrupt storm in the guest; the host does not see the interrupt storm.
> Basically the EOI path does not work, and the guest continues to see the
> interrupt over and over, even after it attempts to mask it at the APIC.
> The bug is only visible with older kernels (RHEL6.5, based on 2.6.32
> with not many changes in the area of APIC/IOAPIC handling).
> 
> Alex then tried forcing bit 59 (corresponding to the USB functions' IRQ)
> on in the eoi_exit_bitmap and TMR, and things then work.  What happens
> is that VFIO asserts IRQ11, then KVM recomputes the EOI exit bitmap.
> It does not have set bit 59 because the RTE was masked, so the IOAPIC
> never sees the EOI and the interrupt continues to fire in the guest.
> 
> Probably, the guest is masking the interrupt in the redirection table in
> the interrupt routine, i.e. while the interrupt is set in a LAPIC's ISR.
> The simplest fix is to ignore the masking state, we would rather have
> an unnecessary exit rather than a missed IRQ ACK and anyway IOAPIC
> interrupts are not as performance-sensitive as for example MSIs.
> 
> [Thanks to Alex for his precise description of the problem
>  and initial debugging effort.  A lot of the text above is
>  based on emails exchanged with him.]
> 
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks Paolo

Tested-by: Alex Williamson <alex.williamson@redhat.com>

> ---
>  virt/kvm/ioapic.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 2458a1dc2ba9..e8ce34c9db32 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -254,10 +254,9 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap,
>  	spin_lock(&ioapic->lock);
>  	for (index = 0; index < IOAPIC_NUM_PINS; index++) {
>  		e = &ioapic->redirtbl[index];
> -		if (!e->fields.mask &&
> -			(e->fields.trig_mode == IOAPIC_LEVEL_TRIG ||
> -			 kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC,
> -				 index) || index == RTC_GSI)) {
> +		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG ||
> +		    kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index) ||
> +		    index == RTC_GSI) {
>  			if (kvm_apic_match_dest(vcpu, NULL, 0,
>  				e->fields.dest_id, e->fields.dest_mode)) {
>  				__set_bit(e->fields.vector,



