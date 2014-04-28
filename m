Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaD1T2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:28:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbaD1T17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:27:59 -0400
Message-ID: <535EA6C3.3030903@redhat.com>
Date: Mon, 28 Apr 2014 21:06:43 +0200
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
References: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com> <1398704774-25173-2-git-send-email-dvlasenk@redhat.com> <20140428173432.GA27363@redhat.com>
In-Reply-To: <20140428173432.GA27363@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 07:34 PM, Oleg Nesterov wrote:
> Thanks...
> 
> Again, the change in riprel_analyze() needs the review from someone
> who understands the instruction decoding/encoding.
> 
> On 04/28, Denys Vlasenko wrote:
>>
>> Otherwise, instructions such as cmpxchg and div will be mishandled.
> 
> It seems that you are right. But it would be really great if you also
> provide the test-case which proves the fix ;)

Working on a testcase for this. So far covered div (test1)
and cmpxchg (test2).

Reproduced failure on a fairly old 3.10.11 kernel:

# gcc -Os -Wall test_riprel.c -o test_riprel
# ./test_riprel
test1: pass
test2: pass
# perf probe -x ./test_riprel probe1
# perf record -e probe_test:probe1 ./test_riprel
test1: FAIL
test2: pass
# perf probe -x ./test_riprel probe2
# perf record -e probe_test:probe2 ./test_riprel
test1: pass
test2: FAIL

Source:

test_riprel.c
==================
#include <stdio.h>

static const char *const fail_pass[] = { "FAIL", "pass" };

long two = 2;
long test1()
{
	long ax=0, dx=0;
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
	dprintf(2, "%s: %s\n", __func__, fail_pass[ax == 1]);
	return ax;
}

long val2 = 0;
long test2()
{
	long old_val2 = val2;
	long ax=0, dx=0;
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
	dprintf(2, "%s: %s\n", __func__, fail_pass[val2 == old_val2 + 1]);
	return ax == dx;
}

int main()
{
	test1();
	test2();
	return 0;
}

