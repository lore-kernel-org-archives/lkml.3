Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab3GEEdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 00:33:21 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55771 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3GEEdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 00:33:19 -0400
Message-ID: <51D64C84.5080100@linux.vnet.ibm.com>
Date: Fri, 05 Jul 2013 12:33:08 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com> <51D25A80.8090406@linux.vnet.ibm.com> <20130702085202.GA23916@twins.programming.kicks-ass.net> <51D29EE5.8080307@linux.vnet.ibm.com> <20130704091339.GK18898@dyad.programming.kicks-ass.net> <51D5428D.7080805@linux.vnet.ibm.com> <1372934013.9046.16.camel@marge.simpson.net> <51D633DB.5010508@linux.vnet.ibm.com> <1372997318.7315.23.camel@marge.simpson.net>
In-Reply-To: <1372997318.7315.23.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070504-9574-0000-0000-00000897525B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 12:08 PM, Mike Galbraith wrote:
[snip]
>>
>> Wow, I used to think such issue is very hard to be tracked by
>> benchmarks, is this regression stable?
> 
> Yeah, seems to be.  I was curious as to why you saw an improvement to
> hackbench, didn't seem there should be any, so though I'd try it on my
> little box on the way to a long weekend.  The unexpected happened.

Oh, I think I failed to explain things clearly in comments...

It's not the patch who bring 15% benefit to hackbench, but the
wake-affine stuff itself.

In the prev-test, I removed the whole stuff and find that hackbench
dropped 15%, which means with wake-affine enabled, we will gain 15%
benefit (and that's actually the reason why we don't kill the stuff).

And this idea is try to not harm that 15% benefit, and meanwhile regain
the pgbench lost performance, thus, apply this patch to mainline won't
improve hackbench performance, but improve pgbench performance.

But this regression is really unexpected... I could hardly believe it's
just caused by cache issue now, since the number is not small (10% at
most?).

Have you tried to use more loops and groups? will that show even bigger
regressions?

BTW, is this the results of 10 group and 40 sockets == 400 tasks?

Regards,
Michael Wang

> 
>>> pahole said...
>>>
>>> marge:/usr/local/src/kernel/linux-3.x.git # tail virgin
>>>         long unsigned int          timer_slack_ns;       /*  1512     8 */
>>>         long unsigned int          default_timer_slack_ns; /*  1520     8 */
>>>         atomic_t                   ptrace_bp_refcnt;     /*  1528     4 */
>>>
>>>         /* size: 1536, cachelines: 24, members: 125 */
>>>         /* sum members: 1509, holes: 6, sum holes: 23 */
>>>         /* bit holes: 1, sum bit holes: 26 bits */
>>>         /* padding: 4 */
>>>         /* paddings: 1, sum paddings: 4 */
>>> };
>>>
>>> marge:/usr/local/src/kernel/linux-3.x.git # tail michael
>>>         long unsigned int          default_timer_slack_ns; /*  1552     8 */
>>>         atomic_t                   ptrace_bp_refcnt;     /*  1560     4 */
>>>
>>>         /* size: 1568, cachelines: 25, members: 128 */
>>>         /* sum members: 1533, holes: 8, sum holes: 31 */
>>>         /* bit holes: 1, sum bit holes: 26 bits */
>>>         /* padding: 4 */
>>>         /* paddings: 1, sum paddings: 4 */
>>>         /* last cacheline: 32 bytes */
>>> };
>>>
>>> ..but plugging holes, didn't help, moving this/that around neither, nor
>>> did letting pahole go wild to get the line back.  It's plus signs I tell
>>> ya, the evil things must die ;-)
>>
>> Hmm...so the new members kicked some tail members to a new line...or may
>> be totally different when compiler take part in...
>>
>> It's really hard to estimate the influence, especially when the
>> task_struct is still keep changing...
> 
> Yeah, could be memory layout crud that disappears with the next
> pull/build.  Wouldn't be the first time.
> 
> -Mike
> 

