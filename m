Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaK0Ujv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:39:51 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59299 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaK0Ujt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:39:49 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 3/4] KVM: x86: allow 256 logical x2APICs again
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20141127201641.GB383@potion.brq.redhat.com>
Date: Thu, 27 Nov 2014 22:39:45 +0200
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>
Content-Transfer-Encoding: 8BIT
Message-Id: <A459C9D7-B1A8-4507-94FD-272A9FEECFDC@gmail.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com> <1417114994-25235-4-git-send-email-rkrcmar@redhat.com> <22F11C34-E2E4-459B-882B-A944AD0853FD@gmail.com> <20141127201641.GB383@potion.brq.redhat.com>
To: =?utf-8?Q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Radim Krčmář <rkrcmar@redhat.com> wrote:

> 2014-11-27 21:53+0200, Nadav Amit:
>> Radim Krčmář <rkrcmar@redhat.com> wrote:
>>> -			new->cid_mask = (1 << KVM_X2APIC_CID_BITS) - 1;
>>> -			new->lid_mask = 0xffff;
>>> +			new->cid_mask = new->lid_mask = 0xffff;
>> You set cid_mask to 0xffff, while there are only 16 clusters. I think it is
>> risky (if you twist my hand would come with a scenario).
> 
> Let's see :) APIC id is 8 bit, and we compute cluster part of LDR by
> taking four upper bits, so 16 is enough.
To clarify my concern - I am worried that some of the CPUs are still in
xAPIC mode with LDR that does not follow x2APIC LDR scheme.

> It isn't the safest programming practice, but we already fail to check
> physical_map bounds and any boost to maximal APIC ID is going to require
> a rewrite, thus I didn't bother to do it ...
> 
> All uses should be covered with the following hunk, I will add it to v2
> after all reviews,
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 6c2b8a5..30e4cc1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -198,7 +198,7 @@ static void recalculate_apic_map(struct kvm *kvm)
> 		cid = apic_cluster_id(new, ldr);
> 		lid = apic_logical_id(new, ldr);
> 
> -		if (lid)
> +		if (lid && cid < ARRAY_SIZE(map->logical_map))
> 			new->logical_map[cid][ffs(lid) - 1] = apic;
> 	}
> out:
> 
> 
>>                                                         Yet, why not to set
>> cid_mask to (ARRAY_SIZE(map->logical_map) - 1) ?
> 
> We would incorrectly deliver messages intended for high clusters,
> it has to be 0xffff.
>From the SDM, I am not sure you are correct, but your solution is fine.

Nadav

