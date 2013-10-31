Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3JaO1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:27:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab3JaO1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:27:52 -0400
Message-ID: <527268E4.2070505@redhat.com>
Date: Thu, 31 Oct 2013 15:27:48 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: emulate SAHF instruction
References: <1383215382-10072-1-git-send-email-pbonzini@redhat.com> <20131031142119.GS4651@redhat.com>
In-Reply-To: <20131031142119.GS4651@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/10/2013 15:21, Gleb Natapov ha scritto:
> On Thu, Oct 31, 2013 at 11:29:42AM +0100, Paolo Bonzini wrote:
>> Yet another instruction that we fail to emulate, this time found
>> in Windows 2008R2 32-bit.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> 	Testcase on its way.  BTW, lahf/sahf is another candidate for
>> 	#UD emulation.
>>
>>  arch/x86/kvm/emulate.c | 14 +++++++++++++-
>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 8e2a07bd8eac..ef750e75c930 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -3296,6 +3296,18 @@ static int em_cpuid(struct x86_emulate_ctxt *ctxt)
>>  	return X86EMUL_CONTINUE;
>>  }
>>  
>> +static int em_sahf(struct x86_emulate_ctxt *ctxt)
>> +{
>> +	u32 flags;
>> +
> Shouldn't we check CPUID.80000001H.ECX[0] = 1 in 64 bit mode?

If we want to we should check for it in em_lahf too.  But we don't
usually check for CPUID bits.  The recently added movbe is an exception,
and syscall too, but we don't do that for SSE or MMX instructions.

The way I understand it, either AMD was lazy, or they wanted to use
lahf/sahf as prefixes later on.  But it didn't work out that way, so I
think it's fine to skip the check.

Paolo

>> +	flags = EFLG_CF | EFLG_PF | EFLG_AF | EFLG_ZF | EFLG_SF;
>> +	flags &= *reg_rmw(ctxt, VCPU_REGS_RAX) >> 8;
>> +
>> +	ctxt->eflags &= ~0xffUL;
>> +	ctxt->eflags |= flags | X86_EFLAGS_FIXED;
>> +	return X86EMUL_CONTINUE;
>> +}
>> +
>>  static int em_lahf(struct x86_emulate_ctxt *ctxt)
>>  {
>>  	*reg_rmw(ctxt, VCPU_REGS_RAX) &= ~0xff00UL;
>> @@ -3788,7 +3800,7 @@ static const struct opcode opcode_table[256] = {
>>  	DI(SrcAcc | DstReg, pause), X7(D(SrcAcc | DstReg)),
>>  	/* 0x98 - 0x9F */
>>  	D(DstAcc | SrcNone), I(ImplicitOps | SrcAcc, em_cwd),
>> -	I(SrcImmFAddr | No64, em_call_far), N,
>> +	I(SrcImmFAddr | No64, em_call_far), I(ImplicitOps, em_sahf),
>>  	II(ImplicitOps | Stack, em_pushf, pushf),
>>  	II(ImplicitOps | Stack, em_popf, popf), N, I(ImplicitOps, em_lahf),
>>  	/* 0xA0 - 0xA7 */
>> -- 
>> 1.8.3.1
> 
> --
> 			Gleb.
> 

