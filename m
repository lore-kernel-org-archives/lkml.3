Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3K0PmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:42:10 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:33921 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3K0PmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:42:08 -0500
Date: Wed, 27 Nov 2013 16:42:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Juri Lelli <juri.lelli@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com
Subject: Re: [PATCH 08/14] sched: add latency tracing for -deadline tasks.
Message-ID: <20131127154202.GB26095@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
 <1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
 <20131120163318.10253e43@gandalf.local.home>
 <5295F711.5010708@gmail.com>
 <20131127091647.4e16ce53@gandalf.local.home>
 <20131127142649.GC13532@twins.programming.kicks-ass.net>
 <20131127143435.GD25043@gmail.com>
 <20131127145837.GE16796@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127145837.GE16796@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and even this works:

triton:~> cat test.c

struct foo {
        int a;
        int b;
};

int litter_our_stack(void)
{
        volatile struct foo x = { .a = 1, .b = 2 };

        return x.b;
}

int test_code(void)
{
        volatile struct foo x = { .a = 1, /* .b not initialized explicitly */ };

        return x.b;
}

int main(void)
{
        return litter_our_stack() + test_code();
}

triton:~> gcc -Wall -Wextra -O0 -o test test.c; ./test; echo $?
2
triton:~> 


The result is 2, so x.b in test_code() got explicitly set to 0.

If it was uninitialized, not only would we expect a compiler warning, 
but we'd also get a result of '4'. (the two functions have the same 
stack depth, so 'litter_our_stack()' initializes .b to 2.)

-O0 guarantees that GCC just dumbly implements these functions without 
any optimizations.

Thanks,

	ngo
