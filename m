Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaCUTBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaCUTBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:01:00 -0400
Date: Fri, 21 Mar 2014 19:58:59 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 3/4] KVM: ioapic: extract body of kvm_ioapic_set_irq
Message-ID: <20140321185858.GA22118@potion.brq.redhat.com>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
 <1395394081-16252-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395394081-16252-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-21 10:28+0100, Paolo Bonzini:
> We will reuse it to process a nonzero IRR that is passed to KVM_SET_IRQCHIP.
> 
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	v1->v2:
> 	more comments
> 	change argument name from level to irq_level
> 
>  virt/kvm/ioapic.c | 74 +++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 50 insertions(+), 24 deletions(-)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 25e16a6898ed..270f7fe73f39 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -163,6 +163,55 @@ static bool rtc_irq_check_coalesced(struct kvm_ioapic *ioapic)
>  	return false;
>  }
>  
> +static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
> +		int irq_level, bool line_status)
> +{
> +	union kvm_ioapic_redirect_entry entry;
> +	u32 mask = 1 << irq;
> +	u32 old_irr;
> +	int edge, ret;
> +
> +	entry = ioapic->redirtbl[irq];
> +	edge = (entry.fields.trig_mode == IOAPIC_EDGE_TRIG);
> +
> +	if (!irq_level) {
> +		ioapic->irr &= ~mask;
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Return 0 for coalesced interrupts; for edge-triggered interrupts,
> +	 * this only happens if a previous edge has not been delivered due
> +	 * do masking.  For level interrupts, the remote_irr field tells
          (^ to)
> +	 * us if the interrupt is waiting for an EOI.

How do we know we haven't delivered an edge-triggered interrupt when
ioapic_service() always clears this IRR bit?

> +	 *
> +	 * RTC is special: it is edge-triggered, but userspace likes to know
> +	 * if it has been already ack-ed via EOI because coalesced RTC
> +	 * interrupts lead to time drift in Windows guests.  So we track
> +	 * EOI manually for the RTC interrupt.
> +	 */

The comment makes me think we should not be coalescing more, but we do.

> +	if (irq == RTC_GSI && line_status &&
> +		rtc_irq_check_coalesced(ioapic)) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	old_irr = ioapic->irr;
> +	ioapic->irr |= mask;
> +	if ((edge && old_irr == ioapic->irr) ||
> +	    (!edge && entry.fields.remote_irr)) {

(Fun fact: GCC 4.8.2 doesn't optimize it as well as
   edge ? old_irr == ioapic->irr : entry.fields.remote_irr)

> +		ret = 0;
> +		goto out;
> +	}
> +
> +	ret = ioapic_service(ioapic, irq, line_status);
> +
> +out:
> +	trace_kvm_ioapic_set_irq(entry.bits, irq, ret == 0);
> +	return ret;
> +}
> +
>  static void update_handled_vectors(struct kvm_ioapic *ioapic)
>  {
>  	DECLARE_BITMAP(handled_vectors, 256);
> @@ -308,38 +357,15 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>  int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
>  		       int level, bool line_status)
>  {
> -	u32 old_irr;
> -	u32 mask = 1 << irq;
> -	union kvm_ioapic_redirect_entry entry;
>  	int ret, irq_level;
>  
>  	BUG_ON(irq < 0 || irq >= IOAPIC_NUM_PINS);
>  
>  	spin_lock(&ioapic->lock);
> -	old_irr = ioapic->irr;
>  	irq_level = __kvm_irq_line_state(&ioapic->irq_states[irq],
>  					 irq_source_id, level);
> -	entry = ioapic->redirtbl[irq];
> -	if (!irq_level) {
> -		ioapic->irr &= ~mask;
> -		ret = 1;
> -	} else {
> -		int edge = (entry.fields.trig_mode == IOAPIC_EDGE_TRIG);
> +	ret = ioapic_set_irq(ioapic, irq, irq_level, line_status);
>  
> -		if (irq == RTC_GSI && line_status &&
> -			rtc_irq_check_coalesced(ioapic)) {
> -			ret = 0; /* coalesced */
> -			goto out;
> -		}
> -		ioapic->irr |= mask;
> -		if ((edge && old_irr != ioapic->irr) ||
> -		    (!edge && !entry.fields.remote_irr))
> -			ret = ioapic_service(ioapic, irq, line_status);
> -		else
> -			ret = 0; /* report coalesced interrupt */
> -	}
> -out:
> -	trace_kvm_ioapic_set_irq(entry.bits, irq, ret == 0);
>  	spin_unlock(&ioapic->lock);
>  
>  	return ret;
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
