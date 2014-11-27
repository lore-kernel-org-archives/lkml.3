Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaK0VEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:04:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaK0VEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:04:02 -0500
Date: Thu, 27 Nov 2014 22:03:51 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: Re: [PATCH 3/4] KVM: x86: allow 256 logical x2APICs again
Message-ID: <20141127210350.GC7770@potion.brq.redhat.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
 <1417114994-25235-4-git-send-email-rkrcmar@redhat.com>
 <22F11C34-E2E4-459B-882B-A944AD0853FD@gmail.com>
 <20141127201641.GB383@potion.brq.redhat.com>
 <A459C9D7-B1A8-4507-94FD-272A9FEECFDC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A459C9D7-B1A8-4507-94FD-272A9FEECFDC@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-27 22:39+0200, Nadav Amit:
> Radim Krčmář <rkrcmar@redhat.com> wrote:
> 
> > 2014-11-27 21:53+0200, Nadav Amit:
> >> Radim Krčmář <rkrcmar@redhat.com> wrote:
> >>> -			new->cid_mask = (1 << KVM_X2APIC_CID_BITS) - 1;
> >>> -			new->lid_mask = 0xffff;
> >>> +			new->cid_mask = new->lid_mask = 0xffff;
> >> You set cid_mask to 0xffff, while there are only 16 clusters. I think it is
> >> risky (if you twist my hand would come with a scenario).
> > 
> > Let's see :) APIC id is 8 bit, and we compute cluster part of LDR by
> > taking four upper bits, so 16 is enough.
> To clarify my concern - I am worried that some of the CPUs are still in
> xAPIC mode with LDR that does not follow x2APIC LDR scheme.

xAPIC has only the highest LDR byte nonzero, so it won't pass the lid
check.  (Logical xAPIC doesn't work with x2APIC in our implementation.)

I agree, it is really obsucure and I should have put it in v1.

> > We would incorrectly deliver messages intended for high clusters,
> > it has to be 0xffff.
> From the SDM, I am not sure you are correct, but your solution is fine.

We'd have to change the code in irq_deliver...fast to account for that
change, which I think is uglier than checking here.
(If the message is for 0xf0000001 and 0x00000001 accepts it, SDM doesn't
 approve.)
