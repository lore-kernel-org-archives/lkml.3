Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaDYDXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 23:23:19 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37143 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaDYDXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 23:23:17 -0400
Message-ID: <5359D51E.8080109@hitachi.com>
Date: Fri, 25 Apr 2014 12:23:10 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Re: [PATCH] uprobes/x86: Refuse to attach uprobe to "word-sized"
 branch insns
References: <1398359304-26472-1-git-send-email-dvlasenk@redhat.com> <20140424173333.GA416@redhat.com>
In-Reply-To: <20140424173333.GA416@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/25 2:33), Oleg Nesterov wrote:
> Thanks!
> 
> Masami, Jim, any acks?
> 
> On 04/24, Denys Vlasenko wrote:
>>
>> All branch insns on x86 can be prefixed with the operand-size
>> override prefix, 0x66. It was only ever useful for performing
>> jumps to 32-bit offsets in 16-bit code segments.
>>
>> In 32-bit code, such instructions are useless since
>> they cause IP truncation to 16 bits, and in case of call insns,
>> they save only 16 bits of return address and misalign
>> the stack pointer as a "bonus".
>>
>> In 64-bit code, such instructions are treated differently by Intel
>> and AMD CPUs: Intel ignores the prefix altogether,
>> AMD treats them the same as in 32-bit mode.
>>
>> Before this patch, the emulation code would execute
>> the instructions as if they have no 0x66 prefix.
>>
>> With this patch, we refuse to attach uprobes to such insns.
>>
>> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
>> Cc: Oleg Nesterov <oleg@redhat.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you :)

>> ---
>>  arch/x86/kernel/uprobes.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
>> index ace2291..29b152d 100644
>> --- a/arch/x86/kernel/uprobes.c
>> +++ b/arch/x86/kernel/uprobes.c
>> @@ -582,6 +582,7 @@ static struct uprobe_xol_ops branch_xol_ops = {
>>  /* Returns -ENOSYS if branch_xol_ops doesn't handle this insn */
>>  static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
>>  {
>> +	int i;
>>  	u8 opc1 = OPCODE1(insn);
>>
>>  	/* has the side-effect of processing the entire instruction */
>> @@ -612,6 +613,17 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
>>  			return -ENOSYS;
>>  	}
>>
>> +	/*
>> +	 * 16-bit overrides such as CALLW (66 e8 nn nn) are not supported.
>> +	 * Intel and AMD behavior differ in 64-bit mode: Intel ignores 66 prefix.
>> +	 * No one uses these insns.
>> +	 * Reject any branch insns with such prefix.
>> +	 */
>> +	for (i = 0; i < insn->prefixes.nbytes; i++) {
>> +		if (insn->prefixes.bytes[i] == 0x66)
>> +			return -ENOTSUPP;
>> +	}
>> +
>>  	auprobe->branch.opc1 = opc1;
>>  	auprobe->branch.ilen = insn->length;
>>  	auprobe->branch.offs = insn->immediate.value;
>> --
>> 1.8.1.4
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


