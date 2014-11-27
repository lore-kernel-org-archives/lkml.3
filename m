Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaK0UQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:16:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbaK0UQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:16:53 -0500
Date: Thu, 27 Nov 2014 21:16:42 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: Re: [PATCH 3/4] KVM: x86: allow 256 logical x2APICs again
Message-ID: <20141127201641.GB383@potion.brq.redhat.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
 <1417114994-25235-4-git-send-email-rkrcmar@redhat.com>
 <22F11C34-E2E4-459B-882B-A944AD0853FD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22F11C34-E2E4-459B-882B-A944AD0853FD@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-27 21:53+0200, Nadav Amit:
> Radim Krčmář <rkrcmar@redhat.com> wrote:
> > -			new->cid_mask = (1 << KVM_X2APIC_CID_BITS) - 1;
> > -			new->lid_mask = 0xffff;
> > +			new->cid_mask = new->lid_mask = 0xffff;
> You set cid_mask to 0xffff, while there are only 16 clusters. I think it is
> risky (if you twist my hand would come with a scenario).

Let's see :) APIC id is 8 bit, and we compute cluster part of LDR by
taking four upper bits, so 16 is enough.

It isn't the safest programming practice, but we already fail to check
physical_map bounds and any boost to maximal APIC ID is going to require
a rewrite, thus I didn't bother to do it ...

All uses should be covered with the following hunk, I will add it to v2
after all reviews,

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6c2b8a5..30e4cc1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -198,7 +198,7 @@ static void recalculate_apic_map(struct kvm *kvm)
 		cid = apic_cluster_id(new, ldr);
 		lid = apic_logical_id(new, ldr);
 
-		if (lid)
+		if (lid && cid < ARRAY_SIZE(map->logical_map))
 			new->logical_map[cid][ffs(lid) - 1] = apic;
 	}
 out:


>                                                          Yet, why not to set
> cid_mask to (ARRAY_SIZE(map->logical_map) - 1) ?

We would incorrectly deliver messages intended for high clusters,
it has to be 0xffff.
