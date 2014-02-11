Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaBKSSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:18:11 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:7556 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaBKSSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:18:09 -0500
Message-ID: <52FA6941.4060102@hp.com>
Date: Tue, 11 Feb 2014 13:17:37 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 7/8] locking: Introduce qrwlock
References: <20140210195820.834693028@infradead.org> <20140210203659.796912337@infradead.org>
In-Reply-To: <20140210203659.796912337@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I had written a test program to repetitively take a single rwlock with
programmable number of threads and count their execution times. Each
thread takes the lock 5M times on a 4-socket 40-core Westmere-EX
system. I bound all the threads to different CPUs with the following
3 configurations:

  1) Both CPUs and lock are in the same node
  2) CPUs and lock are in different nodes
  3) Half of the CPUs are in same node as the lock & the other half
     are remote

The results of the test run are as follows (execution times in ms,
smaller is better, qrwlock uses MCS lock for queuing):

R:W ratio = 0:1 (write lock only)
---------------------------------
  # of            rwlock mean/std          qrwlock mean/std
threads           Local  ,    Remote          Local  ,  Remote
-------         ---------------------    ----------------------
    1           75/   0,   76/   0      44/  0,   44/  0
    2          924/   6,  818/  11     233/ 22,  685/  1
    3         1680/  67, 1676/  50     422/ 24,  640/305
    4         1727/ 402, 1661/ 620     563/ 85,  694/384
    5         2634/ 861, 2746/ 426     787/276,  829/401
    6         2969/1196, 2892/ 398     810/307,  968/451
    7         3532/1512, 3137/1109     936/387, 1060/512
    8         3979/1698, 4190/1526    1134/590, 1120/503

R:W ratio = 1:1
---------------
  # of            rwlock mean/std          qrwlock mean/std
threads           Local  ,    Remote          Local  ,  Remote
-------         ---------------------    ----------------------
    1           82/   0,   81/   0      65/  0,   65/  0
    2          844/   6,  829/   1     752/  4,  894/  2
    3         1683/  65, 1628/  29     980/ 14, 1046/ 24
    4         2661/  65, 1747/ 609    1356/ 16, 1405/ 13
    5         2227/ 868, 2887/ 395    1625/ 32, 1679/ 29
    6         2553/ 968, 3924/1319    1935/ 18, 1986/ 65
    7         3392/1325, 3674/1430    2302/ 41, 2313/ 83
    8         3822/1545, 5163/2103    2654/ 31, 2654/ 67

R:W ratio = 10:1
----------------
  # of            rwlock mean/std          qrwlock mean/std
threads           Local  ,    Remote          Local  ,  Remote
-------         ---------------------    ----------------------
    1           86/   0,   86/   0      83/  0,   83/  0
    2          656/   2,  640/   3     546/  2,  635/  1
    3         1154/  39, 1053/  64     934/ 27,  968/ 31
    4         1810/  26, 1535/ 399    1357/ 34, 1382/ 52
    5         1994/ 495, 2618/  27    1713/ 52, 1785/ 47
    6         2371/ 488, 3099/ 105    2093/ 80, 2131/ 77
    7         2846/ 751, 3068/ 689    2495/103, 2527/107
    8         3392/1009, 3566/1017    2899/130, 2928/126

For reference, I also made the same measurement for ticket spinlock with
essentially no variation in execution time between different threads:

  # of          spinlock mean
threads         Local, Remote
-------         -------------
    1            70,   70
    2           757,  779
    3          1892, 1858
    4          2818, 2794
    5          3829, 3851
    6          4957, 5069
    7          6209, 6251
    8          7524, 7564

In summary,

1) The qrwlock is always faster than the rwlock with the exception
    of about 8% slowdown with 1:1 read-write lock ratio and 2 contending
    threads on a remote lock. In the most common case of 1-socket
    system, qrwlock will not be slower than rwlock.

2) qrwlock has much less variation in execution times (more consistent
    performance) when compared with rwlock.

3) For rwlock with 2-3 contending threads, remote lock actually
    performs slightly better than local lock.

4) For qrwlock, local lock performs slightly better than remote lock
    with less variation in execution time.

As for the use of ticket lock for queuing purpose, the spinlock
performance figures above seem to suggest that it will perform worse
than MCS lock with even a few contending threads. This is especially
a problem with contending threads coming from different nodes.

Below are the performance data with half local and half remote CPUs:

# of threads = 8
R/W ratio     rwlock mean/std        qrwlock mean/std
---------    ---------------        ----------------
   0:1            3476/868           1304/484
   1:1           3452/975           2984/777
  10:1            3215/914           2963/107

The rwlock actually performs slightly better when CPUs have different access
times to the lock. The qrwlock, on the other hand, performs slightly worse
with much larger variation in execution times.

In the case of ticket spinlock with asymmetric access time (half
local CPUs, half remote CPUs), the performance data were:

# of threads         spinlock mean
------------         -------------
      2             4570
      4             9927
      6            15197
      8            20573

Ticket spinlock seems to be 3-5X slower with asymmetric access time. So
it may not be such a good idea to replace the MCS lock by a ticket
lock in qrwlock. I will take some additional measurement with your patch
to see how it perform.

-Longman

