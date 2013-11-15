Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab3KOPqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:46:16 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:48926 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3KOPqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:46:03 -0500
Message-ID: <528641B7.2080409@linaro.org>
Date: Fri, 15 Nov 2013 10:45:59 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/13] ARM: Finish renaming ARM kprobes APIs for sharing
 with uprobes
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>  <1381871068-27660-12-git-send-email-dave.long@linaro.org> <1384363014.3392.44.camel@linaro1.home>
In-Reply-To: <1384363014.3392.44.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13 12:16, Jon Medhurst (Tixy) wrote:
> On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Use the prefix "probes_" for APIs and definitions to be shared between
>> kprobes and uprobes. Pass additional information into the lower-level decoding
>> functions to avoid having to duplicate architecture-specfific data structures.
>> Make susbsystem-specific APIs static (non-global) again.  Make a couple of utility
>> functions (probes_simulate_nop and probes_emulate_none) sharable and in a common
>> file. Keep the current "action" tables specific to kprobes, as this is where
>> uprobes functionality will be connected up to the instruction interpreter.
>
> That's a rather long list of things this patch is reorganising and makes
> it very difficult to review. For those class of changes which are
> independent of each other, can you do them as separate patches?
>
> Particularly, the change from using the function arguments
>
>      struct kprobe *p
>
> to
>      probes_opcode_t opcode, probes_opcode_t *addr, struct arch_specific_insn *asi
>
> should be in it's own separate patch as that is spread out across multiple files
> and functions.

OK, I will break this down further into separate patches.

> I have a few general comments on this patch...
>
> 1. I don't think we actually need to pass 'probes_opcode_t *addr' to the
> simulation functions, this will be the same as regs->ARM_pc (except that
> for thumb code 'addr' has bit0 set, which we don't actually care about).
> So drop the new 'addr' argument, and we can also delete the definition of
> thumb_probe_pc() and replace its use with 'regs->ARM_pc + 4'

I had some trouble getting that to work before, but I'll try again.

> 2. Now we pass 'probes_opcode_t opcode' to simulation functions a lot of
> them end up doing the redundant...
>
>     kprobe_opcode_t insn = opcode
>
> I would suggest deleting all of these assignments and either rename all
> use of 'insn' to 'opcode' or just changing the function argument name to
> 'insn'.

OK, I'll have a go at that.

> 3. I've a comment about the change to probes_decode_insn, I've snipped
> the rest of the patch...
>
> [...]
>>   int __kprobes
>> -kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>> +probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
>>   				const union decode_item *table, bool thumb,
>> -				const union decode_item *actions)
>> +				bool usermode, const union decode_item *actions)
>>   {
>
> The new argument 'usermode' is named for the use you are using it for,
> i.e. uprobes, I think the code is more intuitive if it was called
> something like 'no_emulate', because what the argument does is force all
> emulate operations to become 'custom'.
>
> Perhaps to avoid double negatives like !no_emulate, the logic of the
> argument could be inverted and it called 'use_emulation' or something.

Or maybe just "emulate".

>> -	const struct decode_header *h = (struct decode_header *)table;
>> -	const struct decode_header *next;
>> +	struct decode_header *h = (struct decode_header *)table;
>> +	struct decode_header *next;
>>   	bool matched = false;
>>
>> -	insn = prepare_emulated_insn(insn, asi, thumb);
>> +	if (!usermode)
>> +		insn = prepare_emulated_insn(insn, asi, thumb);
>>
>>   	for (;; h = next) {
>>   		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
>> @@ -401,7 +412,7 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>>   		if (!matched && (insn & h->mask.bits) != h->value.bits)
>>   			continue;
>>
>> -		if (!decode_regs(&insn, regs))
>> +		if (!decode_regs(&insn, regs, !usermode))
>>   			return INSN_REJECTED;
>>
>>   		switch (type) {
>> @@ -414,7 +425,8 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>>
>>   		case DECODE_TYPE_CUSTOM: {
>>   			struct decode_custom *d = (struct decode_custom *)h;
>> -			return actions[d->decoder.bits].decoder(insn, asi, h);
>> +			return actions[d->decoder.bits].decoder(insn,
>> +					asi, h);
>>   		}
>>
>>   		case DECODE_TYPE_SIMULATE: {
>> @@ -425,6 +437,11 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>>
>>   		case DECODE_TYPE_EMULATE: {
>>   			struct decode_emulate *d = (struct decode_emulate *)h;
>> +
>> +			if (usermode)
>> +				return actions[d->handler.bits].decoder(insn,
>> +								asi, h);
>> +
>>   			asi->insn_handler = actions[d->handler.bits].handler;
>>   			set_emulated_insn(insn, asi, thumb);
>>   			return INSN_GOOD;
>
> [...]
>

