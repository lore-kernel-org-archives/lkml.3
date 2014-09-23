Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaIWIAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:00:35 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38520 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbaIWIAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <C1476EAB93B413409890F290A20101879D8C96@ex-mbox2>
References: <1411441029-8428-1-git-send-email-zhuhui@xiaomi.com>
	<20140923041738.GA6779@kroah.com>
	<C1476EAB93B413409890F290A20101879D8C96@ex-mbox2>
Date: Tue, 23 Sep 2014 16:00:30 +0800
Message-ID: <CAL1ERfMbcQGHBdiDw2yGw82_zUT5hBk+5uFHV=SPswUY-EtXVQ@mail.gmail.com>
Subject: Re: [PATCH] Fix the issue that lowmemkiller fell into a cycle that
 try to kill a task
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: =?UTF-8?B?5pyx6L6J?= <zhuhui@xiaomi.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "vinayakm.list@gmail.com" <vinayakm.list@gmail.com>,
        "weijie.yang@samsung.com" <weijie.yang@samsung.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "teawater@gmail.com" <teawater@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:48 PM, 朱辉 <zhuhui@xiaomi.com> wrote:
>
>
> On 09/23/14 12:18, Greg KH wrote:
>> On Tue, Sep 23, 2014 at 10:57:09AM +0800, Hui Zhu wrote:
>>> The cause of this issue is when free memroy size is low and a lot of task is
>>> trying to shrink the memory, the task that is killed by lowmemkiller cannot get
>>> CPU to exit itself.
>>>
>>> Fix this issue with change the scheduling policy to SCHED_FIFO if a task's flag
>>> is TIF_MEMDIE in lowmemkiller.
>>>
>>> Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
>>> ---
>>>   drivers/staging/android/lowmemorykiller.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
>>> index b545d3d..ca1ffac 100644
>>> --- a/drivers/staging/android/lowmemorykiller.c
>>> +++ b/drivers/staging/android/lowmemorykiller.c
>>> @@ -129,6 +129,10 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
>>>
>>>              if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
>>>                  time_before_eq(jiffies, lowmem_deathpending_timeout)) {
>>> +                    struct sched_param param = { .sched_priority = 1 };
>>> +
>>> +                    if (p->policy == SCHED_NORMAL)
>>> +                            sched_setscheduler(p, SCHED_FIFO, &param);
>>
>> This seems really specific to a specific scheduler pattern now.  Isn't
>> there some other way to resolve this?

hui, how about modify lowmem_deathpending_timeout if we don't
touch scheduler pattern?

> I tried to let the task that call lowmemkiller sleep some time when it
> try to kill same task.  But it doesn't work.
> I think the issue is that the free memroy size is too low to make more
> and more tasks come to call lowmemkiller.

I am not opposed to the idea that the task which is selected to be killed
should exit ASAP.

I want to make it clear, what is problem for the existing code and which
effect we can get by applying this patch.
1. LMK count is increased, which can be reduced by applying this patch?
2. app become more sluggish?

By the way, whether we need to modify out_of_memory() which also
try to kill task?

> Thanks,
> Hui
>
>>
>> thanks,
>>
>> greg k-h
>>
