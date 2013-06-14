Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab3FNPik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:38:40 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:49373 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3FNPii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:38:38 -0400
Message-ID: <51BB38FA.6080607@colorfullife.com>
Date: Fri, 14 Jun 2013 17:38:34 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 06/10/2013 07:16 PM, Manfred Spraul wrote:
> Hi Andrew,
>
> I have cleaned up/improved my updates to sysv sem.
> Could you replace my patches in -akpm with this series?
>
> - 1: cacheline align output from ipc_rcu_alloc
> - 2: cacheline align semaphore structures
> - 3: seperate-wait-for-zero-and-alter-tasks
> - 4: Always-use-only-one-queue-for-alter-operations
> - 5: Replace the global sem_otime with a distributed otime
> - 6: Rename-try_atomic_semop-to-perform_atomic
Just to keep everyone updated:
I have updated my testapp:
https://github.com/manfred-colorfu/ipcscale/blob/master/sem-waitzero.cpp

Something like this gives a nice output:

     # sem-waitzero -t 5 -m 0 | grep 'Cpus' | gawk '{printf("%f - 
%s\n",$7/$2,$0);}' | sort -n -r

The first number is the number of operations per cpu during 5 seconds.

Mike was kind enough to run in on a 32-core (4-socket) Intel system:
- master doesn't scale at all when multiple sockets are used:
     interleave 4: (i.e.: use cpu 0, then 4, then 8 (2nd socket), then 12):
         34,717586.000000 - Cpus 1, interleave 4 delay 0: 34717586 in 5 secs
         24,507337.500000 - Cpus 2, interleave 4 delay 0: 49014675 in 5 secs
          3,487540.000000 - Cpus 3, interleave 4 delay 0: 10462620 in 5 secs
          2,708145.000000 - Cpus 4, interleave 4 delay 0: 10832580 in 5 secs
     interleave 8: (i.e.: use cpu 0, then 8 (2nd socket):
         34,587329.000000 - Cpus 1, interleave 8 delay 0: 34587329 in 5 secs
          7,746981.500000 - Cpus 2, interleave 8 delay 0: 15493963 in 5 secs

- with my patches applied, it scales linearly - but only sometimes
     example for good scaling (18 threads in parallel - linear scaling):
         33,928616.111111 - Cpus 18, interleave 8 delay 0: 610715090 in 
5 secs
     example for bad scaling:
         5,829109.600000 - Cpus 5, interleave 8 delay 0: 29145548 in 5 secs

For me, it looks like a livelock somewhere:
Good example: all threads contribute the same amount to the final result:
> Result matrix:
>   Thread   0: 33476433
>   Thread   1: 33697100
>   Thread   2: 33514249
>   Thread   3: 33657413
>   Thread   4: 33727959
>   Thread   5: 33580684
>   Thread   6: 33530294
>   Thread   7: 33666761
>   Thread   8: 33749836
>   Thread   9: 32636493
>   Thread  10: 33550620
>   Thread  11: 33403314
>   Thread  12: 33594457
>   Thread  13: 33331920
>   Thread  14: 33503588
>   Thread  15: 33585348
> Cpus 16, interleave 8 delay 0: 536206469 in 5 secs
Bad example: one thread is as fast as it should be, others are slow:
> Result matrix:
>   Thread   0: 31629540
>   Thread   1:  5336968
>   Thread   2:  6404314
>   Thread   3:  9190595
>   Thread   4:  9681006
>   Thread   5:  9935421
>   Thread   6:  9424324
> Cpus 7, interleave 8 delay 0: 81602168 in 5 secs

The results are not stable: the same test is sometimes fast, sometimes slow.
I have no idea where the livelock could be and I wasn't able to notice 
anything on my i3 laptop.

Thus: Who has an idea?
What I can say is that the livelock can't be in do_smart_update(): The 
function is never called.

--
     Manfred

