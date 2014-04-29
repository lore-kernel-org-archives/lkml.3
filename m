Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbaD2KQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:16:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaD2KQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:16:22 -0400
Message-ID: <535F7BEC.3030106@redhat.com>
Date: Tue, 29 Apr 2014 12:16:12 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] uprobes: use BX register for rip-relative fixups, not
 AX
References: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com> <1398704774-25173-2-git-send-email-dvlasenk@redhat.com> <20140428173432.GA27363@redhat.com> <535EA6C3.3030903@redhat.com> <20140428192304.GA9412@redhat.com>
In-Reply-To: <20140428192304.GA9412@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 09:23 PM, Oleg Nesterov wrote:
> On 04/28, Denys Vlasenko wrote:
>>
>> On 04/28/2014 07:34 PM, Oleg Nesterov wrote:
>>>
>>> It seems that you are right. But it would be really great if you also
>>> provide the test-case which proves the fix ;)
>>
>> Working on a testcase for this. So far covered div (test1)
>> and cmpxchg (test2).

I looked thourgh docs and documented other weird insns.

Executive summary: looks like we will need to add [e]vex.b
bit clearing analogous to rex.b clearing we already have,
add checks for [e]vex.vvvv colliding with our selected
scratch reg, therefore we will need *three* candidates
for scratch reg (up from two as we do today).

So far I didn't find instructions using modrm and also
using SI register implicitly. DI register is used only
by one insn (maskmovq) and BX register is used only by
one too (cmpxchg8b).
BP is stack-segment based (may be a problem?).
AX, DX, CX are off-limits (many implicit users).
SP is unusable (it's stack pointer - think about "pop mem";
also, rsp+disp32 needs sib encoding -> insn length change).

Here's a more complete testcase which also tests cmpxchg8b
case:

test_riprel.c
=============
// What instructions have modrm bytes
// and also use registers not encoded in modrm byte?
//
//[i]div/[i]mul: implicitly use dx:ax
//
//shift ops: implicitly use cx
//
//cmpxchg: implicitly uses ax
//
//cmpxchg8/16b: implicitly uses dx:ax and bx:cx
//
//[e]vex insns: can have three operands
//IOW: they may use additional register encoded in [e]vex.vvvv
//
//mulx: implicitly uses dx.
//It's a new instruction (first appeared in Haswell, part of BMI2 instructions)
//mulx r/m,r1,r2: r1:r2 = dx * r/m
//It is vex-encoded. Example where we can use none of bx,cx,dx as scratch:
//c4 e2 63 f6 0d disp32   mulx disp32(%rip),%ebx,%ecx
//
//maskmovq: implicitly uses rdi as pointer to destination memory operand.
//MMXext insn. Encoding: 0f f7 modrm
//[v]maskmovdqu: similar SSE2/AVX insn
//Encoding: 66 0f f7 modrm (or vex-encoded analogue: c5 f9 f7 modrm).
//Stores first operand, byte-masked by second operand msb's in each byte, to (ds:rdi).
//
//AMD says it has no 3-operand form (vex.vvvv must be 1111)
//and that it can have only register operands, not mem
//(its modrm byte must have mode=11)
//However, if we don't special-case analysis of this insn,
//and if a memory-referencing modrm form will be allowed in the future,
//then we see it as "yet another modrm insn",
//can see it using register numbers colliding with our "scratch regs",
//and we may end up selecting rdi register as scrath - which
//is wrong for this insn.
//
//[v]pcmpistri: implicitly uses cx, xmm0
//[v]pcmpistrm: implicitly uses xmm0
//[v]pcmpestri: implicitly uses ax, dx, cx, xmm0
//[v]pcmpestrm: implicitly uses ax, dx, xmm0
//Evil SSE4.2 string comparison ops from hell.

#include <stdio.h>

static const char *const pass[] = { "FAIL", "pass" };

long two = 2;
void test1(void)
{
	long ax = 0, dx = 0;
	asm volatile("\n"
"			xor	%%edx,%%edx\n"
"			lea	2(%%edx),%%eax\n"
// We divide 2 by 2. Result (in eax) should be 1:
"	probe1:		.globl	probe1\n"
"			divl	two(%%rip)\n"
// If we have a bug (eax mangled on entry) the result will be 2,
// because eax gets restored by probe machinery.
	: "=a" (ax), "=d" (dx) /*out*/
	: "0" (ax), "1" (dx) /*in*/
	: "memory" /*clobber*/
	);
	dprintf(2, "%s: %s\n", __func__,
		pass[ax == 1]
	);
}

long val2 = 0;
void test2(void)
{
	long old_val = val2;
	long ax = 0, dx = 0;
	asm volatile("\n"
"			mov	val2,%%eax\n"     // eax := val2
"			lea	1(%%eax),%%edx\n" // edx := eax+1
// eax is equal to val2. cmpxchg should store edx to val2:
"	probe2:		.globl  probe2\n"
"			cmpxchg %%edx,val2(%%rip)\n"
// If we have a bug (eax mangled on entry), val2 will stay unchanged
	: "=a" (ax), "=d" (dx) /*out*/
	: "0" (ax), "1" (dx) /*in*/
	: "memory" /*clobber*/
	);
	dprintf(2, "%s: %s\n", __func__,
		pass[val2 == old_val + 1]
	);
}

long val3[2] = {0,0};
void test3(void)
{
	long old_val = val3[0];
	long ax = 0, dx = 0;
	asm volatile("\n"
"			mov	val3,%%eax\n"  // edx:eax := val3
"			mov	val3+4,%%edx\n"
"			mov	%%eax,%%ebx\n" // ecx:ebx := edx:eax + 1
"			mov	%%edx,%%ecx\n"
"			add	$1,%%ebx\n"
"			adc	$0,%%ecx\n"
// edx:eax is equal to val3. cmpxchg8b should store ecx:ebx to val3:
"	probe3:		.globl  probe3\n"
"			cmpxchg8b val3(%%rip)\n"
// If we have a bug (edx:eax mangled on entry), val3 will stay unchanged.
// If ecx:edx in mangled, val3 will get wrong value.
	: "=a" (ax), "=d" (dx) /*out*/
	: "0" (ax), "1" (dx) /*in*/
	: "cx", "bx", "memory" /*clobber*/
	);
	dprintf(2, "%s: %s\n", __func__,
		pass[val3[0] == old_val + 1 && val3[1] == 0]
	);
}

// Usage:
// gcc -Os -Wall test_riprel.c -o test_riprel
//
// perf probe -x ./test_riprel probe1
// perf record -e probe_test:probe1 ./test_riprel
// ^^^^^^^^^^^^^^^^ repeat for other probeN's
int main(int argc, char **argv)
{
	test1();
	test2();
	test3();
	return 0;
}

