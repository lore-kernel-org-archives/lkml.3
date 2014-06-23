Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaFWR3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:29:20 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56207 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbaFWR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:29:15 -0400
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, tkhai@yandex.ru,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>, pjt@google.com
Subject: Re: [PATCH 1/3] sched/fair: Disable runtime_enabled on dying rq
References: <20140617130442.29933.54945.stgit@tkhai>
	<1403011450.27674.44.camel@tkhai>
	<20140623100724.GU19860@laptop.programming.kicks-ass.net>
Date: Mon, 23 Jun 2014 10:29:11 -0700
In-Reply-To: <20140623100724.GU19860@laptop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Mon, 23 Jun 2014 12:07:24 +0200")
Message-ID: <xm2661jr1qmw.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Jun 17, 2014 at 05:24:10PM +0400, Kirill Tkhai wrote:
>> @@ -3790,6 +3803,12 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
>>  		cfs_rq->runtime_remaining = 1;
>>  		if (cfs_rq_throttled(cfs_rq))
>>  			unthrottle_cfs_rq(cfs_rq);
>> +
>> +		/*
>> +		 * Offline rq is schedulable till cpu is completely disabled
>> +		 * in take_cpu_down(), so we prevent new cfs throttling here.
>> +		 */
>> +		cfs_rq->runtime_enabled = 0;
>
> Does it make sense to clear this before calling unthrottle_cfs_rq()?
> Just to make sure they're in the right order..

I believe that order is irrelevant here - I do not believe that
unthrottle_cfs_rq(a) can cause a throttle_cfs_rq(a). In fact, I don't
see any code that will check it at all from unthrottle, although I might
be missing something. It _can_ cause a throttle_cfs_rq(parent_cfs_rq(a)),
but that should be fine as long as for_each_leaf_cfs_rq is sorted
correctly.

That said, migrate_tasks drops rq->lock, and I /think/ another cpu could
wake another task onto this cpu, which could then enqueue_throttle its
cfs_rq (which previously had no tasks and thus wasn't on
leaf_cfs_rq_list). You certainly could have tg_set_bandwidth come in and
turn runtime_enabled on.

I think the general idea of turning runtime_enabled off during offline
is fine, ccing pjt to double check.
