Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab3EBMNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:13:41 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:56732 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab3EBMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:13:40 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <15077.1367490569@warthog.procyon.org.uk>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
	<15077.1367490569@warthog.procyon.org.uk>
Date: Thu, 2 May 2013 14:13:39 +0200
Message-ID: <CAKMK7uGKnK1VL5wNiFJXeBOHypWup8-7hZDLSqvEsbwvxVW5tA@mail.gmail.com>
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: David Howells <dhowells@redhat.com>
Cc: Imre Deak <imre.deak@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Lukas Czerner <lczerner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 12:29 PM, David Howells <dhowells@redhat.com> wrote:
>> Fix this by returning at least 1 if the condition becomes true. This
>> semantic is in line with what wait_for_condition_timeout() does; see
>> commit bb10ed09 - "sched: fix wait_for_completion_timeout() spurious
>> failure under heavy load".
>
> But now you can't distinguish the timer expiring first, if the thread doing
> the waiting gets delayed sufficiently long for the event to happen.

That can already happen, e.g.

1. wakeup happens and condition is true.
2. we compute remaining jiffies > 0
-> preempt
3. now wait_for_event_timeout returns.

Only difference is that the delay/preempt happens in between 1. and
2., and then suddenly the wake up didn't happen in time (with the
current return code semantics).

So imo the current behaviour is simply a bug and will miss timely
wakeups in some cases.

The other way round, namely wait_for_event_timeout taking longer than
the timeout is expected (and part of the interface for every timeout
function). So all current callers already need to be able to cope with
random preemption/delays pushing the total time before the call to
wait_for_event and checking the return value over the timeout, even
when condition was signalled in time.

If there's any case which relies on accurate timeout detection that
simply won't work with wait_for_event (they need an nmi or a hw
timestamp counter or something similar).
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
