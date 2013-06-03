Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3FCIP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:15:57 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49953 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3FCIPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:15:55 -0400
Message-ID: <51AC50AE.50503@redhat.com>
Date: Mon, 03 Jun 2013 10:15:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: fix sil/dil/bpl/spl in the mod/rm fields
References: <1369924555-30216-1-git-send-email-pbonzini@redhat.com> <20130602181253.GP24773@redhat.com> <51AC376D.9030001@redhat.com> <20130603080416.GA4725@redhat.com>
In-Reply-To: <20130603080416.GA4725@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/06/2013 10:04, Gleb Natapov ha scritto:
> On Mon, Jun 03, 2013 at 08:27:57AM +0200, Paolo Bonzini wrote:
>> Il 02/06/2013 20:12, Gleb Natapov ha scritto:
>>> On Thu, May 30, 2013 at 04:35:55PM +0200, Paolo Bonzini wrote:
>>>> The x86-64 extended low-byte registers were fetched correctly from reg,
>>>> but not from mod/rm.
>>>>
>>>> This fixes another bug in the boot of RHEL5.9 64-bit, but it is still
>>>> not enough.
>>>>
>>> Did I missed unit test patch? :)
>>
>> I wanted to ask the GSoC student to do it.  If it doesn't come in a
>> couple of weeks, I'll send it.
>>
> Which instruction you saw the bug happening with? It this 3.10 regression?

cmp $0x1f, %bpl

Like the NOP, it is a regression introduced in the switch of
emulate_invalid_guest_state from 0 to 1.

Paolo

> 
>> Paolo
>>
>>>> Cc: gnatapov@redhat.com
> Please use my other email :)
> 
>>>> Cc: kvm@vger.kernel.org
>>>> Cc: <stable@vger.kernel.org> # 3.9
>>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>>> ---
>>>>  arch/x86/kvm/emulate.c | 5 ++++-
>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>>>> index aa68106..028b34f 100644
>>>> --- a/arch/x86/kvm/emulate.c
>>>> +++ b/arch/x86/kvm/emulate.c
>>>> @@ -1239,9 +1239,12 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>>>>  	ctxt->modrm_seg = VCPU_SREG_DS;
>>>>  
>>>>  	if (ctxt->modrm_mod == 3) {
>>>> +		int highbyte_regs = ctxt->rex_prefix == 0;
>>>> +
>>>>  		op->type = OP_REG;
>>>>  		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
>>>> -		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm, ctxt->d & ByteOp);
>>>> +		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
>>>> +					       highbyte_regs && (ctxt->d & ByteOp));
>>>>  		if (ctxt->d & Sse) {
>>>>  			op->type = OP_XMM;
>>>>  			op->bytes = 16;
>>>> -- 
>>>> 1.8.1.4
>>>
>>> --
>>> 			Gleb.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

