Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab3LJP5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:57:37 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51418 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3LJP5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:57:34 -0500
Message-ID: <52A7397F.4000806@arm.com>
Date: Tue, 10 Dec 2013 15:55:43 +0000
From: Chris Redpath <chris.redpath@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "pjt@google.com" <pjt@google.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bsegall@google.com" <bsegall@google.com>
Subject: Re: [PATCH 2/2] sched: update runqueue clock before migrations away
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com> <1386593950-26475-3-git-send-email-chris.redpath@arm.com> <20131210114825.GF12849@twins.programming.kicks-ass.net> <52A71605.5090509@arm.com> <20131210151428.GH12849@twins.programming.kicks-ass.net>
In-Reply-To: <20131210151428.GH12849@twins.programming.kicks-ass.net>
X-MC-Unique: 113121015554302802
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/13 15:14, Peter Zijlstra wrote:
> On Tue, Dec 10, 2013 at 01:24:21PM +0000, Chris Redpath wrote:
>> What happens is that if you have a task which sleeps for a while and wakes
>> on a different CPU and the previous CPU hasn't had a tick for a while, then
>> that sleep time is lost.
>
> /me more confused now.
>
> Where does update_cfs_rq_blocked_load() account sleep time? Its only
> concerned with the blocked decay.
>
> Or is it the decay_count <= 0 case in enqueue_entity_load_avg() that's
> screwing you over?
>
Sorry, I don't appear to have explained myself well.

We don't get a negative decay_count when we synchronize the entity in
this situation because the decay_counter of the runqueue has not been
updated since the last update. __synchronize_entity_decay will return 0,
and hence the entity load average does not decay and neither does
blocked load.

It doesn't seem to matter much that the blocked load doesn't decay
because we are about to remove the load from the now-unblocked entity
anyway, but it impacts the entity load average because that sleep time
has now disappeared.

The call to update_rq_clock() is needed to get rq->clock_task updated,
and then I use update_cfs_rq_blocked_load() to get the decay_counter
updated.

It has the side-effect of updating the blocked_load_avg to stay
consistent but the effect I am looking for is the decay_counter update.

> That's guestimating the last_runnable_update based on decay_count, and
> per the previous the decay count can get slightly out of sync.

The guesstimation works fine, the issue is only that we can't tell at
this point how much time that entity was asleep when the CPU it ran on
has no tick and since it is too expensive to synchronize the clocks,
there isn't (currently) a way to find out without updating the rq we
came from.

I can't see anything handy lying around in struct rq, but is there a
copy of the jiffies held anywhere per-cpu presuming it would stop being
updated when the tick stops? If not, I could store one somewhere as part
of turning the tick off and then we could use the difference between
that and the current jiffies count to estimate the amount of time in
limbo. That would almost certainly be accurate enough for me - a few ms
won't hurt but when we lose seconds it does.

>
> If so, we should look to cure the issue enqueue_entity_load_avg() is
> trying to work around, namely the fact that we cannot assume synced
> clocks, nor can we read remote clocks atomically.
>

That would be nice, but IMHO the estimation error is small and
self-consistent so the optimization appears good.

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

ARM Limited, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2557590
ARM Holdings plc, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2548782

