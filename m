Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbbAMJ1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:27:08 -0500
Received: from forward3m.mail.yandex.net ([37.140.138.3]:47868 "EHLO
	forward3m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbAMJ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:27:06 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Juri Lelli <juri.lelli@arm.com>, Luca Abeni <luca.abeni@unitn.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
In-Reply-To: <54B4D2DF.9010308@arm.com>
References: <20141230002738.6c12db31@utopia>	 <2629881420411885@web9m.yandex.ru> <54AAABFB.3060109@unitn.it>	 <1420499241.3361.14.camel@yandex.ru> <20150107080155.1d42d123@luca-1225C> <1420633741.12772.10.camel@yandex.ru> <54B4D2DF.9010308@arm.com>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
MIME-Version: 1.0
Message-Id: <4500351421141200@web2m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 13 Jan 2015 12:26:40 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Juri,

13.01.2015, 11:10, "Juri Lelli" <juri.lelli@arm.com>:
> Hi all,
>
> really sorry for the huge delay in replying to this! :(
>
> On 07/01/2015 12:29, Kirill Tkhai wrote:
>> šOn óÒ, 2015-01-07 at 08:01 +0100, Luca Abeni wrote:
>>> šHi Kirill,
>>>
>>> šOn Tue, 06 Jan 2015 02:07:21 +0300
>>> šKirill Tkhai <tkhai@yandex.ru> wrote:
>>>> šOn ðÎ, 2015-01-05 at 16:21 +0100, Luca Abeni wrote:
>>> š[...]
>>>>> šFor reference, I attach the patch I am using locally (based on what
>>>>> šI suggested in my previous mail) and seems to work fine here.
>>>>>
>>>>> šBased on your comments, I suspect my patch can be further
>>>>> šsimplified by moving the call to init_dl_task_timer() in
>>>>> š__sched_fork().
>>>> šIt seems this way has problems. The first one is that task may become
>>>> šthrottled again, and we will start dl_timer again.
>>> šWell, in my understanding if I change the parameters of a
>>> šSCHED_DEADLINE task when it is throttled, it stays throttled... So, the
>>> štask might not become throttled again before the dl timer fires.
>>> šSo, I hoped this problem does not exist. But I might be wrong.
>> šYou keep zeroing of dl_se->dl_throttled, and further enqueue_task()
>> šplaces it on the dl_rq. So, further update_curr_dl() may make it throttled
>> šagain, and it will try to start dl_timer (which is already set).
>>>> šThe second is that
>>>> šit's better to minimize number of combination of situations we have.
>>>> šLet's keep only one combination: timer is set <-> task is throttled.
>>> šYes, this was my goal too... So, if I change the parameters of a task
>>> šwhen it is throttled, I leave dl_throttled set to 1 and I leave the
>>> štimer active.
>> šAs I see,
>>
>> šdl_se->dl_throttled = 0;
>>
>> šis still in __setparam_dl() after your patch, so you do not leave
>> šit set to 1.
>>> š[...]
>>>>>> š@@ -3250,16 +3251,19 @@ static void
>>>>>> ššš__setparam_dl(struct task_struct *p, const struct sched_attr
>>>>>> š*attr) {
>>>>>> šššššššššššstruct sched_dl_entity *dl_se = &p->dl;
>>>>>> š+ šššššššstruct hrtimer *timer = &dl_se->dl_timer;
>>>>>> š+
>>>>>> š+ if (!hrtimer_active(timer) ||
>>>>>> šhrtimer_try_to_cancel(timer) != -1) {
>>>>> šJust for the sake of curiosity, why trying to cancel the timer
>>>>> š("|| hrtimer_try_to_cancel(timer)") here? If it is active, cannot
>>>>> šwe leave it active (without touching dl_throttled, dl_new and
>>>>> šdl_yielded)?
>>>>>
>>>>> šI mean: if I try to change the parameters of a task when it is
>>>>> šthrottled, I'd like it to stay throttled until the end of the
>>>>> šreservation period... Or am I missing something?
>>>> šI think that when people change task's parameters, they want the
>>>> škernel reacts on this immediately. For example, you want to kill
>>>> šthrottled deadline task. You change parameters, but nothing happens.
>>>> šI think all developers had this use case when they were debugging
>>>> šdeadline class.
>>> šI see... Different people have different requirements :)
>>> šMy goal was to do something like adaptive scheduling (or scheduling
>>> štasks with mode changes), so I did not want that changing the
>>> šscheduling parameters of a task affected the scheduling of the other
>>> štasks... But if a task exits the throttled state when I change its
>>> šparameters, it might consume much more than the reserved CPU time.
>>> šAlso, I suspect this kind of approach can be exploited by malicious
>>> šusers: if I create a task with runtime 30ms and period 100ms, and I
>>> šchange its scheduling parameters (to runtime=29ms and back) frequently
>>> šenough, I can consume much more than 30% of the CPU time...
>
> Well, I'm inclined to agree to Luca's viewpoint. We should not change
> parameters of a throttled task or we may affect other tasks.

Could you explain your viewpoint more? How does this affects other tasks?

As I understand, in __setparam_dl() we are sure that there is enough
dl_bw. In __sched_setscheduler() we call it after dl_overflow() check.

>>> šAnyway, I am fine with every patch that fixes the bug :)
>> šDeadline class requires root privileges. So, I do not see a problem
>> šhere. Please, see __sched_setscheduler().
>>
>> šIf in the future we allow non-privileged users to increase deadline,
>> šwe will reflect that in __setparam_dl() too.
>
> I'd say it is better to implement the right behavior even for root, so
> that we will find it right when we'll grant access to non root users
> too. Also, even if root can do everything, we always try not to break
> guarantees that come with admission control (root or non root that is).
