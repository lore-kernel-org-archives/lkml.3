Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbaFQPxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:53:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933015AbaFQPxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:53:20 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: x86: Wrong emulation on 'xadd X, X'
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
	<1402837982-24959-3-git-send-email-namit@cs.technion.ac.il>
	<jpg7g4gzrdg.fsf@nelium.bos.redhat.com> <539FCF48.5060705@redhat.com>
Date: Tue, 17 Jun 2014 11:35:24 -0400
In-Reply-To: <539FCF48.5060705@redhat.com> (Paolo Bonzini's message of "Tue,
	17 Jun 2014 07:16:56 +0200")
Message-ID: <jpgmwdbv9ab.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 16/06/2014 19:38, Bandan Das ha scritto:
>> Nadav Amit <namit@cs.technion.ac.il> writes:
>>
>>> The emulator does not emulate the xadd instruction correctly if the two
>>> operands are the same.  In this (unlikely) situation the result should be the
>>> sum of X and X (2X) when it is currently X.  The solution is to first perform
>>> writeback to the source, before writing to the destination.  The only
>>> instruction which should be affected is xadd, as the other instructions that
>>> perform writeback to the source use the extended accumlator (e.g., RAX:RDX).
>>>
>>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>>> ---
>>>  arch/x86/kvm/emulate.c | 10 +++++-----
>>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>>> index f0b0a10..3c8d867 100644
>>> --- a/arch/x86/kvm/emulate.c
>>> +++ b/arch/x86/kvm/emulate.c
>>> @@ -4711,17 +4711,17 @@ special_insn:
>>>  		goto done;
>>>
>>>  writeback:
>>> -	if (!(ctxt->d & NoWrite)) {
>>> -		rc = writeback(ctxt, &ctxt->dst);
>>> -		if (rc != X86EMUL_CONTINUE)
>>> -			goto done;
>>> -	}
>>>  	if (ctxt->d & SrcWrite) {
>>>  		BUG_ON(ctxt->src.type == OP_MEM || ctxt->src.type == OP_MEM_STR);
>> While we are here, I think we should replace this BUG_ON with a warning
>> and return X86EMUL_UNHANDLEABLE if the condition is true.
>
> Sure, please post a patch and I'll apply it right away.

Well, I meant it more as a review and "suggested changes" to this patchset 
Nadav posted, but yeah, if you prefer, I can post a change myself. I will
make a pass through other uses of BUG() in the code too. 

> Paolo
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
