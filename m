Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbaCUSeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:34:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaCUSec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:34:32 -0400
Date: Fri, 21 Mar 2014 15:34:26 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 2/4] KVM: ioapic: clear IRR for edge-triggered
 interrupts at delivery
Message-ID: <20140321183426.GD10819@otherpad.lan.raisama.net>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
 <1395394081-16252-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395394081-16252-3-git-send-email-pbonzini@redhat.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 10:27:59AM +0100, Paolo Bonzini wrote:
> This ensures that IRR bits are set in the KVM_GET_IRQCHIP result only if
> the interrupt is still sitting in the IOAPIC.  After the next patches, it
> avoids spurious reinjection of the interrupt when KVM_SET_IRQCHIP is
> called.
> 
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/ioapic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 0b4914147b9d..25e16a6898ed 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -288,6 +288,9 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>  	irqe.level = 1;
>  	irqe.shorthand = 0;
>  
> +	if (irqe.trig_mode == IOAPIC_EDGE_TRIG)
> +		ioapic->irr &= ~(1 << irq);
> +

Now, every call to ioapic_service() for an edge interrupt clears the IRR
bit immediately (assuming the mask is unset).

If the IRR bit is immediately zero on delivery, why won't this break the
edge detection logic on kvm_ioapic_set_irq()? Am I missing some
additional detail?

In other words, won't this cause spurious interrupts if
kvm_ioapic_set_irq(..., true) is called twice?

-- 
Eduardo
