Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3IVKmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:42:11 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:35959 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab3IVKmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:42:09 -0400
Message-ID: <523EC97D.8020707@colorfullife.com>
Date: Sun, 22 Sep 2013 12:42:05 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Jia He <jiakernel@gmail.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com> <1379837823.5499.34.camel@marge.simpson.net> <1379838364.5499.39.camel@marge.simpson.net>
In-Reply-To: <1379838364.5499.39.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 09/22/2013 10:26 AM, Mike Galbraith wrote:
> On Sun, 2013-09-22 at 10:17 +0200, Mike Galbraith wrote:
>> On Sun, 2013-09-22 at 10:11 +0800, Jia He wrote:
>>> In commit 0a2b9d4c,the update of semaphore's sem_otime(last semop time)
>>> was removed because he wanted to move setting sem->sem_otime to one
>>> place. But after that, the initial semop() will not set the otime
>>> because its sem_op value is 0(in semtimedop,will not change
>>> otime if alter == 1).
>>>
>>> the error case:
>>> process_a(server)       process_b(client)
>>> semget()
>>> semctl(SETVAL)
>>> semop()
>>>                          semget()
>>>                          setctl(IP_STAT)
>>>                          for(;;) {               <--not successful here
>>>                            check until sem_otime > 0
>>>                          }
Good catch:
Since commit 0a2b9d4c, wait-for-zero semops do not update sem_otime anymore.

Let's reverse that part of my commit and move the update of sem_otime 
back into perform_atomic_semop().

Jia: If perform_atomic_semop() updates sem_otime, then the update in 
do_smart_update() is not necessary anymore.
Thus the whole logic with passing arround "semop_completed" can be 
removed, too.
Are you interested in writing that patch?


>> Why not..
> (pokes evolution's don't-munge-me button)
>
> ipc,sem: Create semaphores with plausible sem_otime.
Mike: no, your patch makes it worse:
- wait-for-zero semops still don't update sem_otime
- sem_otime is initialized to sem_ctime. That's not mentioned in the 
sysv standard.

--
     Manfred
