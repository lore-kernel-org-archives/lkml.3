Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaJGMfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:35:46 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:52616 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaJGMfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:35:44 -0400
Message-ID: <5433DE11.6060305@linux.vnet.ibm.com>
Date: Tue, 07 Oct 2014 18:05:29 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sam Bobroff <sam.bobroff@au1.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, peterz@infradead.org,
        akpm@linux-foundation.org, tglx@linutronix.de
CC: mikey@neuling.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, palves@redhat.com, oleg@redhat.com,
        dhowells@redhat.com, davej@redhat.com, davem@davemloft.net
Subject: Re: [PATCH V3 0/3] Add new PowerPC specific ELF core notes
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com> <53D0AD2B.4050004@au1.ibm.com>
In-Reply-To: <53D0AD2B.4050004@au1.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100712-0017-0000-0000-00000186E0BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 12:22 PM, Sam Bobroff wrote:
>> Outstanding Issues
>> ==================
>> (1) Running DSCR register value inside a transaction does not seem to be saved
>>     at thread.dscr when the process stops for ptrace examination.
> 
> Since this is fixed by 96d016108640bc2b7fb0ee800737f80923847294, which
> is already upstream, you might want to rebase and re-test. It should
> pass and then you can remove the outstanding issues :-)

Sure will do that.

> 
>>     
>> Test programs
> 
> program
> 
> When I posted the patch I mentioned above, I was asked to move the test
> code into the powerpc kernel selftests so you may want to do this too.

Yes, I will add these ptrace related tests as tm/tm-ptrace.c test case.

> 
> Also, your test program covers everything mine did and more so you might
> want to remove mine if you do add this to the selftests.

The new one will be more ptrace specific, so wont remove yours which tests
the context saved DSCR value.

> 
>> =============
>> #include <unistd.h>
>> #include <stdlib.h>
>> #include <string.h>
>> #include <malloc.h>
>> #include <errno.h>
>> #include <sys/ptrace.h>
>> #include <sys/uio.h>
>> #include <sys/types.h>
>> #include <sys/signal.h>
>> #include <sys/user.h>
> 
> You should include sys/wait.h for waitpid().

Will do.

> status, i and flags are all unused.

Will remove them.

>> 			else
>> 				printf("DSCR FAILED\n");
>>
>> 			/* TM checkpointed GPR */
>> 			iov.iov_base = (struct pt_regs *) malloc(sizeof(struct pt_regs));;
>> 			iov.iov_len = sizeof(struct pt_regs);
>> 			ret = ptrace(PTRACE_GETREGSET, child, NT_PPC_TM_CGPR, &iov);
>> 			if (ret == -1) {
>> 				printf("PTRACE_GETREGSET: NT_PPC_TM_CGPR failed: %s\n", strerror(errno));
>> 				exit(-1);
>> 			}
>>
>> 			if (iov.iov_len != sizeof(struct pt_regs)) {
>> 				printf("NT_PPC_TM_CGPR: Length returned is wrong\n");
>> 				exit(-1);
>> 			}
>>
>> 			pregs1 = iov.iov_base;
>> 			printf("-------TM checkpointed GPR-----\n");
>> 			printf("TM CH GPR[1]: %x\n", pregs1->gpr[1]);
>> 			printf("TM CH GPR[2]: %x\n", pregs1->gpr[2]);
>> 			printf("TM CH NIP: %x\n", pregs1->nip);
>> 			printf("TM CH LINK: %x\n", pregs1->link);
>> 			printf("TM CH CCR: %x\n", pregs1->ccr);
> 
> I get a compiler warning for these printfs: they should be "%lx".

Okay.

> 
>>
>> 			if (pregs1->gpr[1] == VAL1)
>> 				printf("GPR[1] PASSED\n");
>> 			else
>> 				printf("GPR[1] FAILED\n");
>>
>> 			if (pregs1->gpr[2] == VAL2)
>> 				printf("GPR[2] PASSED\n");
>> 			else
>> 				printf("GPR[2] FAILED\n");
>>
>> 			/* TM running GPR */
>> 			ret = ptrace(PTRACE_GETREGS, child, NULL, pregs2);
>> 			if (ret == -1) {
>> 				printf("PTRACE_GETREGS fail: %s\n", strerror(errno));
>> 				exit(-1);
>> 			}
>>
>> 			printf("-------TM running GPR-----\n");
>> 			printf("TM RN GPR[1]: %x\n", pregs2->gpr[1]);
>> 			printf("TM RN GPR[2]: %x\n", pregs2->gpr[2]);
>> 			printf("TM RN NIP: %x\n", pregs2->nip);
>> 			printf("TM RN LINK: %x\n", pregs2->link);
>> 			printf("TM RN CCR: %x\n", pregs2->ccr);
> 
> Same as above, I get warnings and they should be "%lx".

Okay. Will fix them.

