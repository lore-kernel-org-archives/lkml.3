Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbbAGMpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:45:16 -0500
Received: from mail3.unitn.it ([193.205.206.24]:62839 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbbAGMpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:45:14 -0500
Message-ID: <54AD2A56.70307@unitn.it>
Date: Wed, 07 Jan 2015 13:45:10 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: tkhai@yandex.ru
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
References: <20141230002738.6c12db31@utopia>	 <2629881420411885@web9m.yandex.ru> <54AAABFB.3060109@unitn.it>	 <1420499241.3361.14.camel@yandex.ru> <20150107080155.1d42d123@luca-1225C> <1420633741.12772.10.camel@yandex.ru>
In-Reply-To: <1420633741.12772.10.camel@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 01:29 PM, Kirill Tkhai wrote:
[...]
>>>> Based on your comments, I suspect my patch can be further
>>>> simplified by moving the call to init_dl_task_timer() in
>>>> __sched_fork().
>>>
>>> It seems this way has problems. The first one is that task may become
>>> throttled again, and we will start dl_timer again.
>> Well, in my understanding if I change the parameters of a
>> SCHED_DEADLINE task when it is throttled, it stays throttled... So, the
>> task might not become throttled again before the dl timer fires.
>> So, I hoped this problem does not exist. But I might be wrong.
>
> You keep zeroing of dl_se->dl_throttled
Right... Now that you point this out, I realize that dl_se->dl_throttled = 0
should be inside the if().

> and further enqueue_task() places it on the dl_rq.
I was under the impression that no further enqueue_task() will happen (since
the task is throttled, it is not on runqueue, so __sched_setscheduler() will
not dequeue/enqueue it).
But I am probably missing something else :)

>>> The second is that
>>> it's better to minimize number of combination of situations we have.
>>> Let's keep only one combination: timer is set <-> task is throttled.
>> Yes, this was my goal too... So, if I change the parameters of a task
>> when it is throttled, I leave dl_throttled set to 1 and I leave the
>> timer active.
>
> As I see,
>
> dl_se->dl_throttled = 0;
>
> is still in __setparam_dl() after your patch, so you do not leave
> it set to 1.
You are right, my fault.

[...]
>>> I think that when people change task's parameters, they want the
>>> kernel reacts on this immediately. For example, you want to kill
>>> throttled deadline task. You change parameters, but nothing happens.
>>> I think all developers had this use case when they were debugging
>>> deadline class.
>> I see... Different people have different requirements :)
>> My goal was to do something like adaptive scheduling (or scheduling
>> tasks with mode changes), so I did not want that changing the
>> scheduling parameters of a task affected the scheduling of the other
>> tasks... But if a task exits the throttled state when I change its
>> parameters, it might consume much more than the reserved CPU time.
>> Also, I suspect this kind of approach can be exploited by malicious
>> users: if I create a task with runtime 30ms and period 100ms, and I
>> change its scheduling parameters (to runtime=29ms and back) frequently
>> enough, I can consume much more than 30% of the CPU time...
>>
>> Anyway, I am fine with every patch that fixes the bug :)
>
> Deadline class requires root privileges. So, I do not see a problem
> here. Please, see __sched_setscheduler().
I know... But the final goal is to allow non-root users to use SCHED_DEADLINE,
so I was thinking about future problems.


> If in the future we allow non-privileged users to increase deadline,
> we will reflect that in __setparam_dl() too.
Ok.



			Thanks,
				Luca

