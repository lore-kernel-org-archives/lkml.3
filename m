Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaDNFOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 01:14:23 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44796 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaDNFOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 01:14:20 -0400
Message-ID: <534B6EA5.5090302@hitachi.com>
Date: Mon, 14 Apr 2014 14:14:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
References: <20140406201628.GA507@redhat.com> <20140410141806.GA23997@redhat.com> <5346AB07.4090909@redhat.com> <201404101902.38639.vda.linux@googlemail.com>
In-Reply-To: <201404101902.38639.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/11 2:02), Denys Vlasenko wrote:

>> The (f64) modifier in x86-opcode-map.txt means that inat_is_force64()
>> is true for call opcode. So we won't reach "case 2:" in __get_immv32():
>> insn_get_prefixes() did set insn->opnd_bytes to 2 when it saw 0x66 prefix,
>> but it was before we reach this place, and here we overrode it.
>> This is a bug in insn decoder.
> 
> I tested it on both Intel and AMD CPUs and my worst fears came true:
> this instruction has different widths on different CPUs.
> 
> This program:
> 
> # compile with: gcc -nostartfiles -nostdlib -o int3 int3.S
> _start:         .globl  _start
>                 .byte 0x66,0xe9,0,0
>                 .byte 0,0
> 1: jmp 1b
> 
> compiles to this:
> 
> 00000000004000b0 <_start>:
>   4000b0:       66 e9 00 00             jmpw   b4 <_start-0x3ffffc>
>   4000b4:       00 00                   add    %al,(%rax)
>   4000b6:       eb fe                   jmp    4000b6 <_start+0x6>
> 
> and it will reach 0x4000b6 on Intel CPU.
> IOW, Intel SandyBridge CPU thinks that insn is in fact 66 e9 00 00 00 00,
> no RIP truncation occurs.
> 
> On AMD K10 CPU, the very same binary jumps to 0x00b4
> and gets SIGSEGV with MAPERR.
> AMD thinks that the insn is 66 e9 00 00 as shown above.

Hmm, interesting.

> Thus, insn.c decoder implements Intel's idea of this insn
> while binutils (objdump, gdb) implement AMD decode.

Yeah, insn.c relays on intel's opcode map.

> This same program can be compiled to 32-bit code,
> in this mode both CPUs treat insn as 66 e9 00 00.

In 32 bit mode, insn.c treats it as 66 e9 00 00 correctly.

> Oleg, I'm sure you are very sympathetic by now to the idea
> of just not supporting this insn at all. ;)
> 
> You can check whether insn had any prefix by checking
> insn->prefixes->nbytes != 0...

No, since there are other prefixes (and it may be meaningless)
you should find 0x66 in insn->prefixes->bytes[].

> ..but there is a problem with that. P4 introduced branch hints,
> which are implemented using segment prefixes on conditional jumps.
> Meaning that some compilers produce
> 
> 2e 0f 82 nn nn nn nn
> 
> as   (hint not taken) JB <offset32>   insn.
> 
> 2e is CS segment prefix. insn->prefixes->nbytes == 1 for this insn.
> DS prefix (3e) hints that branch is taken.
> 
> They were nearly useless on P4 anyway and ignored by all CPUs
> before or since, but they can be seen in some programs.

Hm, this could be done.

> 
> Looks like we'll need this:
> 
> /*
>  * 16-bit overrides such as CALLW (66 e8 nn nn) are not supported.
>  * Intel and AMD behavior differ in 64-bit mode: Intel ignores 66 prefix.
>  * No one uses these insns.
>  * To filter them out, reject any branch insns with prefixes...
>  */
> if (insn->prefixes->nbytes > 1)
> 	bail_out;

As I said above, check insn->prefixes.bytes[0..nbytes].

> /*
>  * ...Except a single 3e or 2e "branch taken/not taken" hint prefix.
>  * These are (rarely) used, but ignored by any CPU except P4.
>  * Example: 2e 0f 82 nn nn nn nn  is JB,PN <offset32>
>  */
> if (insn->prefixes->nbytes == 1 && (insn->prefixes->bytes[0] | 0x10) != 0x3e))
> 	bail_out;
> 

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


