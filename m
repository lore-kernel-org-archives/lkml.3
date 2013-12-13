Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3LMUBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:01:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab3LMUBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:01:13 -0500
Date: Fri, 13 Dec 2013 21:00:58 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, pmatouse@redhat.com, stable@vger.kernel.org,
        larsbull@google.com
Subject: Re: [PATCH] KVM: x86: fix guest-initiated crash with x2apic
 (CVE-2013-6376)
Message-ID: <20131213200058.GC18129@hpx.cz>
References: <1386880614-23300-4-git-send-email-pbonzini@redhat.com>
 <20131213160754.GA20763@hpx.cz>
 <52AB4300.9010006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52AB4300.9010006@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-13 18:25+0100, Paolo Bonzini:
> Il 13/12/2013 17:07, Radim Krčmář ha scritto:
> >    This bug can only be hit when the destination cpu is > 256, so the
> >    request itself is buggy -- we don't support that many in kvm and it
> >    would crash when initializing the vcpus if we did.
> >    => It looks like we should just ignore the ipi, because we have no
> >       vcpus in that cluster.
> 
> That's what should happen in physical mode.  Something like this patch:
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5439117d5c4c..1f8e9e1abd3b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -613,9 +615,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>  
>  	if (irq->dest_mode == 0) { /* physical mode */
>  		if (irq->delivery_mode == APIC_DM_LOWEST ||
> -				irq->dest_id == 0xff)
> +		    irq->dest_id == 0xff ||

The 0xff is xapic broadcast, we did not care about the x2apic one and
no-one noticed that it does not work :)

0xff isn't special in x2apic mode.

> +		    (apic_x2apic_mode(src) && irq->dest_id > 0xff))
>  			goto out;
> -		dst = &map->phys_map[irq->dest_id & 0xff];
> +		dst = &map->phys_map[irq->dest_id];
>  	} else {
>  		u32 mda = irq->dest_id << (32 - map->ldr_bits);
>  
> 
> On top of this, the x2apic spec documents a "broadcast" destination ID that
> could be implemented as follows.  But I have no idea if this is correct and
> how it differs from the usual broadcast shorthand:
> 
> @@ -815,9 +818,11 @@ static void apic_send_ipi(struct kvm_lapic *apic)
>  	irq.level = icr_low & APIC_INT_ASSERT;
>  	irq.trig_mode = icr_low & APIC_INT_LEVELTRIG;
>  	irq.shorthand = icr_low & APIC_SHORT_MASK;
> -	if (apic_x2apic_mode(apic))
> +	if (apic_x2apic_mode(apic)) {
>  		irq.dest_id = icr_high;
> -	else
> +		if (icr_high == 0xFFFFFFFF)
> +			irq.shorthand = APIC_DEST_ALLINC;

The shorthand takes priority, so we shouldn't overwrite it.
This is better solved after we 'goto out' from the _fast().
(could be nicer still ...)

> +	} else
>  		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
>  	trace_kvm_apic_ipi(icr_low, irq.dest_id);
> 
> 

And another possibility occured to me now: Google was the first one to
encounter a broadcast; we don't handle it at all in the fast path and
x2apic has 0xffffffff as the target in both modes ...
(I think that xapic has 0xff in both of them too, but I'll check)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5439117..e4618c4 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -512,19 +512,24 @@ static void apic_set_tpr(struct kvm_lapic *apic, u32 tpr)
 	apic_update_ppr(apic);
 }
 
-int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest)
+int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u32 dest)
 {
-	return dest == 0xff || kvm_apic_id(apic) == dest;
+	return dest == (apic_x2apic_mode(apic) ? 0xffffffff : 0xff)
+	       || kvm_apic_id(apic) == dest;
 }
 
-int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
+int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u32 mda)
 {
 	int result = 0;
 	u32 logical_id;
 
+	if (mda == (apic_x2apic_mode(apic) ? 0xffffffff : 0xff))
+		return 1;
+
 	if (apic_x2apic_mode(apic)) {
 		logical_id = kvm_apic_get_reg(apic, APIC_LDR);
-		return logical_id & mda;
+		return mda >> 16 == logical_id >> 16
+		       && logical_id & mda & 0xffff;
 	}
 
 	logical_id = GET_APIC_LOGICAL_ID(kvm_apic_get_reg(apic, APIC_LDR));
@@ -605,6 +610,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	if (irq->shorthand)
 		return false;
 
+	/* broadcast */
+	if (irq->dest_id == (apic_x2apic_mode(src) ? 0xffffffff : 0xff))
+		return false;
+
 	rcu_read_lock();
 	map = rcu_dereference(kvm->arch.apic_map);
 
@@ -612,10 +621,13 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		goto out;
 
 	if (irq->dest_mode == 0) { /* physical mode */
-		if (irq->delivery_mode == APIC_DM_LOWEST ||
-				irq->dest_id == 0xff)
+		if (irq->dest_id > 0xff) {
+			ret = true;
+			goto out;
+		}
+		if (irq->delivery_mode == APIC_DM_LOWEST)
 			goto out;
-		dst = &map->phys_map[irq->dest_id & 0xff];
+		dst = &map->phys_map[irq->dest_id];
 	} else {
 		u32 mda = irq->dest_id << (32 - map->ldr_bits);
 

The logical x2apic slowpath was completely broken, maybe still is,
I have no way to test it ...

The broadcast checking should be abstracted, we call it a lot and giving
it a name would be much better than commenting.

Also, APIC_DM_LOWEST is not allowed in physical x2apic, but patches for
that later can come later :)

> >  - Where does the 'only one supported cluster' come from?
> > 
> >    I only see we use 'struct kvm_lapic *logical_map[16][16];', which
> >    supports 16 clusters of 16 apics = first 256 vcpus, so if we map
> >    everything to logical_map[0][0:15], we would not work correctly in
> >    the cluster x2apic, with > 16 vcpus.
> 
> I think you're right.  Something like this would be a better fix:

Yes, looks good.

> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index dec48bfaddb8..58745cbbb7e6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -198,7 +198,7 @@ static void recalculate_apic_map(struct kvm *kvm)
>  		cid = apic_cluster_id(new, ldr);
>  		lid = apic_logical_id(new, ldr);
>  
> -		if (lid)
> +		if (cid < ARRAY_SIZE(new->logical_map) && lid)
>  			new->logical_map[cid][ffs(lid) - 1] = apic;
>  	}
>  out:
> @@ -621,9 +621,12 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>  		dst = &map->phys_map[irq->dest_id & 0xff];
>  	} else {
>  		u32 mda = irq->dest_id << (32 - map->ldr_bits);
> +		u32 cid = apic_cluster_id(map, mda);
>  
> -		dst = map->logical_map[apic_cluster_id(map, mda)];
> +		if (cid >= ARRAY_SIZE(map->logical_map))
> +			goto out;

We could set 'ret = true' before the jump, because we won't find a
matching cpu in the second run anyway and broadcast is already handled.

> +		dst = map->logical_map[cid];
>  		bitmap = apic_logical_id(map, mda);
>  
>  		if (irq->delivery_mode == APIC_DM_LOWEST) {
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index c8b0d0d2da5c..5ccb71658894 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -152,8 +152,6 @@ static inline u16 apic_cluster_id(struct kvm_apic_map *map, u32 ldr)
>  	ldr >>= 32 - map->ldr_bits;
>  	cid = (ldr >> map->cid_shift) & map->cid_mask;
>  
> -	BUG_ON(cid >= ARRAY_SIZE(map->logical_map));
> -
>  	return cid;
>  }
>  
> playground:~/work/upstream/linux-2.6/arch/x86 pbonzini$ vi kvm/lapic.c
> playground:~/work/upstream/linux-2.6/arch/x86 pbonzini$ git diff !$
> git diff kvm/lapic.c
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index dec48bfaddb8..1005185972a9 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -143,8 +143,6 @@ static inline int kvm_apic_id(struct kvm_lapic *apic)
>  	return (kvm_apic_get_reg(apic, APIC_ID) >> 24) & 0xff;
>  }
>  
> -#define KVM_X2APIC_CID_BITS 0
> -
>  static void recalculate_apic_map(struct kvm *kvm)
>  {
>  	struct kvm_apic_map *new, *old = NULL;
> @@ -182,8 +180,7 @@ static void recalculate_apic_map(struct kvm *kvm)
>  		if (apic_x2apic_mode(apic)) {
>  			new->ldr_bits = 32;
>  			new->cid_shift = 16;
> -			new->cid_mask = (1 << KVM_X2APIC_CID_BITS) - 1;
> -			new->lid_mask = 0xffff;
> +			new->cid_mask = new->lid_mask = 0xffff;
>  		} else if (kvm_apic_sw_enabled(apic) &&
>  				!new->cid_mask /* flat mode */ &&
>  				kvm_apic_get_reg(apic, APIC_DFR) == APIC_DFR_CLUSTER) {
> @@ -198,7 +195,7 @@ static void recalculate_apic_map(struct kvm *kvm)
>  		cid = apic_cluster_id(new, ldr);
>  		lid = apic_logical_id(new, ldr);
>  
> -		if (lid)
> +		if (cid < ARRAY_SIZE(new->logical_map) && lid)
>  			new->logical_map[cid][ffs(lid) - 1] = apic;
>  	}
>  out:
> @@ -621,9 +618,12 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>  		dst = &map->phys_map[irq->dest_id & 0xff];
>  	} else {
>  		u32 mda = irq->dest_id << (32 - map->ldr_bits);
> +		u32 cid = apic_cluster_id(map, mda);
>  
> -		dst = map->logical_map[apic_cluster_id(map, mda)];
> +		if (cid >= ARRAY_SIZE(map->logical_map))
> +			goto out;
>  
> +		dst = map->logical_map[cid];
>  		bitmap = apic_logical_id(map, mda);
>  
>  		if (irq->delivery_mode == APIC_DM_LOWEST) {
> 
