Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965745AbaCUOBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:01:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbaCUOBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:01:03 -0400
Message-ID: <1395410456.632.43.camel@ul30vt.home>
Subject: Re: [PATCH v2 4/4] KVM: ioapic: reinject pending interrupts on
 KVM_SET_IRQCHIP
From: Alex Williamson <alex.williamson@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, jan.kiszka@siemens.com
Date: Fri, 21 Mar 2014 08:00:56 -0600
In-Reply-To: <1395394081-16252-5-git-send-email-pbonzini@redhat.com>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
	 <1395394081-16252-5-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 10:28 +0100, Paolo Bonzini wrote:
> After the previous patches, an interrupt whose bit is set in the IRR
> register will never be in the LAPIC's IRR and has never been injected
> on the migration source.  So inject it on the destination.
> 
> This fixes migration of Windows guests without HPET (they use the RTC
> to trigger the scheduler tick, and lose it after migration).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	v1->v2:
> 	use IOAPIC_NUM_PINS as a limit to for_each_set_bit
> 	remove debug printk

Looks good and thanks for the extended comment in patch 3.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

>  virt/kvm/ioapic.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 270f7fe73f39..d4b601547f1f 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -212,6 +212,18 @@ out:
>  	return ret;
>  }
>  
> +static void kvm_ioapic_inject_all(struct kvm_ioapic *ioapic, unsigned long irr)
> +{
> +	u32 idx;
> +
> +	rtc_irq_eoi_tracking_reset(ioapic);
> +	for_each_set_bit(idx, &irr, IOAPIC_NUM_PINS)
> +		ioapic_set_irq(ioapic, idx, 1, true);
> +
> +	kvm_rtc_eoi_tracking_restore_all(ioapic);
> +}
> +
> +
>  static void update_handled_vectors(struct kvm_ioapic *ioapic)
>  {
>  	DECLARE_BITMAP(handled_vectors, 256);
> @@ -612,9 +624,10 @@ int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
>  
>  	spin_lock(&ioapic->lock);
>  	memcpy(ioapic, state, sizeof(struct kvm_ioapic_state));
> +	ioapic->irr = 0;
>  	update_handled_vectors(ioapic);
>  	kvm_vcpu_request_scan_ioapic(kvm);
> -	kvm_rtc_eoi_tracking_restore_all(ioapic);
> +	kvm_ioapic_inject_all(ioapic, state->irr);
>  	spin_unlock(&ioapic->lock);
>  	return 0;
>  }



