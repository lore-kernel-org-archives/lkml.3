Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbaCTUZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:25:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759953AbaCTUZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:25:29 -0400
Message-ID: <1395347123.632.40.camel@ul30vt.home>
Subject: Re: [PATCH 1/4] KVM: ioapic: merge ioapic_deliver into
 ioapic_service
From: Alex Williamson <alex.williamson@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, mtosatti@redhat.com,
        kvm@vger.kernel.org
Date: Thu, 20 Mar 2014 14:25:23 -0600
In-Reply-To: <1395154495-22807-2-git-send-email-pbonzini@redhat.com>
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>
	 <1395154495-22807-2-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 15:54 +0100, Paolo Bonzini wrote:
> Commonize the handling of masking, which was absent for kvm_ioapic_set_irq.
> Setting remote_irr does not need a separate function either, and merging
> the two functions avoids confusion.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/ioapic.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)

Code consolidation, no functional change

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 1539d3757a04..0b4914147b9d 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -50,7 +50,7 @@
>  #else
>  #define ioapic_debug(fmt, arg...)
>  #endif
> -static int ioapic_deliver(struct kvm_ioapic *vioapic, int irq,
> +static int ioapic_service(struct kvm_ioapic *vioapic, int irq,
>  		bool line_status);
>  
>  static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
> @@ -163,23 +163,6 @@ static bool rtc_irq_check_coalesced(struct kvm_ioapic *ioapic)
>  	return false;
>  }
>  
> -static int ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx,
> -		bool line_status)
> -{
> -	union kvm_ioapic_redirect_entry *pent;
> -	int injected = -1;
> -
> -	pent = &ioapic->redirtbl[idx];
> -
> -	if (!pent->fields.mask) {
> -		injected = ioapic_deliver(ioapic, idx, line_status);
> -		if (injected && pent->fields.trig_mode == IOAPIC_LEVEL_TRIG)
> -			pent->fields.remote_irr = 1;
> -	}
> -
> -	return injected;
> -}
> -
>  static void update_handled_vectors(struct kvm_ioapic *ioapic)
>  {
>  	DECLARE_BITMAP(handled_vectors, 256);
> @@ -282,12 +265,15 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  	}
>  }
>  
> -static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq, bool line_status)
> +static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>  {
>  	union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
>  	struct kvm_lapic_irq irqe;
>  	int ret;
>  
> +	if (entry->fields.mask)
> +		return -1;
> +
>  	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
>  		     "vector=%x trig_mode=%x\n",
>  		     entry->fields.dest_id, entry->fields.dest_mode,
> @@ -310,6 +296,9 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq, bool line_status)
>  	} else
>  		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe, NULL);
>  
> +	if (ret && irqe.trig_mode == IOAPIC_LEVEL_TRIG)
> +		entry->fields.remote_irr = 1;
> +
>  	return ret;
>  }
>  
> @@ -393,7 +382,7 @@ static void __kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu,
>  
>  		ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
>  		ent->fields.remote_irr = 0;
> -		if (!ent->fields.mask && (ioapic->irr & (1 << i)))
> +		if (ioapic->irr & (1 << i))
>  			ioapic_service(ioapic, i, false);
>  	}
>  }


