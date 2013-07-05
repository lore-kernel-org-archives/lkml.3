Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab3GECsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 22:48:07 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:33849 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3GECsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 22:48:05 -0400
Message-ID: <51D633DB.5010508@linux.vnet.ibm.com>
Date: Fri, 05 Jul 2013 10:47:55 +0800
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
References: <51A43B16.9080801@linux.vnet.ibm.com> <51D25A80.8090406@linux.vnet.ibm.com> <20130702085202.GA23916@twins.programming.kicks-ass.net> <51D29EE5.8080307@linux.vnet.ibm.com> <20130704091339.GK18898@dyad.programming.kicks-ass.net> <51D5428D.7080805@linux.vnet.ibm.com> <1372934013.9046.16.camel@marge.simpson.net>
In-Reply-To: <1372934013.9046.16.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070502-2000-0000-0000-00000CC399AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 06:33 PM, Mike Galbraith wrote:
[snip]
>> Well, seems like we still have many follow-up research works after fix
>> the issue ;-)
> 
> Yeah.  Like how to how to exterminate the plus sign, they munch cache
> lines, and have a general tendency to negatively impact benchmarks.
> 
> Q6600 box, hackbench -l 1000
>                                                                        avg
> 3.10.0-regress     2.293     2.297     2.313     2.291     2.295     2.297     1.000
> 3.10.0-regressx    2.560     2.524     2.427     2.599     2.602     2.542     1.106

Wow, I used to think such issue is very hard to be tracked by
benchmarks, is this regression stable?

My test could not get a stable differ, this time a little bit lose but
next time a little bit win, it's always floating, may caused by the
different chip cache-behaviour I suppose...

> 
> pahole said...
> 
> marge:/usr/local/src/kernel/linux-3.x.git # tail virgin
>         long unsigned int          timer_slack_ns;       /*  1512     8 */
>         long unsigned int          default_timer_slack_ns; /*  1520     8 */
>         atomic_t                   ptrace_bp_refcnt;     /*  1528     4 */
> 
>         /* size: 1536, cachelines: 24, members: 125 */
>         /* sum members: 1509, holes: 6, sum holes: 23 */
>         /* bit holes: 1, sum bit holes: 26 bits */
>         /* padding: 4 */
>         /* paddings: 1, sum paddings: 4 */
> };
> 
> marge:/usr/local/src/kernel/linux-3.x.git # tail michael
>         long unsigned int          default_timer_slack_ns; /*  1552     8 */
>         atomic_t                   ptrace_bp_refcnt;     /*  1560     4 */
> 
>         /* size: 1568, cachelines: 25, members: 128 */
>         /* sum members: 1533, holes: 8, sum holes: 31 */
>         /* bit holes: 1, sum bit holes: 26 bits */
>         /* padding: 4 */
>         /* paddings: 1, sum paddings: 4 */
>         /* last cacheline: 32 bytes */
> };
> 
> ..but plugging holes, didn't help, moving this/that around neither, nor
> did letting pahole go wild to get the line back.  It's plus signs I tell
> ya, the evil things must die ;-)

Hmm...so the new members kicked some tail members to a new line...or may
be totally different when compiler take part in...

It's really hard to estimate the influence, especially when the
task_struct is still keep changing...

But the task_struct is really a little big now, may be we could put the
'cold' members into a new structure and just record the pointer, that
may increase the chances of cache-hit the hot members, but it's platform
related and not so easy to be detect...

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

