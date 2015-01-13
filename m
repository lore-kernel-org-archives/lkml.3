Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbbAMOEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:04:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbAMOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:04:48 -0500
Date: Tue, 13 Jan 2015 15:04:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Juri Lelli <juri.lelli@arm.com>, Luca Abeni <luca.abeni@unitn.it>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
Message-ID: <20150113140436.GI25256@twins.programming.kicks-ass.net>
References: <20141230002738.6c12db31@utopia>
 <2629881420411885@web9m.yandex.ru>
 <54AAABFB.3060109@unitn.it>
 <1420499241.3361.14.camel@yandex.ru>
 <20150107080155.1d42d123@luca-1225C>
 <1420633741.12772.10.camel@yandex.ru>
 <54B4D2DF.9010308@arm.com>
 <4500351421141200@web2m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4500351421141200@web2m.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2015 at 12:26:40PM +0300, Kirill Tkhai wrote:
> > Well, I'm inclined to agree to Luca's viewpoint. We should not change
> > parameters of a throttled task or we may affect other tasks.
> 
> Could you explain your viewpoint more? How does this affects other tasks?

I agree with Juri and Luca here. Luca gave an example that DoS's
SCHED_DEADLINE.

In Luca's example we'd constantly call sched_setattr() on a task, which
results in it never throttling and that will affect other tasks, because
if we're running, they cannot be.

> As I understand, in __setparam_dl() we are sure that there is enough
> dl_bw. In __sched_setscheduler() we call it after dl_overflow() check.

Yes, _but_, as per the above. BW includes the sleep time, if we fail to
sleep its all pointless.

We got the runtime (before the throttle) under the promise that we'd go
sleep. When we change our parameters while being throttled we should
adjust the throttle time accordingly. If say we changed from 30% to 35%
we are allowed to sleep less. Now sleeping more than strictly required
is only detrimental to ourselves, so that is not (too) critical.

However, the other way around, if we change from 35% to 30% we should
now effectively sleep longer (for the same runtime we already consumed),
and we must do this, because admission control will instantly assume the
5% change in bandwidth to be available. If we sleep short, this BW is
not in fact available and we break our guarantees.

> >>>  Anyway, I am fine with every patch that fixes the bug :)
> >>  Deadline class requires root privileges. So, I do not see a problem
> >>  here. Please, see __sched_setscheduler().

Its not a priv issue, not doing this makes it impossible to use
SCHED_DEADLINE in the intended way, even for root.

Say we have a userspace task that evaluates and changes runtime
parameters for other tasks (basically what Luca is doing IIRC), and the
changes keep resetting the sleep time, the whole guarantee system comes
down, rendering the deadline system useless.

> >>  If in the future we allow non-privileged users to increase deadline,
> >>  we will reflect that in __setparam_dl() too.
> >
> > I'd say it is better to implement the right behavior even for root, so
> > that we will find it right when we'll grant access to non root users
> > too. Also, even if root can do everything, we always try not to break
> > guarantees that come with admission control (root or non root that is).

Just so.
