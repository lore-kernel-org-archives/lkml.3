Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaBYTzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:55:55 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33863 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaBYTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:55:53 -0500
From: bsegall@google.com
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        pjt@google.com
Subject: Re: [PATCH] sched: put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED
References: <1393328862-19997-1-git-send-email-dietmar.eggemann@arm.com>
	<20140225131642.GA3265@linux.vnet.ibm.com> <530CD71F.9030908@arm.com>
Date: Tue, 25 Feb 2014 11:55:50 -0800
In-Reply-To: <530CD71F.9030908@arm.com> (Dietmar Eggemann's message of "Tue,
	25 Feb 2014 17:47:11 +0000")
Message-ID: <xm26lhwzhsqh.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dietmar Eggemann <dietmar.eggemann@arm.com> writes:

> On 25/02/14 13:16, Srikar Dronamraju wrote:
>>> The struct sched_avg of struct rq is only used in case group
>>> scheduling is enabled inside __update_tg_runnable_avg() to update
>>> per-cpu representation of a task group.  I.e. that there is no need to
>>> maintain the runnable avg of a rq in the !CONFIG_FAIR_GROUP_SCHED case.
>>>
>>> This patch guards struct sched_avg of struct rq and
>>> update_rq_runnable_avg() with CONFIG_FAIR_GROUP_SCHED.
>>>

Reviewed-by: Ben Segall <bsegall@google.com>

If we ever decide to use runnable_avg_sum/period in balance or
something, it's trivial enough to move it back, and there is no point in
calculating unusued stats until then.

>> 
>> While this patch looks good, I see fields in sched_avg viz decay_count,
>> last_runnable_update, load_avg_contrib  only relevant to sched_entity.
>> i.e they don't seem to be updated or used for rq->avg. Should we look at
>> splitting sched_avg so that rq->avg doesn't have unwanted fields?
>
> Yes, AFAICS at least load_avg_contrib and decay_count are only relevant
> for struct sched_entity whereas last_runnable_update is used in
> __update_entity_runnable_avg() itself.
>
> By having struct sched_avg embedded into struct sched_entity and struct
> rq, __update_entity_runnable_avg() and __update_tg_runnable_avg() can be
> used on both and moreover, all current members of struct sched_avg
> belong logically together.
>
> With this patch I was more interested in the fact that we do not have to
> maintain the load avg for struct rq in a !CONFIG_FAIR_GROUP_SCHED system.
>

Yeah, last_runnable_update and runnable_avg_sum/period are used,
decay_count and load_avg_contrib could be moved to the se just fine, and
won't cause any problems.
