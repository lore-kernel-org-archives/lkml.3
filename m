Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab3EGCSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:18:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:2097 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab3EGCSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:18:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="309280346"
Message-ID: <51886460.3020009@intel.com>
Date: Tue, 07 May 2013 10:18:08 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com> <5187760D.8060900@intel.com> <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com>
In-Reply-To: <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 06:17 PM, Paul Turner wrote:
>>> >> Rather than exposing the representation of load_avg_contrib to
>>> >> __sched_fork it might also be better to call:
>>> >>   __update_task_entity_contrib(&p->se)
>>> >> After the initialization above; this would also avoid potential bugs
>>> >> like the missing scale_load() above.
>> >
>> > Above simple change can not work.
> Could you provide additional detail here?  Note that the sum change I
> was suggesting above was:
> 
> __sched_fork():
> +       p->se.avg.decay_count = 0;
> +       p->se.avg.runnable_avg_period = 1024;
> +       p->se.avg.runnable_avg_sum = 1024;
> +       __update_task_entity_contrib(&p->se);
> 
> [ Also: move __sched_fork() beyond p->sched_reset_on_fork in sched_fork(). ]

Thanks Paul!
It seems work with this change if new __sched_fork move after the
p->sched_reset_on_fork setting.

But why we initial avg sum to 1024? new task may goes to sleep, the
initial 1024 give a unreasonable initial value.

guess let the task accumulate itself avg sum and period is more natural.
> 
>> > We had talked this solution months ago. And get agreement on this patch.
>> > https://lkml.org/lkml/2013/2/20/48  :)
> Yes, I made the same suggestion in the last round, see:
> https://lkml.org/lkml/2013/2/19/176
> 
> Your reply there seems like an ack of my suggestion, the only
> difference I'm seeing is that using __update_task_entity_contrib() as
> originally suggested is safer since it keeps the representation of
> load_avg_contrib opaque.

Yes, using __update_task_entity_contrib make load_avg_contrib opaque.
but just initial value 1024 is a bit arbitrary.
> 


-- 
Thanks
    Alex
