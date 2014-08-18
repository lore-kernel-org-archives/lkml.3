Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaHRIbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:31:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbaHRIby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:31:54 -0400
Message-ID: <53F1B9E4.2090008@redhat.com>
Date: Mon, 18 Aug 2014 10:31:32 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: gleb@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: Re: [PATCH] KVM: x86: Avoid emulating instructions on #UD mistakenly
References: <1407937813-1461-1-git-send-email-namit@cs.technion.ac.il> <B8075446-5721-4D41-99A1-19B729691F42@gmail.com>
In-Reply-To: <B8075446-5721-4D41-99A1-19B729691F42@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/08/2014 16:21, Nadav Amit ha scritto:
> Correction: the word “never” in the message is too harsh.
> Nonetheless, there is a regression bug. I encountered it with “wrfsbase” instruction.

So KVM is emulating wrfsbase even if the host doesn't support it?

I'm swapping the order of the two operands of &&, since the first one will almost
always be true and the second one will almost always be false.

Also, there's now no need to test EmulateOnUD in the condition below.  Does the
below look good to you?

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 37a83b24e040..ef117b842334 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4394,11 +4394,11 @@ done_prefixes:
 
 	ctxt->execute = opcode.u.execute;
 
-	if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
+	if (unlikely(ctxt->ud) && likely(!(ctxt->d & EmulateOnUD)))
 		return EMULATION_FAILED;
 
 	if (unlikely(ctxt->d &
-		     (NotImpl|EmulateOnUD|Stack|Op3264|Sse|Mmx|Intercept|CheckPerm))) {
+		     (NotImpl|Stack|Op3264|Sse|Mmx|Intercept|CheckPerm))) {
 		/*
 		 * These are copied unconditionally here, and checked unconditionally
 		 * in x86_emulate_insn.

 

Paolo

> Nadav
> 
> On Aug 13, 2014, at 4:50 PM, Nadav Amit <namit@cs.technion.ac.il> wrote:
> 
>> Commit d40a6898e5 mistakenly caused instructions which are not marked as
>> EmulateOnUD to be emulated upon #UD exception. The commit caused the check of
>> whether the instruction flags include EmulateOnUD to never be evaluated. As a
>> result instructions whose emulation is broken may be emulated.  This fix moves
>> the evaluation of EmulateOnUD so it would be evaluated.
>>
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>> ---
>> arch/x86/kvm/emulate.c | 6 +++---
>> 1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 56657b0..37a83b2 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -4394,6 +4394,9 @@ done_prefixes:
>>
>>  	ctxt->execute = opcode.u.execute;
>>
>> +	if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
>> +		return EMULATION_FAILED;
>> +
>>  	if (unlikely(ctxt->d &
>>  		     (NotImpl|EmulateOnUD|Stack|Op3264|Sse|Mmx|Intercept|CheckPerm))) {
>>  		/*
>> @@ -4406,9 +4409,6 @@ done_prefixes:
>>  		if (ctxt->d & NotImpl)
>>  			return EMULATION_FAILED;
>>
>> -		if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
>> -			return EMULATION_FAILED;
>> -
>>  		if (mode == X86EMUL_MODE_PROT64 && (ctxt->d & Stack))
>>  			ctxt->op_bytes = 8;
>>
>> -- 
>> 1.9.1
>>
> 

