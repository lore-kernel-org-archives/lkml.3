Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaD1MUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:20:41 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44958 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbaD1MUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:20:39 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] KVM: x86: Fix page-tables reserved bits
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <535E3061.2030402@redhat.com>
Date: Mon, 28 Apr 2014 15:20:33 +0300
Cc: Marcelo Tosatti <mtosatti@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <7B24A2A6-1C06-4BC7-8C11-9D013E7F338A@gmail.com>
References: <1396582264-9864-1-git-send-email-namit@cs.technion.ac.il> <20140416190329.GB8773@amt.cnet> <534EF354.3090204@zytor.com> <20140416220409.GB15155@amt.cnet> <535E3061.2030402@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 28, 2014, at 1:41 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 17/04/2014 00:04, Marcelo Tosatti ha scritto:
>>>>> > >> @@ -3550,9 +3550,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>>>>> > >>  		break;
>>>>> > >>  	case PT64_ROOT_LEVEL:
>>>>> > >>  		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
>>>>> > >> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
>>>>> > >> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
>>>>> > >>  		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
>>>>> > >> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
>>>>> > >> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
>>>> > >
>>>> > > Bit 7 is not reserved either, for the PDPTE (its PageSize bit).
>>>> > >
>>> >
>>> > In long mode (IA-32e), bit 7 is definitely reserved.
> 
> It's always reserved for PML4E (rsvd_bits_mask[x][3]), while for PDPTEs it is not reserved if you have 1GB pages.
> 
>> There is a separate reserved mask for PS=1, nevermind.
>> 
> 
> Yeah, but the situation for IA32e rsvd_bits_mask[0][2] is exactly the same as for PAE rsvd_bits_mask[0][1], and we're not marking the bit as reserved there.
> 
> The right thing to do is to add rsvd_bits(7, 7) to both rsvd_bits_mask[0][2] and rsvd_bits_mask[1][2], if 1GB pages are not supported.
> 
> As written, the patch has no effect on PDPTEs because rsvd_bits_mask[0][2] is only accessed if bit 7 is zero.
> 
> Nadav, would you mind preparing a follow-up?  Also, how did you find these issues and test the fixes?
I will create a follow-up as soon as possible. We encountered the issues in a custom testing environment.
The fixes were validated using the failing tests, but they cover additional cases which might not have been tested.

Regards,
Nadav