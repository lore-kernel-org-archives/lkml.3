Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaBYRrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:47:12 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51480 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaBYRrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:47:11 -0500
Message-ID: <530CD71F.9030908@arm.com>
Date: Tue, 25 Feb 2014 17:47:11 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ben Segall <bsegall@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED
References: <1393328862-19997-1-git-send-email-dietmar.eggemann@arm.com> <20140225131642.GA3265@linux.vnet.ibm.com>
In-Reply-To: <20140225131642.GA3265@linux.vnet.ibm.com>
X-OriginalArrivalTime: 25 Feb 2014 17:47:14.0172 (UTC) FILETIME=[9E023BC0:01CF3251]
X-MC-Unique: 114022517470904101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/02/14 13:16, Srikar Dronamraju wrote:
>> The struct sched_avg of struct rq is only used in case group
>> scheduling is enabled inside __update_tg_runnable_avg() to update
>> per-cpu representation of a task group.  I.e. that there is no need to
>> maintain the runnable avg of a rq in the !CONFIG_FAIR_GROUP_SCHED case.
>>
>> This patch guards struct sched_avg of struct rq and
>> update_rq_runnable_avg() with CONFIG_FAIR_GROUP_SCHED.
>>
> 
> While this patch looks good, I see fields in sched_avg viz decay_count,
> last_runnable_update, load_avg_contrib  only relevant to sched_entity.
> i.e they don't seem to be updated or used for rq->avg. Should we look at
> splitting sched_avg so that rq->avg doesn't have unwanted fields?

Yes, AFAICS at least load_avg_contrib and decay_count are only relevant
for struct sched_entity whereas last_runnable_update is used in
__update_entity_runnable_avg() itself.

By having struct sched_avg embedded into struct sched_entity and struct
rq, __update_entity_runnable_avg() and __update_tg_runnable_avg() can be
used on both and moreover, all current members of struct sched_avg
belong logically together.

With this patch I was more interested in the fact that we do not have to
maintain the load avg for struct rq in a !CONFIG_FAIR_GROUP_SCHED system.

-- Dietmar

> 
> --
> Thanks and Regards
> Srikar Dronamraju
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


