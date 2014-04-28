Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaD1Kl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:41:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbaD1Kly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:41:54 -0400
Message-ID: <535E3061.2030402@redhat.com>
Date: Mon, 28 Apr 2014 12:41:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix page-tables reserved bits
References: <1396582264-9864-1-git-send-email-namit@cs.technion.ac.il> <20140416190329.GB8773@amt.cnet> <534EF354.3090204@zytor.com> <20140416220409.GB15155@amt.cnet>
In-Reply-To: <20140416220409.GB15155@amt.cnet>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/04/2014 00:04, Marcelo Tosatti ha scritto:
>>>> > >> @@ -3550,9 +3550,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>>>> > >>  		break;
>>>> > >>  	case PT64_ROOT_LEVEL:
>>>> > >>  		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
>>>> > >> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
>>>> > >> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
>>>> > >>  		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
>>>> > >> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
>>>> > >> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
>>> > >
>>> > > Bit 7 is not reserved either, for the PDPTE (its PageSize bit).
>>> > >
>> >
>> > In long mode (IA-32e), bit 7 is definitely reserved.

It's always reserved for PML4E (rsvd_bits_mask[x][3]), while for PDPTEs 
it is not reserved if you have 1GB pages.

> There is a separate reserved mask for PS=1, nevermind.
>

Yeah, but the situation for IA32e rsvd_bits_mask[0][2] is exactly the 
same as for PAE rsvd_bits_mask[0][1], and we're not marking the bit as 
reserved there.

The right thing to do is to add rsvd_bits(7, 7) to both 
rsvd_bits_mask[0][2] and rsvd_bits_mask[1][2], if 1GB pages are not 
supported.

As written, the patch has no effect on PDPTEs because 
rsvd_bits_mask[0][2] is only accessed if bit 7 is zero.

Nadav, would you mind preparing a follow-up?  Also, how did you find 
these issues and test the fixes?

Paolo
