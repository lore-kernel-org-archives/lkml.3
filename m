Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaHFOEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:04:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:4735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaHFOED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:04:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,812,1400050800"; 
   d="scan'208";a="584214415"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] KVM: x86: always exit on EOIs for interrupts listed in
 the IOAPIC redir table
Thread-Topic: [PATCH] KVM: x86: always exit on EOIs for interrupts listed in
 the IOAPIC redir table
Thread-Index: AQHPrBEkMevXzPHWyEW1NdRMjvzN+JvDpASg
Date: Wed, 6 Aug 2014 14:03:56 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AB51BA1@SHSMSX104.ccr.corp.intel.com>
References: <1406736728-8516-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1406736728-8516-1-git-send-email-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini wrote on 2014-07-31:
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

I feel this fixing may hurt performance in some cases. If the mask bit is set, this means the vector in this entry may be used by other devices(like a assigned device). But here you set it in eoi exit bitmap and this will cause vmexit on each EOI which should not happen.

> 
> [Thanks to Alex for his precise description of the problem
>  and initial debugging effort.  A lot of the text above is
>  based on emails exchanged with him.]
> 
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/ioapic.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 2458a1dc2ba9..e8ce34c9db32 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -254,10 +254,9 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
> u64 *eoi_exit_bitmap,
>  	spin_lock(&ioapic->lock);
>  	for (index = 0; index < IOAPIC_NUM_PINS; index++) {
>  		e = &ioapic->redirtbl[index];
> -		if (!e->fields.mask &&
> -			(e->fields.trig_mode == IOAPIC_LEVEL_TRIG ||
> -			 kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC,
> -				 index) || index == RTC_GSI)) {
> +		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG ||
> +		    kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index)
> ||
> +		    index == RTC_GSI) {
>  			if (kvm_apic_match_dest(vcpu, NULL, 0,
>  				e->fields.dest_id, e->fields.dest_mode)) {
>  				__set_bit(e->fields.vector,

Best regards,
Yang


