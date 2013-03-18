Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312Ab3CRD1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 23:27:07 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34158 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3CRD1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 23:27:03 -0400
Message-ID: <51468976.4040602@linux.vnet.ibm.com>
Date: Mon, 18 Mar 2013 11:26:46 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362677252.10972.26.camel@laptop> <5139520C.1060109@linux.vnet.ibm.com> <1362998219.14933.9.camel@laptop> <513E9FC6.4060507@linux.vnet.ibm.com> <1363082932.14933.19.camel@laptop> <513FED85.8030603@linux.vnet.ibm.com> <1363258711.26965.16.camel@laptop> <5142BE99.4070001@linux.vnet.ibm.com>
In-Reply-To: <5142BE99.4070001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031803-5816-0000-0000-00000726E0EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
>> It could bring the same benefit but at lower overhead, what's the point
>> of computing the same value over and over again? Also, the rate limit
>> thing naturally works for the soft/hard-irq case.
> 
> Just try to confirm my understanding, so we are going to do something
> like:
> 
> 	if (now - wakee->last > time_limit) && wakeup_affine()
> 		wakee->last = now
> 		select_idle_sibling(curr_cpu)
> 	else
> 		select_idle_sibling(prev_cpu)
> 
> And time_limit is some static value respect to the rate of load balance,
> is that correct?
> 
> Currently I haven't found regression by reduce the rate, but if we found
> such benchmark, we may still need a way (knob or CONFIG) to disable this
> limitation.

I've done some fast tests on this proposal, on my 12 cpu box, the
pgbench 32 clients test, for a 1000ms time_limit, the benefit is just
like the 8 ref wakeup buddy, when adopt 10ms time_limit, the benefit
dropped half, when time_limit is 1ms, the benefit is less than 10%.

			tps

original		43404

wakeup-buddy		63024		+45.20%

1s-limit		62359		+43.67%
100ms-limit		57547		+32.58%
10ms-limit		52258		+20.40%
1ms-limit		46535		+7.21%

Other test items of pgbench are corresponding, and other benchmarks
still inert to the changes.

I'm planning to make a new patch for this approach later, in which
time_limit is a knob with the default value 1ms (usually the initial
value of balance_interval and the value of min_interval), that will
based on the latest tip tree.

Regards,
Michael Wang

