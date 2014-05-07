Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaEGPVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:21:37 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:61042 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaEGPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:21:34 -0400
Message-ID: <536A4F75.6000902@gmail.com>
Date: Wed, 07 May 2014 18:21:25 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>,
        mtosatti@redhat.com, hpa@zytor.com
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: x86: Emulator does not calculate address correctly
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il> <1399465972-4026-2-git-send-email-namit@cs.technion.ac.il> <536A3BD7.10804@redhat.com>
In-Reply-To: <536A3BD7.10804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/14, 4:57 PM, Paolo Bonzini wrote:
> Il 07/05/2014 14:32, Nadav Amit ha scritto:
>> In long-mode, when the address size is 4 bytes, the linear address is not
>> truncated as the emulator mistakenly does.  Instead, the offset within
>> the
>> segment (the ea field) should be truncated according to the address size.
>>
>> As Intel SDM says: "In 64-bit mode, the effective address components
>> are added
>> and the effective address is truncated ... before adding the full 64-bit
>> segment base."
>>
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>> ---
>>  arch/x86/kvm/emulate.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index e8a5840..743e8e3 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -631,7 +631,8 @@ static int __linearize(struct x86_emulate_ctxt *ctxt,
>>      u16 sel;
>>      unsigned cpl;
>>
>> -    la = seg_base(ctxt, addr.seg) + addr.ea;
>> +    la = seg_base(ctxt, addr.seg) +
>> +        (ctxt->ad_bytes == 8 ? addr.ea : (u32)addr.ea);
>
> I think you need "fetch || ctxt->ad_bytes == 8" here.
>
> Paolo
>
Yes. I did not test the fetch scenario.
I intend to do so soon to avoid such mistakes.

Nadav
