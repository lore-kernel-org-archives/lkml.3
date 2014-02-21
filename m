Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbaBULjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:39:13 -0500
Received: from forward11.mail.yandex.net ([95.108.130.93]:53251 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaBULjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:39:12 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2014 06:39:12 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20140221103715.GP9987@twins.programming.kicks-ass.net>
References: <230991392848160@web13m.yandex.ru> <20140221103715.GP9987@twins.programming.kicks-ass.net>
Subject: Re: [RFC] sched/deadline: Prevent rt_time growth to infinity
MIME-Version: 1.0
Message-Id: <128831392982418@web15j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 21 Feb 2014 15:33:38 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



21.02.2014, 14:37, "Peter Zijlstra" <peterz@infradead.org>:
> On Thu, Feb 20, 2014 at 02:16:00AM +0400, Kirill Tkhai wrote:
>
>> šSince deadline tasks share rt bandwidth, we must care about
>> šbandwidth timer set. Otherwise rt_time may grow up to infinity
>> šin update_curr_dl(), if there are no other available RT tasks
>> šon top level bandwidth.
>>
>> šI'm going to decide the problem the way below. Almost untested
>> šbecause of I skipped almost all of recent patches which haveto be applied from lkml.
>>
>> šPlease say, if I skipped anything in idea. Maybe better put
>> šstart_top_rt_bandwidth() into set_curr_task_dl()?
>
> How about we only increment rt_time when there's an RT bandwidth timer
> active?

This case RT and DL may eat all the time:

--------------  time ------------------>
|RT's working |DL's working|
----------------------------
|rt_runtime   |            |
----------------------------
|        rt_period         |

Or at least more, than it's allowed.


It looks like, if we want to limit time of high priority classes
execution, we have to set the timer anyway.

> ---
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -568,6 +568,12 @@ static inline struct rt_bandwidth *sched

[snipped by dumb mail client]
