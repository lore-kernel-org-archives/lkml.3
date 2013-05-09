Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3EIJad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:30:33 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63922 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3EIJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:30:31 -0400
Message-ID: <518B6CB3.2050208@redhat.com>
Date: Thu, 09 May 2013 11:30:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 3/3] KVM: emulator: emulate SALC
References: <1368090967-3204-1-git-send-email-pbonzini@redhat.com> <1368090967-3204-4-git-send-email-pbonzini@redhat.com> <20130509092554.GB32023@redhat.com>
In-Reply-To: <20130509092554.GB32023@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/05/2013 11:25, Gleb Natapov ha scritto:
> On Thu, May 09, 2013 at 11:16:07AM +0200, Paolo Bonzini wrote:
>> This is an almost-undocumented instruction available in 32-bit mode.
>> I say "almost" undocumented because AMD documents it in their opcode
>> maps just to say that it is unavailable in 64-bit mode (sections
>> "A.2.1 One-Byte Opcodes" and "B.3 Invalid and Reassigned Instructions
>> in 64-Bit Mode").
>>
>> It is roughly equivalent to "sbb %al, %al" except it does not
>> set the flags.  Use fastop to emulate it, but do not use the opcode
>> directly because it would fail if the host is 64-bit!
>>
>> Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>> Cc: stable@kernel.org # 3.9
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/emulate.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 210bb4e..f62d4c8 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -534,6 +534,9 @@ FOP_SETCC(setle)
>>  FOP_SETCC(setnle)
>>  FOP_END;
>>  
>> +FOP_START(salc) "pushf; sbb %al, %al; popf; ret \n\t"
> 
> FOP_RET

Ah, I missed that macro.  I was mimicking FOP_SETCC which doesn't use
it.  Will resend.

Paolo

>> +FOP_END;
>> +
>>  #define __emulate_1op_rax_rdx(ctxt, _op, _suffix, _ex)			\
>>  	do {								\
>>  		unsigned long _tmp;					\
>> @@ -3951,7 +3954,8 @@ static const struct opcode opcode_table[256] = {
>>  	G(Src2One | ByteOp, group2), G(Src2One, group2),
>>  	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
>>  	I(DstAcc | SrcImmUByte | No64, em_aam),
>> -	I(DstAcc | SrcImmUByte | No64, em_aad), N,
>> +	I(DstAcc | SrcImmUByte | No64, em_aad),
>> +	F(DstAcc | ByteOp | No64, em_salc),
>>  	I(DstAcc | SrcXLat | ByteOp, em_mov),
>>  	/* 0xD8 - 0xDF */
>>  	N, E(0, &escape_d9), N, E(0, &escape_db), N, E(0, &escape_dd), N, N,
>> -- 
>> 1.8.1.4
> 
> --
> 			Gleb.
> 

