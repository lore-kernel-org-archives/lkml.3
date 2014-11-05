Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaKEGYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 01:24:18 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35725 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaKEGYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 01:24:15 -0500
Message-ID: <5459C287.4050006@gmail.com>
Date: Wed, 05 Nov 2014 14:24:07 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, Peter Zijlstra <peterz@infradead.org>
CC: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: [PATCH RFC] sched/deadline: support dl task migrate during cpu
 hotplug
References: <1414740497-7232-1-git-send-email-wanpeng.li@linux.intel.com> <20141103104111.GA23531@worktop.programming.kicks-ass.net> <20141103235747.GA26702@kernel> <20141104083225.GG10501@worktop.programming.kicks-ass.net> <20141104082345.GA22062@kernel> <20141104101022.GH10501@worktop.programming.kicks-ass.net> <5458D506.4080702@gmail.com> <20141104154623.GK10501@worktop.programming.kicks-ass.net> <5458F5C8.1030405@arm.com>
In-Reply-To: <5458F5C8.1030405@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,
On 14/11/4 下午11:50, Juri Lelli wrote:
> Hi,
>
> On 04/11/14 15:46, Peter Zijlstra wrote:
>> On Tue, Nov 04, 2014 at 09:30:46PM +0800, Wanpeng Li wrote:
>>
>>
>>> + if (!rq->online) {
>>> + struct rq *latest_rq = NULL;
>>> + int cpu;
>>> + u64 dmin = LONG_MAX;
>>> +
>>> + for_each_cpu(cpu, &p->cpus_allowed)
>>> + if (cpu_online(cpu) &&
>>> + cpu_rq(cpu)->dl.earliest_dl.curr < dmin) {
>>> + latest_rq = cpu_rq(cpu);
>>> + dmin = latest_rq->dl.earliest_dl.curr;
>>> + }
>> I would have expected something using find_later_rq(), but I might be
>> mistaken, I'll let Juri suggest something.
>>
> Yeah, we should be able to reuse something that we already have. I'm
> actually sorry that I'm not responsive on this, but I'm really busy on
> other things this week. I hope to be able to find some time soon to test
> this all.

I have time to do it, your proposal is a great welcome. ;-)

Regards,
Wanpeng Li

>
> Thanks,
>
> - Juri
>
>>> +
>>> + if (!latest_rq)
>>> + goto unlock;
>>> +
>>> + raw_spin_lock(&latest_rq->lock);
>>> +
>>> + deactivate_task(rq, p, 0);
>>> + set_task_cpu(p, latest_rq->cpu);
>>> + activate_task(latest_rq, p, 0);
>>> +
>>> + raw_spin_unlock(&latest_rq->lock);
>>> + }
>>> +
>>> unlock:
>>> raw_spin_unlock(&rq->lock);

