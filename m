Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3EIJfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:35:11 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48267 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3EIJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <51887404.4060102@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com>
 <5187760D.8060900@intel.com> <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com>
 <51886460.3020009@intel.com> <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com>
 <51887404.4060102@intel.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 9 May 2013 02:34:34 -0700
Message-ID: <CAPM31RLSOTU+WP-J000EnnaiaPGFZzKT2zBdU_VPHF-XOqfvHg@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 8:24 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 05/07/2013 11:06 AM, Paul Turner wrote:
>>> > Thanks Paul!
>>> > It seems work with this change if new __sched_fork move after the
>>> > p->sched_reset_on_fork setting.
>>> >
>>> > But why we initial avg sum to 1024? new task may goes to sleep, the
>>> > initial 1024 give a unreasonable initial value.
>>> >
>>> > guess let the task accumulate itself avg sum and period is more natural.
>> 1024 is a full single unit period representing ~1ms of time.
>>
>> The reason to store a small initial "observation" here is so that as
>> when we reach our next period edge our load converges (presumably
>> down) towards its true target more smoothly; as well as providing a
>> task additional protection from being considered "small" through
>> start-up.
>>
>
> It will give new forked task 1 ms extra running time. That will bring
> incorrect info if the new forked goes to sleep a while.

This is intentional.

Either:
The sleep was representative, we still converge reasonably quickly to zero.
The sleep was not representative and we have not under-represented the task.

Providing it initial time is entirely about improving numerical stability.

> But this info should benefit to some benchmarks like aim7,
> pthread_cond_broadcast. So I am convinced. :)
>
> What's your opinion of this, Peter?
>
> --
> Thanks
>     Alex
