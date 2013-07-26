Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab3GZMoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:44:12 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:42518 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3GZMoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM31RJNgDS+gCZobJCt138J6MfbYhwTuTH8MrhP7DEqHGqi5g@mail.gmail.com>
References: <9E84D12D-7389-4D9A-803A-91FD704A92FA@gustavus.edu>
 <20130725112123.GT27075@twins.programming.kicks-ass.net> <228E8D34-E1A9-4D82-B353-F095E473B8D7@gustavus.edu>
 <20130725164051.GZ27075@twins.programming.kicks-ass.net> <20130725211521.GE18254@gmail.com>
 <CAPM31RJNgDS+gCZobJCt138J6MfbYhwTuTH8MrhP7DEqHGqi5g@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 26 Jul 2013 05:43:33 -0700
Message-ID: <CAPM31RJ7Xh5A9cTT_-qd47RH3pRhCqiuh-uKx1gktDk0g-5NNg@mail.gmail.com>
Subject: Re: PROBLEM: Persistent unfair sharing of a processor by auto groups
 in 3.11-rc2 (has twice regressed)
To: Max Hailperin <max@gustavus.edu>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Ah I see what's happening. Currently we only call update_cfs_shares()
>> from the enqueue/dequeue paths. However since your tasks never sleep and
>> cannot migrate they never pass this code. This in turns means that the
>> inter-cgroup relations (the shares) don't get updated.
>>
>> I think your patch would indeed be a correct minimal fix in that it adds
>> a share update to the regular tick path ensuring it gets done even in
>> the absence of enqueues/dequeues.

Hmm.. /me scratches head.

We definitely _used_ to have a call to update_cfs_shares() in
update_cfs_rq_blocked_load() for _exactly_ this reason.

Let's see... a-ha.

It was originally part of:
  f269ae0469fc882332bdfb5db15d3c1315fe2a10 sched: Update_cfs_shares at
period edge

But we reverted that right at the end of the merge window because the
amortization turned out to be too aggressive for interactive
workloads.  This happened in 17bc14b767cf0692420c43dbe5310ae98a5a7836.

Unfortunately, when we did that, we lost the call to update_cfs_shares().

Yes, this wants to be there.

Reviewed-by: Paul Turner <pjt@google.com>

For a description how about something like:

sched: ensure update_cfs_shares() is called for parents of
continuously-running tasks

We typically update a task_group's shares within the dequeue/enqueue
path.  However, continuously running tasks sharing a CPU are not
subject to these updates as they are only put/picked.  Unfortunately,
when we reverted f269ae046 (in 17bc14b7), we lost the augmenting
periodic update that was supposed to account for this; resulting in a
potential loss of fairness.

To fix this, re-introduce the explicit update in
update_cfs_rq_blocked_load() [called via entity_tick()].
