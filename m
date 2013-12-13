Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3LMQH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:07:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab3LMQH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:07:57 -0500
Date: Fri, 13 Dec 2013 17:07:54 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        pmatouse@redhat.com, stable@vger.kernel.org, larsbull@google.com
Subject: Re: [PATCH] KVM: x86: fix guest-initiated crash with x2apic
 (CVE-2013-6376)
Message-ID: <20131213160754.GA20763@hpx.cz>
References: <1386880614-23300-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386880614-23300-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-12 21:36+0100, Paolo Bonzini:
> From: Gleb Natapov <gleb@redhat.com>
> 
> A guest can cause a BUG_ON() leading to a host kernel crash.
> When the guest writes to the ICR to request an IPI, while in x2apic
> mode the following things happen, the destination is read from
> ICR2, which is a register that the guest can control.
> 
> kvm_irq_delivery_to_apic_fast uses the high 16 bits of ICR2 as the
> cluster id.  A BUG_ON is triggered, which is a protection against
> accessing map->logical_map with an out-of-bounds access and manages
> to avoid that anything really unsafe occurs.
> 
> The logic in the code is correct from real HW point of view. The problem
> is that KVM supports only one cluster with ID 0 in clustered mode, but
> the code that has the bug does not take this into account.

The more I read about x2apic, the more confused I am ...

 - How was the cluster x2apic enabled?

   Linux won't enable cluster x2apic without interrupt remapping and I
   had no idea we were allowed to do it.

 - A hardware test-suite found this?

   This bug can only be hit when the destination cpu is > 256, so the
   request itself is buggy -- we don't support that many in kvm and it
   would crash when initializing the vcpus if we did.
   => It looks like we should just ignore the ipi, because we have no
      vcpus in that cluster.

 - Where does the 'only one supported cluster' come from?

   I only see we use 'struct kvm_lapic *logical_map[16][16];', which
   supports 16 clusters of 16 apics = first 256 vcpus, so if we map
   everything to logical_map[0][0:15], we would not work correctly in
   the cluster x2apic, with > 16 vcpus.

Thanks.

> Reported-by: Lars Bull <larsbull@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/lapic.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index b8bec45c1610..801dc3fd66e1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -143,6 +143,8 @@ static inline int kvm_apic_id(struct kvm_lapic *apic)
>  	return (kvm_apic_get_reg(apic, APIC_ID) >> 24) & 0xff;
>  }
>  
> +#define KMV_X2APIC_CID_BITS 0
> +
>  static void recalculate_apic_map(struct kvm *kvm)
>  {
>  	struct kvm_apic_map *new, *old = NULL;
> @@ -180,7 +182,8 @@ static void recalculate_apic_map(struct kvm *kvm)
>  		if (apic_x2apic_mode(apic)) {
>  			new->ldr_bits = 32;
>  			new->cid_shift = 16;
> -			new->cid_mask = new->lid_mask = 0xffff;
> +			new->cid_mask = (1 << KMV_X2APIC_CID_BITS) - 1;
> +			new->lid_mask = 0xffff;
>  		} else if (kvm_apic_sw_enabled(apic) &&
>  				!new->cid_mask /* flat mode */ &&
>  				kvm_apic_get_reg(apic, APIC_DFR) == APIC_DFR_CLUSTER) {
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
