Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3IYDGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:06:06 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:51854 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IYDGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:06:04 -0400
Message-ID: <52425316.8060101@gmail.com>
Date: Wed, 25 Sep 2013 11:05:58 +0800
From: Jia He <jiakernel@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com> <1379837823.5499.34.camel@marge.simpson.net> <1379838364.5499.39.camel@marge.simpson.net> <523EC97D.8020707@colorfullife.com> <523F0953.3070505@gmail.com> <5241FF8D.8000407@colorfullife.com>
In-Reply-To: <5241FF8D.8000407@colorfullife.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Manfred
IIUC after reivewing your patch and src code, does it seem
sem_otime lost the chance to be updated when calling
semctl_main/semctl_setval?
In old codes, even whendo_smart_update(sma, NULL, 0, 0, &tasks),
the otime can be updated after several conditions checking.

On Tue, 24 Sep 2013 23:09:33 +0200 from manfred@colorfullife.com wrote:
> On 09/22/2013 05:14 PM, Jia He wrote:
>>   Hi Manfred
>>
>> On Sun, 22 Sep 2013 12:42:05 +0200 from manfred@colorfullife.com wrote:
>>> Hi all,
>>>
>>> On 09/22/2013 10:26 AM, Mike Galbraith wrote:
>>>> On Sun, 2013-09-22 at 10:17 +0200, Mike Galbraith wrote:
>>>>> On Sun, 2013-09-22 at 10:11 +0800, Jia He wrote:
>>>>>> In commit 0a2b9d4c,the update of semaphore's sem_otime(last semop time)
>>>>>> was removed because he wanted to move setting sem->sem_otime to one
>>>>>> place. But after that, the initial semop() will not set the otime
>>>>>> because its sem_op value is 0(in semtimedop,will not change
>>>>>> otime if alter == 1).
>>>>>>
>>>>>> the error case:
>>>>>> process_a(server)       process_b(client)
>>>>>> semget()
>>>>>> semctl(SETVAL)
>>>>>> semop()
>>>>>>                           semget()
>>>>>>                           setctl(IP_STAT)
>>>>>>                           for(;;) {               <--not successful here
>>>>>>                             check until sem_otime > 0
>>>>>>                           }
>>> Good catch:
>>> Since commit 0a2b9d4c, wait-for-zero semops do not update sem_otime anymore.
>>>
>>> Let's reverse that part of my commit and move the update of sem_otime back
>>> into perform_atomic_semop().
>>>
>>> Jia: If perform_atomic_semop() updates sem_otime, then the update in
>>> do_smart_update() is not necessary anymore.
>>> Thus the whole logic with passing arround "semop_completed" can be removed,
>>> too.
>>> Are you interested in writing that patch?
>>>
>> Not all perform_atomic_semop() can cover the points of do_smart_update()
>> after I move the parts of updating otime.
>> Eg. in semctl_setval/exit_sem/etc.    That is, it seems I need to write some
>> other codes to update sem_otime outside perform_atomic_semop(). That
>> still violate your original goal---let one function do all the update otime
>> things.
> No. The original goal was an optimization:
> The common case is one semop that increases a semaphore value - and that
> allows another semop that is sleeping to proceed.
> Before, this caused two get_seconds() calls.
> The current (buggy) code avoids the 2nd call.
>
>> IMO, what if just remove the condition alter in sys_semtimedop:
>> -        if (alter && error == 0)
>> +       if (error == 0)
>>              do_smart_update(sma, sops, nsops, 1, &tasks);
>> In old codes, it would set the otime even when sem_op == 0
> do_smart_update() can be expensive - thus it shouldn't be called if we didn't
> change anything.
>
> Attached is a proposed patch - fully untested. It is intended to be applied
> on top of Jia's patch.
>
> _If_ the performance degradation is too large, then the alternative would be
> to set sem_otime directly in semtimedop() for successfull non-alter operations.
>
> -- 
>     Manfred

