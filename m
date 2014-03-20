Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbaCTUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:25:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759746AbaCTUZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:25:14 -0400
Message-ID: <1395347109.632.39.camel@ul30vt.home>
Subject: Re: [PATCH 3/4] KVM: ioapic: extract body of kvm_ioapic_set_irq
From: Alex Williamson <alex.williamson@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, mtosatti@redhat.com,
        kvm@vger.kernel.org
Date: Thu, 20 Mar 2014 14:25:09 -0600
In-Reply-To: <1395154495-22807-4-git-send-email-pbonzini@redhat.com>
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>
	 <1395154495-22807-4-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 15:54 +0100, Paolo Bonzini wrote:
> We will reuse it to process a nonzero IRR that is passed to KVM_SET_IRQCHIP.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/ioapic.c | 63 ++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 39 insertions(+), 24 deletions(-)

I might choose to keep the "irq_level" variable name in the new
functions since dealing with both "edge" and "level" variables is a bit
confusing.  Some handy comments describing the return value were also
dropped.  Functionally identical though

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 25e16a6898ed..7a573f1bb79e 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -163,6 +163,44 @@ static bool rtc_irq_check_coalesced(struct kvm_ioapic *ioapic)
>  	return false;
>  }
>  
> +static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
> +		int level, bool line_status)
> +{
> +	union kvm_ioapic_redirect_entry entry;
> +	u32 mask = 1 << irq;
> +	u32 old_irr;
> +	int edge, ret;
> +
> +	entry = ioapic->redirtbl[irq];
> +	edge = (entry.fields.trig_mode == IOAPIC_EDGE_TRIG);
> +
> +	if (!level) {
> +		ioapic->irr &= ~mask;
> +		ret = 1;
> +		goto out;
> +	}
> +
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
> @@ -308,38 +346,15 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
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



