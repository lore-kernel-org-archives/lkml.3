Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaEICU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:20:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbaEICU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:20:57 -0400
Message-ID: <536C3B69.1000208@redhat.com>
Date: Thu, 08 May 2014 22:20:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
References: <20140502004237.79dd3de6@annuminas.surriel.com> <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com> <1399016273.5233.94.camel@marge.simpson.net> <536379D0.8070306@redhat.com> <1399030032.5233.142.camel@marge.simpson.net> <5363B793.9010208@redhat.com> <20140506115448.GH11096@twins.programming.kicks-ass.net> <536943C9.4030502@redhat.com> <20140506203916.GQ17778@laptop.programming.kicks-ass.net>
In-Reply-To: <20140506203916.GQ17778@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 04:39 PM, Peter Zijlstra wrote:
> On Tue, May 06, 2014 at 04:19:21PM -0400, Rik van Riel wrote:
>> On 05/06/2014 07:54 AM, Peter Zijlstra wrote:
>>> On Fri, May 02, 2014 at 11:19:47AM -0400, Rik van Riel wrote:
>>>> As an aside, it also looks like SD_BALANCE_WAKE is set on all domains
>                                      ^^^^^^^^^^^^^^^

> No BALANCE_WAKE there

Looks like SD_BALANCE_WAKE is not gotten from the sd flags at
all, but passed into select_task_rq by try_to_wake_up, as a
hard coded sd_flags argument.

static int
try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
{
...
        cpu = select_task_rq(p, p->wake_cpu, SD_BALANCE_WAKE, wake_flags);
...

static inline
int select_task_rq(struct task_struct *p, int cpu, int sd_flags, int
wake_flags)
{
        cpu = p->sched_class->select_task_rq(p, cpu, sd_flags, wake_flags);
...

static int
select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag,
int wake_flags)
{
...

        if (sd_flag & SD_BALANCE_WAKE) {
                if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
                        want_affine = 1;
                new_cpu = prev_cpu;
        }

Should we do that, if SD_WAKE_BALANCE is not set for any sched domain?

-- 
All rights reversed
