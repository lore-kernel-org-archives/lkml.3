Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaAPSMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:12:42 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:52818 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaAPSMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:12:39 -0500
Message-ID: <52D82110.9020309@linaro.org>
Date: Thu, 16 Jan 2014 13:12:32 -0500
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
Subject: Re: [PATCH v4 13/16] ARM: Add an emulate flag to the kprobes/uprobes
 instruction decode functions
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>   <1387166930-13182-14-git-send-email-dave.long@linaro.org>  <1387551482.3404.63.camel@linaro1.home> <52D6E1FE.8000303@linaro.org> <1389863932.3530.12.camel@linaro1.home>
In-Reply-To: <1389863932.3530.12.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/14 04:18, Jon Medhurst (Tixy) wrote:
> On Wed, 2014-01-15 at 14:31 -0500, David Long wrote:
>> On 12/20/13 09:58, Jon Medhurst (Tixy) wrote:
>>> On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
> [...]
>>>>    {
>>>>    #ifdef CONFIG_THUMB2_KERNEL
>>>>    	if (thumb) {
>>>> @@ -253,7 +253,7 @@ set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
>>>>     * non-zero value, the corresponding nibble in pinsn is validated and modified
>>>>     * according to the type.
>>>>     */
>>>> -static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
>>>> +static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs, bool modify)
>>>>    {
>>>>    	probes_opcode_t insn = *pinsn;
>>>>    	probes_opcode_t mask = 0xf; /* Start at least significant nibble */
>>>> @@ -317,9 +317,16 @@ static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
>>>>    		/* Replace value of nibble with new register number... */
>>>>    		insn &= ~mask;
>>>>    		insn |= new_bits & mask;
>>>> +		if (modify) {
>>>> +			/* Replace value of nibble with new register number */
>>>> +			insn &= ~mask;
>>>> +			insn |= new_bits & mask;
>>>> +		}
>>>
>>> Huh? As is, the above addition doesn't do anything because insn has
>>> already been modified. I guess you played with the idea that you needed
>>> to avoid changing insn (you don't) and then didn't undo the experiment
>>> quite right. :-)
>>>
>>
>> The conditional modification of the instruction was part of Rabin's
>> original work for uprobes, but I messed up the merge from an earlier
>> working version of my patches.  My intention was/is to delete the old
>> unconditional code.  Sounds like maybe you disagree though.  The intent
>> is to only modify the instruction in the kprobes case.
>
> 'insn' is the local variable containing the instruction value we're
> processing. It doesn't matter if we change that, we just need to avoid
> updating the instruction in memory, which the code in the next chunk
> already correctly checks for...
>
>>>>    	}
>>>>
>>>> -	*pinsn = insn;
>>>> +	if (modify)
>>>> +		*pinsn = insn;
>>>> +
>>>>    	return true;
>>>>
>
> So only one of these 'if (modify)' checks is required for code
> correctness, and I suggest keeping the second one as it's more explicit
> and defensive.
>
>

OK, I see your point.  I shall simplify the code as you have suggested.

-dl


