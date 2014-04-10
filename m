Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965911AbaDJRDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:03:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64867 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965795AbaDJRC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:02:59 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
Date: Thu, 10 Apr 2014 19:02:38 +0200
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
References: <20140406201628.GA507@redhat.com> <20140410141806.GA23997@redhat.com> <5346AB07.4090909@redhat.com>
In-Reply-To: <5346AB07.4090909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201404101902.38639.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2014 16:30, Denys Vlasenko wrote:
> On 04/10/2014 04:18 PM, Oleg Nesterov wrote:
> > On 04/10, Denys Vlasenko wrote:
> >>
> >> There is this monstrosity, "16-bit override for branches" in 64-mode:
> >>
> >> 66 e8 nn nn       callw   <offset16>
> >>
> >> Nobody sane uses it because it truncates instruction pointer.
> >>
> >> Or rather, *I think* it should truncate it (i.e. zero-extend to full width),
> >> but conceivably some CPUs can be buggy wrt that:
> >> they can decide to modify only lower 16 bits of IP,
> >> or even they can decided to use signed <offset16> but apply it
> >> to full-width RIP.
> >>
> >> AMD manuals are not clear on what exactly should happen.
> >>
> >> I am sure no one sane uses this form of branch instructions
> >> in 32-bit and 64-bit code.
> >>
> >> I don't think we should be trying to support it "correctly"
> >> (we can just let program crash with SIGILL or something),
> >> we only need to make sure we don't overlook its existence
> >> and thus are not tricked into touching or modifying unrelated data.
> > 
> > And after the quick check it seems that lib/insn.c doesn't parse
> > "66 e8 nn nn" correctly. It treats the next 2 bytes as the part
> > of 32bit offset.
> 
> I didn't run-test it yet. By code inspection, it seems to work...
> 
> x86-opcode-map.txt:
>     e8: CALL Jz (f64)
> 
> gen-insn-attr-x86.awk:
>     imm_flag["Jz"] = "INAT_MAKE_IMM(INAT_IMM_VWORD32)"
> 
> 
> insn.c:
>         case INAT_IMM_VWORD32:
>                 if (!__get_immv32(insn))
>                         goto err_out;
> ...
> static int __get_immv32(struct insn *insn)
> {
>         switch (insn->opnd_bytes) {
>         case 2:
>                 insn->immediate.value = get_next(short, insn);
>                 insn->immediate.nbytes = 2;
>                 break;
>         case 4:
>         case 8:
>                 insn->immediate.value = get_next(int, insn);
>                 insn->immediate.nbytes = 4;
>                 break;
> 
> 
> ...until I notice this code:
> 
> void insn_get_modrm(struct insn *insn)
> {
> ...
>         if (insn->x86_64 && inat_is_force64(insn->attr))
>                 insn->opnd_bytes = 8;
> 
> 
> The (f64) modifier in x86-opcode-map.txt means that inat_is_force64()
> is true for call opcode. So we won't reach "case 2:" in __get_immv32():
> insn_get_prefixes() did set insn->opnd_bytes to 2 when it saw 0x66 prefix,
> but it was before we reach this place, and here we overrode it.
> This is a bug in insn decoder.

I tested it on both Intel and AMD CPUs and my worst fears came true:
this instruction has different widths on different CPUs.

This program:

# compile with: gcc -nostartfiles -nostdlib -o int3 int3.S
_start:         .globl  _start
                .byte 0x66,0xe9,0,0
                .byte 0,0
1: jmp 1b

compiles to this:

00000000004000b0 <_start>:
  4000b0:       66 e9 00 00             jmpw   b4 <_start-0x3ffffc>
  4000b4:       00 00                   add    %al,(%rax)
  4000b6:       eb fe                   jmp    4000b6 <_start+0x6>

and it will reach 0x4000b6 on Intel CPU.
IOW, Intel SandyBridge CPU thinks that insn is in fact 66 e9 00 00 00 00,
no RIP truncation occurs.

On AMD K10 CPU, the very same binary jumps to 0x00b4
and gets SIGSEGV with MAPERR.
AMD thinks that the insn is 66 e9 00 00 as shown above.

Thus, insn.c decoder implements Intel's idea of this insn
while binutils (objdump, gdb) implement AMD decode.

This same program can be compiled to 32-bit code,
in this mode both CPUs treat insn as 66 e9 00 00.

Oleg, I'm sure you are very sympathetic by now to the idea
of just not supporting this insn at all. ;)

You can check whether insn had any prefix by checking
insn->prefixes->nbytes != 0...

..but there is a problem with that. P4 introduced branch hints,
which are implemented using segment prefixes on conditional jumps.
Meaning that some compilers produce

2e 0f 82 nn nn nn nn

as   (hint not taken) JB <offset32>   insn.

2e is CS segment prefix. insn->prefixes->nbytes == 1 for this insn.
DS prefix (3e) hints that branch is taken.

They were nearly useless on P4 anyway and ignored by all CPUs
before or since, but they can be seen in some programs.

Looks like we'll need this:

/*
 * 16-bit overrides such as CALLW (66 e8 nn nn) are not supported.
 * Intel and AMD behavior differ in 64-bit mode: Intel ignores 66 prefix.
 * No one uses these insns.
 * To filter them out, reject any branch insns with prefixes...
 */
if (insn->prefixes->nbytes > 1)
	bail_out;
/*
 * ...Except a single 3e or 2e "branch taken/not taken" hint prefix.
 * These are (rarely) used, but ignored by any CPU except P4.
 * Example: 2e 0f 82 nn nn nn nn  is JB,PN <offset32>
 */
if (insn->prefixes->nbytes == 1 && (insn->prefixes->bytes[0] | 0x10) != 0x3e))
	bail_out;



-- 
vda
