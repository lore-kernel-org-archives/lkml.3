Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaDPFoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:44:25 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56959 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaDPFoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:44:24 -0400
Message-ID: <534E18B1.4020802@hitachi.com>
Date: Wed, 16 Apr 2014 14:44:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com>
In-Reply-To: <534D4BF3.3020102@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/16 0:10), Sasha Levin wrote:
>>>  - Memory access size. We're currently decoding the size (in bytes) of an
>>> address size, and operand size. kmemcheck would like to know in addition
>>> how many bytes were read/written from/to an address by a given instruction,
>>> so we also keep the size of the memory access.
>>
>> And also, at least in this time, since the operation/mem_size are
>> only used in kmemcheck, you should generate another table for that in kmemcheck
>> from x86-opcode-map.txt.
> 
> I don't want to "teach" kmemcheck to parse x86-opcode-map.txt, that
> should be something that the instruction API does.
> 
> kmemcheck would also be the 3rd in-kernel user of that API, so it's
> not fair to push it as an exception :)

OK, I think we can push the size information bits into current insn_attr_t.
I don't think we should have another byte for that.

For example, here I pulled the operand size detector from my disasm code,

----
static int get_operand_size(struct insn *insn, const char *opnd)
{
        int size = insn->opnd_bytes;

        switch (opnd[1]) {
        case 'b':
        case 'B':
                size = 1;
                break;
        case 'w':
                size = 2;
                break;
        case 'd':
                if (opnd[2] == 'q')
                        size = 16;
                else
                        size = 4;
                break;
        case 'p':
                if (opnd[2] == 's' || opnd[2] == 'd')
                        size = insn_vex_l_bit(insn) ? 32 : 16;
                break;
        case 'q':
                if (opnd[2] == 'q')
                        size = 32;
                else
                        size = 8;
                break;
        case 's':
                if (opnd[2] == 's' || opnd[2] == 'd')
                        size = 16;
                break;
        case 'x':
                size = insn_vex_l_bit(insn) ? 32 : 16;
                break;
        case 'z':
                if (size == 8)
                        size = 4;
                break;
        }
        return size;
}
----

Same thing can be done in awk part and insn.c, and we can encode it by

#define INAT_MAKE_MEMSZ(size) (size << INAT_MEMSZ_OFFS)

And decode it by

insn->memsz_bytes = 1 << ((attr & INAT_MEMSZ_MASK) >> INAT_MEMSZ_OFFS)

Thus, we only need 3 bits to represent 1, 2, 4, 8, 16 and 32. :)

> It's also just one more byte in 'struct insn'...

I actually don't like to expand struct insn_attr_t, I'd like to keep it in
an immediate value.

[...]
>>> @@ -141,15 +141,15 @@ void __kprobes synthesize_relcall(void *from, void *to)
>>>   */
>>>  static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
>>>  {
>>> -	insn_attr_t attr;
>>> +	insn_flags_t flags;
>>>  
>>> -	attr = inat_get_opcode_attribute((insn_byte_t)*insn);
>>> -	while (inat_is_legacy_prefix(attr)) {
>>> +	flags = inat_get_opcode((insn_byte_t)*insn)->flags;
>>
>> Do not refer a member from the return value directly. If it returns NULL,
>> the kernel just crashes!
> 
> Right, I'll fix that. Probably by adding a dummy "empty" instruction
> just so we won't have to deal with too many NULL checks.

Note that if we can put them all in one value, we can avoid such ugly NULL checks.


Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


