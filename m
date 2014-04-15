Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaDODMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:12:23 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47049 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaDODMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:12:20 -0400
Message-ID: <534CA38C.80501@hitachi.com>
Date: Tue, 15 Apr 2014 12:12:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1397497450-6440-3-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/15 2:44), Sasha Levin wrote:
> arch/x86/lib/x86-opcode-map.txt provides us quite a lot of information about
> instructions. So far we've discarded information we didn't need to use
> elsewhere.
> 
> This patch extracts two more bits of information about instructions:

These information looks obscure to me. What information (documents)
does it based on? Could you give me how would you get it?

>  - Mnemonic. We'd like to refer to instructions by their mnemonic, and not
> by their opcode. This both makes code readable, and less confusing and
> prone to typos since a single mnemonic may have quite a few different
> opcodes representing it.

I don't like to call it as "mnemonic", it is just "operation".

>  - Memory access size. We're currently decoding the size (in bytes) of an
> address size, and operand size. kmemcheck would like to know in addition
> how many bytes were read/written from/to an address by a given instruction,
> so we also keep the size of the memory access.

And also, at least in this time, since the operation/mem_size are
only used in kmemcheck, you should generate another table for that in kmemcheck
from x86-opcode-map.txt.

Hm, could you check out my private project repository of in-kernel disasm?
https://github.com/mhiramat/linux/tree/inkernel-disasm-20130414

it's a bit outdated, but I think you can do similar thing. :)


>  /* Attribute checking functions */
> -static inline int inat_is_legacy_prefix(insn_attr_t attr)
> +static inline int inat_is_legacy_prefix(insn_flags_t flags)
>  {
> -	attr &= INAT_PFX_MASK;
> -	return attr && attr <= INAT_LGCPFX_MAX;
> +	flags &= INAT_PFX_MASK;
> +	return flags && flags <= INAT_LGCPFX_MAX;
>  }

Since "inat" stands for "instruction-attribute", it should have insn_attr_t.
And,

> @@ -141,15 +141,15 @@ void __kprobes synthesize_relcall(void *from, void *to)
>   */
>  static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
>  {
> -	insn_attr_t attr;
> +	insn_flags_t flags;
>  
> -	attr = inat_get_opcode_attribute((insn_byte_t)*insn);
> -	while (inat_is_legacy_prefix(attr)) {
> +	flags = inat_get_opcode((insn_byte_t)*insn)->flags;

Do not refer a member from the return value directly. If it returns NULL,
the kernel just crashes!

> @@ -61,6 +63,17 @@ BEGIN {
>  	imm_flag["Ov"] = "INAT_MOFFSET"
>  	imm_flag["Lx"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
>  
> +	mem_expr = "^[EQXY][a-z]"
> +	mem_flag["Ev"] = "-1"
> +	mem_flag["Eb"] = "1"
> +	mem_flag["Ew"] = "2"
> +	mem_flag["Ed"] = "4"
> +	mem_flag["Yb"] = "1"
> +	mem_flag["Xb"] = "1"
> +	mem_flag["Yv"] = "-1"
> +	mem_flag["Xv"] = "-1"
> +	mem_flag["Qd"] = "8"
> +

mem_flag? mem_size?

> @@ -232,7 +256,7 @@ function add_flags(old,new) {
>  }
>  
>  # convert operands to flags.
> -function convert_operands(count,opnd,       i,j,imm,mod)
> +function convert_operands(count,opnd,i,j,imm,mod)

Don't remove this space, that separates input arguments and local variables.


> @@ -281,15 +318,23 @@ function convert_operands(count,opnd,       i,j,imm,mod)
>  	i = 2
>  	while (i <= NF) {
>  		opcode = $(i++)
> +		if (!(opcode in opcode_list)) {
> +			opcode_list[opcode] = opcode
> +			gsub(/[^A-Za-z0-9 \t]/, "_", opcode_list[opcode])
> +			print "#define INSN_OPC_" opcode_list[opcode] " " opcode_cnt
> +			opcode_cnt++
> +		}

No, don't do that. Defining some immediate macros in auto-generated header makes
code maintenance hard.


BTW, could you make a cover mail for the series?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


