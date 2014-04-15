Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaDOPLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:11:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20799 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaDOPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:11:08 -0400
Message-ID: <534D4BF3.3020102@oracle.com>
Date: Tue, 15 Apr 2014 11:10:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com>
In-Reply-To: <534CA38C.80501@hitachi.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review!

Some comments below.

On 04/14/2014 11:12 PM, Masami Hiramatsu wrote:
> (2014/04/15 2:44), Sasha Levin wrote:
>> arch/x86/lib/x86-opcode-map.txt provides us quite a lot of information about
>> instructions. So far we've discarded information we didn't need to use
>> elsewhere.
>>
>> This patch extracts two more bits of information about instructions:
> 
> These information looks obscure to me. What information (documents)
> does it based on? Could you give me how would you get it?

It's the two bits described below. Both are extracted from
arch/x86/lib/x86-opcode-map.txt based on the Intel instruction
manual.

>>  - Mnemonic. We'd like to refer to instructions by their mnemonic, and not
>> by their opcode. This both makes code readable, and less confusing and
>> prone to typos since a single mnemonic may have quite a few different
>> opcodes representing it.
> 
> I don't like to call it as "mnemonic", it is just "operation".

> Ah, I see what you are doing now. Hmm, you'd like to generate a mnemonic-ID
> and its macros for each opcode, wouldn't you?
> Even though, it seems waste of memory that we have both opcode and mnemonic-ID,
> can you integrate that? for example, you can use insn->opcode.value instead of
> checking each opcode bytes.

Mnemonics don't have 1:1 relationship with opcodes. So, for example,
if kmemcheck needs to check (and it does) whether a given instruction
is an "ADD", it would need to compare it to 9 different opcodes.

The translation table/code to do that would be bigger than just adding
a mnemonic field in the instruction.

>>  - Memory access size. We're currently decoding the size (in bytes) of an
>> address size, and operand size. kmemcheck would like to know in addition
>> how many bytes were read/written from/to an address by a given instruction,
>> so we also keep the size of the memory access.
> 
> And also, at least in this time, since the operation/mem_size are
> only used in kmemcheck, you should generate another table for that in kmemcheck
> from x86-opcode-map.txt.

I don't want to "teach" kmemcheck to parse x86-opcode-map.txt, that
should be something that the instruction API does.

kmemcheck would also be the 3rd in-kernel user of that API, so it's
not fair to push it as an exception :)

It's also just one more byte in 'struct insn'...

> Hm, could you check out my private project repository of in-kernel disasm?
> https://github.com/mhiramat/linux/tree/inkernel-disasm-20130414
> 
> it's a bit outdated, but I think you can do similar thing. :)

Checked it out, it seems to be close to what we need. Some of the
differences between that and this patchset are due to the use of
the data.

For example, you save mnemonics as strings because you need to print
them nicely for the user, while I save them as an ordinal number
because I need to match mnemonics to instructions.

>>  /* Attribute checking functions */
>> -static inline int inat_is_legacy_prefix(insn_attr_t attr)
>> +static inline int inat_is_legacy_prefix(insn_flags_t flags)
>>  {
>> -	attr &= INAT_PFX_MASK;
>> -	return attr && attr <= INAT_LGCPFX_MAX;
>> +	flags &= INAT_PFX_MASK;
>> +	return flags && flags <= INAT_LGCPFX_MAX;
>>  }
> 
> Since "inat" stands for "instruction-attribute", it should have insn_attr_t.
> And,
> 
>> @@ -141,15 +141,15 @@ void __kprobes synthesize_relcall(void *from, void *to)
>>   */
>>  static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
>>  {
>> -	insn_attr_t attr;
>> +	insn_flags_t flags;
>>  
>> -	attr = inat_get_opcode_attribute((insn_byte_t)*insn);
>> -	while (inat_is_legacy_prefix(attr)) {
>> +	flags = inat_get_opcode((insn_byte_t)*insn)->flags;
> 
> Do not refer a member from the return value directly. If it returns NULL,
> the kernel just crashes!

Right, I'll fix that. Probably by adding a dummy "empty" instruction
just so we won't have to deal with too many NULL checks.

>> @@ -61,6 +63,17 @@ BEGIN {
>>  	imm_flag["Ov"] = "INAT_MOFFSET"
>>  	imm_flag["Lx"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
>>  
>> +	mem_expr = "^[EQXY][a-z]"
>> +	mem_flag["Ev"] = "-1"
>> +	mem_flag["Eb"] = "1"
>> +	mem_flag["Ew"] = "2"
>> +	mem_flag["Ed"] = "4"
>> +	mem_flag["Yb"] = "1"
>> +	mem_flag["Xb"] = "1"
>> +	mem_flag["Yv"] = "-1"
>> +	mem_flag["Xv"] = "-1"
>> +	mem_flag["Qd"] = "8"
>> +
> 
> mem_flag? mem_size?

Yup, that makes more sense. I'll change that.

>> @@ -232,7 +256,7 @@ function add_flags(old,new) {
>>  }
>>  
>>  # convert operands to flags.
>> -function convert_operands(count,opnd,       i,j,imm,mod)
>> +function convert_operands(count,opnd,i,j,imm,mod)
> 
> Don't remove this space, that separates input arguments and local variables.

Will fix.

>> @@ -281,15 +318,23 @@ function convert_operands(count,opnd,       i,j,imm,mod)
>>  	i = 2
>>  	while (i <= NF) {
>>  		opcode = $(i++)
>> +		if (!(opcode in opcode_list)) {
>> +			opcode_list[opcode] = opcode
>> +			gsub(/[^A-Za-z0-9 \t]/, "_", opcode_list[opcode])
>> +			print "#define INSN_OPC_" opcode_list[opcode] " " opcode_cnt
>> +			opcode_cnt++
>> +		}
> 
> No, don't do that. Defining some immediate macros in auto-generated header makes
> code maintenance hard.

Do you have a better suggestion to do the above? The definitions
are pretty simple and straightforward ("INSN_OPC_[mnemonic]") so
I don't feel they will be difficult to maintain. I'm not generating
complex macros here.

> BTW, could you make a cover mail for the series?

Sure.


Thanks,
Sasha
