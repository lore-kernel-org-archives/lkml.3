Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3LJPO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:14:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51730 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3LJPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:14:56 -0500
Date: Tue, 10 Dec 2013 16:14:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Redpath <chris.redpath@arm.com>
Cc: "pjt@google.com" <pjt@google.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bsegall@google.com
Subject: Re: [PATCH 2/2] sched: update runqueue clock before migrations away
Message-ID: <20131210151428.GH12849@twins.programming.kicks-ass.net>
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
 <1386593950-26475-3-git-send-email-chris.redpath@arm.com>
 <20131210114825.GF12849@twins.programming.kicks-ass.net>
 <52A71605.5090509@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A71605.5090509@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 01:24:21PM +0000, Chris Redpath wrote:
> What happens is that if you have a task which sleeps for a while and wakes
> on a different CPU and the previous CPU hasn't had a tick for a while, then
> that sleep time is lost.

/me more confused now.

Where does update_cfs_rq_blocked_load() account sleep time? Its only
concerned with the blocked decay.

Or is it the decay_count <= 0 case in enqueue_entity_load_avg() that's
screwing you over?

That's guestimating the last_runnable_update based on decay_count, and
per the previous the decay count can get slightly out of sync.

If so, we should look to cure the issue enqueue_entity_load_avg() is
trying to work around, namely the fact that we cannot assume synced
clocks, nor can we read remote clocks atomically.



