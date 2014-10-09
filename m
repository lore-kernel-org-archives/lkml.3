Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbaJIQEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:04:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:40972 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJIQE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:04:27 -0400
Date: Thu, 9 Oct 2014 18:04:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH RFC] sched,idle: teach select_idle_sibling about idle
 states
Message-ID: <20141009160424.GT4750@worktop.programming.kicks-ass.net>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
 <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
 <542B277D.7050103@redhat.com>
 <alpine.LFD.2.11.1409301904150.5311@knanqh.ubzr>
 <20141002131548.6cd377d5@cuia.bos.redhat.com>
 <1412317384.5149.19.camel@marge.simpson.net>
 <20141003075012.GF10583@worktop.programming.kicks-ass.net>
 <542EB29A.2050704@redhat.com>
 <20141003144651.GI10583@worktop.programming.kicks-ass.net>
 <542EC2BB.5030907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542EC2BB.5030907@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 11:37:31AM -0400, Rik van Riel wrote:
> Some more brainstorming points...
> 
> 1) We should probably (lazily/batched?) propagate load information
>    up the sched_group tree.  This will be useful for wake_affine,
>    load_balancing, find_idlest_cpu, and select_idle_sibling
> 
> 2) With both find_idlest_cpu and select_idle_sibling walking down
>    the tree from the LLC level, they could probably share code
> 
> 3) Counting both blocked and runnable load may give better long
>    term stability of loads, resulting in a reduction in work
>    preserving behaviour, but an improvement in locality - this
>    could be worthwhile, but it is hard to say in advance
> 
> 4) We can be pretty sure that CPU makers are not going to stop
>    at a mere 18 cores. We need to subdivide things below the LLC
>    level, turning select_idle_sibling and find_idlest_cpu into
>    a tree walk.
> 
>    This means whatever selection criteria are used by these need
>    to be propagated up the sched_group tree. This, in turn, means
>    we probably need to restrict ourselves to things that do not get
>    changed/updated too often.
> 
> Am I overlooking anything?

Well, we can certainly try something like that; but your last point
seems like a contradition; seeing how _the_ important point for
select_idle_sibling() is the actual idle state, and that per definition
is something that can change/update often.

But yes, the only viable option is some artificial breakup of the
topology and we can indeed try and bridge the gap with some caching.
