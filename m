Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaCRPLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:11:01 -0400
Received: from david.siemens.de ([192.35.17.14]:49612 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbaCRPK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:10:59 -0400
Message-ID: <532861EF.8050001@siemens.com>
Date: Tue, 18 Mar 2014 16:10:39 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: gleb@kernel.org, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: ioapic: reinject pending interrupts on KVM_SET_IRQCHIP
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com> <1395154495-22807-5-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1395154495-22807-5-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-18 15:54, Paolo Bonzini wrote:
> After the previous patches, an interrupt whose bit is set in the IRR
> register will never be in the LAPIC's IRR and has never been injected
> on the migration source.  So inject it on the destination.
> 
> This fixes migration of Windows guests without HPET (they use the RTC
> to trigger the scheduler tick, and lose it after migration).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/ioapic.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 7a573f1bb79e..63fb432ab502 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -201,6 +201,19 @@ out:
>  	return ret;
>  }
>  
> +void kvm_ioapic_inject_all(struct kvm_ioapic *ioapic, unsigned long irr)

static? (Didn't the compiler bark at you?)

Jan

> +{
> +	u32 idx;
> +
> +	rtc_irq_eoi_tracking_reset(ioapic);
> +	for_each_set_bit(idx, &irr, 32) {
> +		printk("ioapic_service for GSI %d\n", idx);
> +		ioapic_set_irq(ioapic, idx, 1, true);
> +	}
> +	kvm_rtc_eoi_tracking_restore_all(ioapic);
> +}
> +
> +
>  static void update_handled_vectors(struct kvm_ioapic *ioapic)
>  {
>  	DECLARE_BITMAP(handled_vectors, 256);
> @@ -601,9 +614,10 @@ int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
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
> 
-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux

