Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbaCUJXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:23:53 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50904 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760515AbaCUJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:23:49 -0400
Message-ID: <1395393822.6030.59.camel@marge.simpson.net>
Subject: Re: Bug 71331 - mlock yields processor to lower priority process
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Artem Fetishev <artem_fetishev@epam.com>
Cc: peterz@infradead.org, jmdavis@link.com, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Mar 2014 10:23:42 +0100
In-Reply-To: <20140321200248.GB6264@owamsq.epam.com>
References: <20140321200248.GB6264@owamsq.epam.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 23:02 +0300, Artem Fetishev wrote:
> Hi all,
> 
> I am looking at a use-case when a real-time task (B) of higher
> priority is sometimes preempted by another real-time task (A) of lower
> priority. Well, B is not really preempted. It calls mlockall() which
> forces task B to yield the CPU. Under certain conditions, mlockall()
> calls lru_add_drain_all() which schedules a deferred work and wants
> the calling task to wait until that work is complete by putting the
> task into TASK_UNINTERRUPTIBLE state and calling schedule_timeout().
> 
> Tasks utilize SCHED_FIFO policy.
> 
> See details here: https://bugzilla.kernel.org/show_bug.cgi?id=71331
> 
> Besides mlockall, there are other kernel paths which make use of
> lru_add_drain_all() and schedule_timeout(), so I guess there are bunch
> of other syscalls which may lead to the above use-case.
> 
> So the question is: is above use-case an expected behavior of
> real-time tasks or is it a bug in mlockall (i.e. it should not
> interrupt a real-time process)?

How is that different from any other time a task has to yield the CPU
for a bit?  While your high priority task is blocked for whatever
reason, a lower priority task gets to use the CPU.

The bad thing is that in this case, your high priority task becomes
dependent upon kworker threads all over the box, with no mechanism to
guarantee that any of them will ever run.  No PI-boost to the rescue,
nada, say byebye to determinism.

That's true any time you depend upon some generic proxy.  Nothing tracks
IO for instance, to make sure your IO is handled all the way through the
chain by proxies of your priority.  What happens if say kjournald is
preempted by a low priority SCHED_FIFO hog.. nobody needing kjournald to
make progress goes anywhere, SCHED_FIFO 99 may as well be SCHED_IDLE.

In short, yes, I think this is the expected behavior.  Don't do things
that grow dependencies upon generic kernel proxies at critical times.

-Mike

