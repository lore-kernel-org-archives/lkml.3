Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaDKCiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:38:55 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37756 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaDKCiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:38:54 -0400
Message-ID: <534755B6.3040102@hitachi.com>
Date: Fri, 11 Apr 2014 11:38:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com> <5346A362.9010802@hitachi.com> <20140410142820.GA24720@redhat.com> <20140410170023.GA31165@redhat.com>
In-Reply-To: <20140410170023.GA31165@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/11 2:00), Oleg Nesterov wrote:
> On 04/10, Oleg Nesterov wrote:
>>
>> On 04/10, Masami Hiramatsu wrote:
>>>
>>> (2014/04/10 22:41), Denys Vlasenko wrote:
>>>> There is this monstrosity, "16-bit override for branches" in 64-mode:
>>>>
>>>> 66 e8 nn nn       callw   <offset16>
>>>>
>>>> Nobody sane uses it because it truncates instruction pointer.
>>>
>>> No problem, insn.c can handle that too. :)
>>
>> Does it?
>>
>> 	"callw 1f; 1:\n"
>> 	"rep; nop\n"
>>
>> objdump:
>>
>> 	66 e8 00 00             callw  485 <_init-0x3ffed3>
>> 	f3 90                   pause
>>
>>
>> if we probe this "callw", we copy MAX_INSN_BYTES into auprobe->insn,
>> and after insn_get_length() (insn_complete() == T)
>>
>> 	// this is correct
>> 	OPCODE1() == e8
>>
>> 	// this all looks wrong
>> 	insn->length == 6
>> 	insn->immediate.value == -1863122944
>> 	insn->immediate.nbytes == 4
>>
>> so it seems that lib/insn.c treats the next "pause" insn as the high
>> 16 bits of address.
> 
> Or perhaps lib/insn.c is fine but objdump is wrong? And everything
> should work correctly? Although in this case I do not understand what
> this "callw" actually does.

Yeah, I think objdump is wrong. see below.

> 
> 	int main(void)
> 	{
> 		asm (
> 			"nop\n"
> 
> 			"callw 1f; 1:\n"
> 			".byte 0\n"
> 			".byte 0\n"
> 		);
> 
> 		return 0;
> 	}
> 
> this runs just fine. With or without gdb. And gdb shows that ->ip is
> incremented by 6 after "callw".
> 
> 	int main(void)
> 	{
> 		asm (
> 			"nop\n"
> 
> 			"callw 1f; 1:\n"
> 			".byte 10\n"
> 			".byte 20\n"
> 		);
> 
> 		return 0;
> 	}
> 
> objdump:
> 
> 	000000000040047c <main>:
> 	  40047c:       55                      push   %rbp
> 	  40047d:       48 89 e5                mov    %rsp,%rbp
> 	  400480:       90                      nop
> 	  400481:       66 e8 00 00             callw  485 <_init-0x3ffed3>
> 	  400485:       0a 14 b8                or     (%rax,%rdi,4),%dl
> 	  400488:       00 00                   add    %al,(%rax)
> 	  40048a:       00 00                   add    %al,(%rax)
> 	  40048c:       c9                      leaveq
> 	  40048d:       c3                      retq
> 
> run:
> 
> 	$ ./t
> 	Segmentation fault (core dumped)
> 
> 	$ gdb ./t core.*
> 	...
> 	#0  0x00000000144a0487 in ?? ()
> 
> 0x144a0487 - 0x400481 == 0x140a0006, this matches the additional 2 .bytes treated
> as offset.

Ah, OK. Ive also forgotten the operand size prefix on x86/x86-64.

The callw is actually "call with operand-size override prefix".
The operand-size prefix(0x66) changes the number of bytes (size) of
its operand (including immediate). But that depends on the opcode.

As I said, opcode 0xe8 (call) has Jz operand (jump offset immediate
with 16bit or 32bit size, depends on the operand size).
And on x86-32, the default operand-size is 4bytes, and it
changes to 2bytes with the 0x66 prefix. This means that the "66 e8"
becomes "callw" on x86-32.

However, please see Intel SDM 2b, appendix A,
A.2.5 Superscripts Utilized in Opcode Tables
----
f64
The operand size is forced to a 64-bit operand size when in 64-bit mode
(prefixes that change operand size are ignored for this instruction in 64-bit
mode
----
And Table A-2. One-byte Opcode Map: (08H — FFH)
-----
CALL(f64) Jz
-----

Ah, I got this. This means that "call" on x86-64 never be "callw",
because the operand-size always 64bit, and in that case, immediate
is 4 bytes(*).

(*) again, at A.2.2 Codes for Operand Type
---
z Word for 16-bit operand-size or doubleword for 32 or 64-bit operand-size.
---

So, at least for this case, objdump is wrong. lib/insn.c is correct. :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


