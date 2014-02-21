Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbaBUMJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:09:33 -0500
Received: from forward3h.mail.yandex.net ([84.201.187.148]:49406 "EHLO
	forward3h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbaBUMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:09:32 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <128831392982418@web15j.yandex.ru>
References: <230991392848160@web13m.yandex.ru> <20140221103715.GP9987@twins.programming.kicks-ass.net> <128831392982418@web15j.yandex.ru>
Subject: Re: [RFC] sched/deadline: Prevent rt_time growth to infinity
MIME-Version: 1.0
Message-Id: <311621392984565@web3h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 21 Feb 2014 16:09:25 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



21.02.2014, 15:39, "Kirill Tkhai" <tkhai@yandex.ru>:
> 21.02.2014, 14:37, "Peter Zijlstra" <peterz@infradead.org>:
>
>> šOn Thu, Feb 20, 2014 at 02:16:00AM +0400, Kirill Tkhai wrote:
>>> ššSince deadline tasks share rt bandwidth, we must care about
>>> ššbandwidth timer set. Otherwise rt_time may grow up to infinity
>>> ššin update_curr_dl(), if there are no other available RT tasks
>>> ššon top level bandwidth.
>>>
>>> ššI'm going to decide the problem the way below. Almost untested
>>> ššbecause of I skipped almost all of recent patches which haveto be applied from lkml.
>>>
>>> ššPlease say, if I skipped anything in idea. Maybe better put
>>> ššstart_top_rt_bandwidth() into set_curr_task_dl()?
>> šHow about we only increment rt_time when there's an RT bandwidth timer
>> šactive?
>
> This case RT and DL may eat all the time:
>
> -------------- štime ------------------>
> |RT's working |DL's working|
> ----------------------------
> |rt_runtime šš| ššššššššššš|
> ----------------------------
> | šššššššrt_period šššššššš|
>
> Or at least more, than it's allowed.
>
> It looks like, if we want to limit time of high priority classes
> execution, we have to set the timer anyway.

Oh, above is confusing. Sorry.

I mean one RT task and

-----------------  time -------------------------->
|DL's working    |RT's working| |DL's working    |
--------------------------------------------------
|                |rt_runtime  | |                |
--------------------------------------------------
|                |   rt_period  |                |

In this case FAIR receives less ratio, than (rt_period-rt_runtime)/rt_period.

>> š---
>> š--- a/kernel/sched/rt.c
>> š+++ b/kernel/sched/rt.c
>> š@@ -568,6 +568,12 @@ static inline struct rt_bandwidth *sched
>
> [snipped by dumb mail client]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/
