Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3IVPOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 11:14:53 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53388 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3IVPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 11:14:52 -0400
Message-ID: <523F0953.3070505@gmail.com>
Date: Sun, 22 Sep 2013 23:14:27 +0800
From: Jia He <jiakernel@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com> <1379837823.5499.34.camel@marge.simpson.net> <1379838364.5499.39.camel@marge.simpson.net> <523EC97D.8020707@colorfullife.com>
In-Reply-To: <523EC97D.8020707@colorfullife.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Manfred

On Sun, 22 Sep 2013 12:42:05 +0200 from manfred@colorfullife.com wrote:
> Hi all,
>
> On 09/22/2013 10:26 AM, Mike Galbraith wrote:
>> On Sun, 2013-09-22 at 10:17 +0200, Mike Galbraith wrote:
>>> On Sun, 2013-09-22 at 10:11 +0800, Jia He wrote:
>>>> In commit 0a2b9d4c,the update of semaphore's sem_otime(last semop time)
>>>> was removed because he wanted to move setting sem->sem_otime to one
>>>> place. But after that, the initial semop() will not set the otime
>>>> because its sem_op value is 0(in semtimedop,will not change
>>>> otime if alter == 1).
>>>>
>>>> the error case:
>>>> process_a(server)       process_b(client)
>>>> semget()
>>>> semctl(SETVAL)
>>>> semop()
>>>>                          semget()
>>>>                          setctl(IP_STAT)
>>>>                          for(;;) {               <--not successful here
>>>>                            check until sem_otime > 0
>>>>                          }
> Good catch:
> Since commit 0a2b9d4c, wait-for-zero semops do not update sem_otime anymore.
>
> Let's reverse that part of my commit and move the update of sem_otime back
> into perform_atomic_semop().
>
> Jia: If perform_atomic_semop() updates sem_otime, then the update in
> do_smart_update() is not necessary anymore.
> Thus the whole logic with passing arround "semop_completed" can be removed, too.
> Are you interested in writing that patch?
>
Not all perform_atomic_semop() can cover the points of do_smart_update()
after I move the parts of updating otime.
Eg. in semctl_setval/exit_sem/etc.    That is, it seems I need to write some
other codes to update sem_otime outside perform_atomic_semop(). That
still violate your original goal---let one function do all the update otime
things.
IMO, what if just remove the condition alter in sys_semtimedop:
-        if (alter && error == 0)
+       if (error == 0)
            do_smart_update(sma, sops, nsops, 1, &tasks);
In old codes, it would set the otime even when sem_op == 0
>
>>> Why not..
>> (pokes evolution's don't-munge-me button)
>>
>> ipc,sem: Create semaphores with plausible sem_otime.
> Mike: no, your patch makes it worse:
> - wait-for-zero semops still don't update sem_otime
> - sem_otime is initialized to sem_ctime. That's not mentioned in the sysv
> standard.
>
> -- 
>     Manfred
>

