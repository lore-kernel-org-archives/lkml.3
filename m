Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab3CNK6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:58:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53080 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab3CNK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:58:36 -0400
Message-ID: <1363258711.26965.16.camel@laptop>
Subject: Re: [PATCH] sched: wakeup buddy
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Thu, 14 Mar 2013 11:58:31 +0100
In-Reply-To: <513FED85.8030603@linux.vnet.ibm.com>
References: <5136EB06.2050905@linux.vnet.ibm.com>
	 <1362677252.10972.26.camel@laptop> <5139520C.1060109@linux.vnet.ibm.com>
	 <1362998219.14933.9.camel@laptop> <513E9FC6.4060507@linux.vnet.ibm.com>
	 <1363082932.14933.19.camel@laptop> <513FED85.8030603@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 11:07 +0800, Michael Wang wrote:

> However, we already figure out the logical that wakeup related task
> could benefit from closely running, this could promise us somewhat
> reliable benefit.

I'm not convinced that the 2 task wakeup scenario is the only sane
scenario. Imagine a ring of 3 tasks that wakes each other, if the
machine is loaded enough, those 3 tasks might fit a single cpu just
fine -- esp. if one of those is always idle.

But your strict 1:1 wakeup relation thing will completely fail to
detect this.

> IMHO, that sounds a little easier for users than to make the decision on
> tell me how long to pull tasks together, they may be confused...

Users shouldn't ever need/want/etc.. rely on this. They should just run
their programs and be (reasonably) happy.

> In summary, I think we have two point here need to be considered:
> 
> 1. what about the missed optimize timing, that may benefit
>    some workload (although we haven't found such workload yet).

Missed optimize; as in not calling wake_affine() due to the throttle?
If we're calling it at such a high frequency it is very likely the next
call isn't very far away.

> 2. how many benefit could wake_affine() stuff bring to us,
>    if limit rate benefit us, why don't we remove it?

It could bring the same benefit but at lower overhead, what's the point
of computing the same value over and over again? Also, the rate limit
thing naturally works for the soft/hard-irq case.

Now, there's another detail I thought up, one could only limit the
wake_affine() calls once it starts returning false.

