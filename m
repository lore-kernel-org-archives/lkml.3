Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaAOQ0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:26:05 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:36563 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaAOQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:25:59 -0500
Message-ID: <52D6B693.9070801@linaro.org>
Date: Wed, 15 Jan 2014 11:25:55 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/16] ARM: use a function table for determining instruction
 interpreter actions
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>  <1387166930-13182-6-git-send-email-dave.long@linaro.org> <1387543554.3404.34.camel@linaro1.home>
In-Reply-To: <1387543554.3404.34.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 07:45, Jon Medhurst (Tixy) wrote:
> On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Make the instruction interpreter call back to semantic action functions
>> through a function pointer array provided by the invoker.  The interpreter
>> decodes the instructions into groups and uses the group number to index
>> into the supplied array.  kprobes and uprobes code will each supply their
>> own array of functions.
>>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>
> Because I've been very slow in reviewing these I've only just noticed
> that some of the the comments I made on version one of this patch didn't
> get a response. I've copied them again below (slightly edited)  and
> heavily trimmed the patch...
>
>>   arch/arm/kernel/kprobes-arm.c    |  41 +++++++++++
>>   arch/arm/kernel/kprobes-common.c |   3 +-
>>   arch/arm/kernel/kprobes-thumb.c  |  92 ++++++++++++++++++------
>>   arch/arm/kernel/kprobes.c        |  10 ++-
>>   arch/arm/kernel/kprobes.h        |  14 ++--
>>   arch/arm/kernel/probes-arm.c     | 114 +++++++++++++++---------------
>>   arch/arm/kernel/probes-arm.h     |  37 ++++++++++
>>   arch/arm/kernel/probes-thumb.c   | 149 +++++++++++++++++++--------------------
>>   arch/arm/kernel/probes-thumb.h   |  14 ++--
>>   arch/arm/kernel/probes.c         |  13 ++--
>>   arch/arm/kernel/probes.h         |  15 ++--
>>   11 files changed, 325 insertions(+), 177 deletions(-)
>>
>> diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
>> index a359475..ee329ff 100644
>> --- a/arch/arm/kernel/kprobes-arm.c
>> +++ b/arch/arm/kernel/kprobes-arm.c
>> @@ -299,3 +299,44 @@ emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
>>   	regs->uregs[rdhi] = rdhiv;
>>   	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
>>   }
>> +
>> +const union decode_item kprobes_arm_actions[] = {
>
> I think it's best if we don't reuse the decode_item type here, this is a
> different sort of table so probably best to have it's own union. Also,
> if we do that, then decode_item can be simplified as it won't need to
> have function pointers in it, i.e. we could end up with...
>
> union decode_action {
>          kprobe_insn_handler_t   *handler;
>          kprobe_custom_decode_t  *decoder;
> };
>
> union decode_item {
>          u32                     bits;
>          const union decode_item *table;
> };
>
> typedef enum kprobe_insn (kprobe_custom_decode_t)(kprobe_opcode_t,
>                                                    struct arch_specific_insn *,
>                                                    union decode_action *actions);
>
>

I've added the following:

typedef enum kprobe_insn (probes_custom_decode_t)(kprobe_opcode_t,
		struct arch_specific_insn *,
		struct decode_header *);

union decode_action {
	kprobe_insn_handler_t	*handler;
	probes_custom_decode_t	*decoder;
};

Note the third argument actually passed into the decoder functions is 
the decode table entry.  decode_action is only used to select a 
decode/emulate/simullate function.

> A second point, I think it would be a good idea to make sure these
> action arrays are the size we expect by adding an entry at the end of
> the relevant enumeration and using that to set the size of the arrays.
> E.g. for this one
>
> enum probes_arm_action {
>          ...
>          ...
>          NUM_PROBES_ARM_ACTIONS
> };
>
> and then use it like:
>
> const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
>
> That way, we at least make any uninitialised entries are null (I
> assume?) which is safer than accidentally indexing beyond the array.
>
>

Done.

>> +	[PROBES_EMULATE_NONE] = {.handler = kprobe_emulate_none},
>> +	[PROBES_SIMULATE_NOP] = {.handler = kprobe_simulate_nop},
>> +	[PROBES_PRELOAD_IMM] = {.handler = kprobe_simulate_nop},
>
> [...]
>
>
>> diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
>> index d14d224..2238972 100644
>> --- a/arch/arm/kernel/probes.h
>> +++ b/arch/arm/kernel/probes.h
>> @@ -131,7 +131,8 @@ void __kprobes kprobe_simulate_nop(struct kprobe *p, struct pt_regs *regs);
>>   void __kprobes kprobe_emulate_none(struct kprobe *p, struct pt_regs *regs);
>>
>>   enum kprobe_insn __kprobes
>> -kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi);
>> +kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>> +		struct decode_header *h);
>>
>>   /*
>>    * Test if load/store instructions writeback the address register.
>> @@ -334,7 +335,7 @@ struct decode_custom {
>>
>>   #define DECODE_CUSTOM(_mask, _value, _decoder)			\
>>   	DECODE_HEADER(DECODE_TYPE_CUSTOM, _mask, _value, 0),	\
>> -	{.decoder = (_decoder)}
>> +	{.bits = (_decoder)}
>>
>
> This third and final comment is probably just bike shedding...
>
> 'bits' looks a bit funny here. I've been trying to think of a way of
> making it nicer but it's difficult. The actual value is one of three
> different enums, so if we were to add another members to decode_item it
> would just have to be "int action", at least that would read nicer in
> these macros and where it gets read out in probes_decode_insn.
>

I agree.  I've added an "int action" to the decode_item union, and use 
it instead of "bits" for the action array index.

I've also updated the description of how this all works, in the comments.

-dl

