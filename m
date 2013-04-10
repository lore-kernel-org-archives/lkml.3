Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935932Ab3DJCcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 22:32:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:59157 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765455Ab3DJCcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 22:32:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,443,1363158000"; 
   d="scan'208";a="292697252"
Message-ID: <5164CEF9.1080005@intel.com>
Date: Wed, 10 Apr 2013 10:31:21 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, rafael.j.wysocki@intel.com,
        jkosina@suse.cz, Clark Williams <clark.williams@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com
Subject: Re: [patch v3 6/8] sched: consider runnable load average in move_tasks
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <1364873008-3169-7-git-send-email-alex.shi@intel.com> <CAKfTPtBoV3KoSHuTnZVrvPdCM+5ckFGXfM11oCB1Le_Zmy1hYQ@mail.gmail.com> <5163CBE6.4070209@intel.com> <CAKfTPtDbiv2ACgem7k7YxcxgwGA4-JY1LcAg0B_XOVaOeE8aeQ@mail.gmail.com> <5163EF9E.4030005@intel.com> <CAKfTPtAY3HpFhWiW=-P0_oBss2XhKJYRQJvFHqqapcZ7O0P6kQ@mail.gmail.com> <51642A47.9060602@intel.com> <CAKfTPtA9heicJvotYevr8Ua-tqObvAGTQHHZvkB8SCnSgoFr+Q@mail.gmail.com>
In-Reply-To: <CAKfTPtA9heicJvotYevr8Ua-tqObvAGTQHHZvkB8SCnSgoFr+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 11:16 PM, Vincent Guittot wrote:
>> > Thanks a lot for info sharing! Vincent.
>> >
>> > But I checked the rq->avg and task->se.avg, seems none of them are
>> > possible be updated on different CPU at the same time. So my printk
>> > didn't catch this with benchmark kbuild and aim7 on my SNB EP box.
> The problem can happen because reader and writer are accessing the
> variable asynchronously and on different CPUs
> 
> CPUA write runnable_avg_sum
> CPUB read runnable_avg_sum
> CPUB read runnable_avg_period
> CPUA write runnable_avg_period
> 
> I agree that the time window, during which this can occur, is short
> but not impossible

May I didn't say clear. Vincent.

member of rq struct include avg, should be protected by rq->lock when
other cpu want to access them. Or be accessed only by local cpu. So they
should be no above situation.
And for per task avg, the task is impossible to be on different cpu at
the same time. so there are also no above problem.

I thought the problem may exists for middle level entity, but seems task
group has each of entity on every cpu. So there is no this problem too.

So, you may better to hold rq->lock when check the buddy cpu info.

Correct me if sth wrong. :)

-- 
Thanks Alex
