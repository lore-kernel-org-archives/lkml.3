Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab3EBMCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:02:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:9641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab3EBMCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:02:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,595,1363158000"; 
   d="scan'208";a="331243555"
Message-ID: <1367496146.24182.16.camel@intelbox>
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: David Howells <dhowells@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org
Date: Thu, 02 May 2013 15:02:26 +0300
In-Reply-To: <15077.1367490569@warthog.procyon.org.uk>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
	 <15077.1367490569@warthog.procyon.org.uk>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 11:29 +0100, David Howells wrote:
> Imre Deak <imre.deak@intel.com> wrote:
> 
> > Many callers of the wait_event_timeout() and
> > wait_event_interruptible_timeout() expect that the return value will be
> > positive if the specified condition becomes true before the timeout
> > elapses. However, at the moment this isn't guaranteed. If the wake-up
> > handler is delayed enough, the time remaining until timeout will be
> > calculated as 0 - and passed back as a return value - even if the
> > condition became true before the timeout has passed.
> 
> Fun.
> 
> > Fix this by returning at least 1 if the condition becomes true. This
> > semantic is in line with what wait_for_condition_timeout() does; see
> > commit bb10ed09 - "sched: fix wait_for_completion_timeout() spurious
> > failure under heavy load".
> 
> But now you can't distinguish the timer expiring first, if the thread doing
> the waiting gets delayed sufficiently long for the event to happen.

I'm trying to understand what sequence do you mean. I can think of the
following - as an example - in case of starting a transaction that will
set a completion flag:

waiter                                               completion handler
start transaction
                                                     set completion_flag
ret = wait_event_timeout(timeout, completion_flag)

In this case ret will be timeout which is the original behavior, so
should be ok. One exception is if timeout=0 to begin with, since then -
after this change - ret will be 1. But I can't see how that use case is
useful. I guess I'm missing something, could you elaborate?

--Imre

> I'm not sure there's a good answer - except maybe making the timer expiry
> handler check the condition (which would likely get really yucky really
> quickly).
> 
> David


