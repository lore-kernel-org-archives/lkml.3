Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbaD1TX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:23:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524AbaD1TXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:23:19 -0400
Date: Mon, 28 Apr 2014 21:23:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] uprobes: use BX register for rip-relative fixups, not
	AX
Message-ID: <20140428192304.GA9412@redhat.com>
References: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com> <1398704774-25173-2-git-send-email-dvlasenk@redhat.com> <20140428173432.GA27363@redhat.com> <535EA6C3.3030903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535EA6C3.3030903@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Denys Vlasenko wrote:
>
> On 04/28/2014 07:34 PM, Oleg Nesterov wrote:
> >
> > It seems that you are right. But it would be really great if you also
> > provide the test-case which proves the fix ;)
>
> Working on a testcase for this. So far covered div (test1)
> and cmpxchg (test2).
>
> Reproduced failure on a fairly old 3.10.11 kernel:

Just in case, confirm. Reproduced on v3.14 + all recent uprobes changes.

Thanks.

> # gcc -Os -Wall test_riprel.c -o test_riprel
> # ./test_riprel
> test1: pass
> test2: pass
> # perf probe -x ./test_riprel probe1
> # perf record -e probe_test:probe1 ./test_riprel
> test1: FAIL
> test2: pass
> # perf probe -x ./test_riprel probe2
> # perf record -e probe_test:probe2 ./test_riprel
> test1: pass
> test2: FAIL
> 
> Source:
> 
> test_riprel.c
> ==================
> #include <stdio.h>
> 
> static const char *const fail_pass[] = { "FAIL", "pass" };
> 
> long two = 2;
> long test1()
> {
> 	long ax=0, dx=0;
> 	asm volatile("\n"
> "			xor	%%edx,%%edx\n"
> "			lea	2(%%edx),%%eax\n"
> // We divide 2 by 2. Result (in eax) should be 1:
> "	probe1:		.globl	probe1\n"
> "			divl	two(%%rip)\n"
> // If we have a bug (eax mangled on entry) the result will be 2,
> // because eax gets restored by probe machinery.
> 	: "=a" (ax), "=d" (dx) /*out*/
> 	: "0" (ax), "1" (dx) /*in*/
> 	: "memory" /*clobber*/
> 	);
> 	dprintf(2, "%s: %s\n", __func__, fail_pass[ax == 1]);
> 	return ax;
> }
> 
> long val2 = 0;
> long test2()
> {
> 	long old_val2 = val2;
> 	long ax=0, dx=0;
> 	asm volatile("\n"
> "			mov	val2,%%eax\n"     // eax := val2
> "			lea	1(%%eax),%%edx\n" // edx := eax+1
> // eax is equal to val2. cmpxchg should store edx to val2:
> "	probe2:		.globl  probe2\n"
> "			cmpxchg %%edx,val2(%%rip)\n"
> // If we have a bug (eax mangled on entry), val2 will stay unchanged
> 	: "=a" (ax), "=d" (dx) /*out*/
> 	: "0" (ax), "1" (dx) /*in*/
> 	: "memory" /*clobber*/
> 	);
> 	dprintf(2, "%s: %s\n", __func__, fail_pass[val2 == old_val2 + 1]);
> 	return ax == dx;
> }
> 
> int main()
> {
> 	test1();
> 	test2();
> 	return 0;
> }
> 

