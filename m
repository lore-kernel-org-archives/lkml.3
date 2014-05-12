Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaELC4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:56:54 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:8765 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaELC4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 22:56:53 -0400
Message-ID: <1399863406.3183.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: Fix semctl(,,{GETNCNT,GETZCNT})
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Date: Sun, 11 May 2014 19:56:46 -0700
In-Reply-To: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-10 at 12:03 +0200, Manfred Spraul wrote:
> Hi all,
> 
> According to the man page of semop(), semzcnt or semncnt are increased
> exactly for the operation that couldn't proceed.
> 
> The Linux implementation always tried to be clever and to increase the counters
> for all operations that might be the reason why a task sleeps.

... and I hate the fact that we do so on demand, instead of modifying
the values when semop is called. This makes the whole semctl calls less
accurate, and in fact its mentioned in the code.

> The following patches fix that and make the code conform to the 
> documentation.
> 
> The series got fairly long, because I also noticed that semzcnt was calculated
> incorrectly.
> 
> What do you think?

I'm still going through the changes, sems make my brain hurt. But
conceptually they do make sense... and hey, if semctl(GETNCNT,GETZCNT)
calls are currently incomplete, then yeah, we should fix it.

> I ran a few test cases, and the semncnt and semzcnt counts now match
> the expectation.
> 
> Is anyone aware of an application that uses GETNCNT or GETZCNT?

Given how Oracle uses sysv semaphores I wouldn't be surprised if they
make use of these, specially GETNCNT, for something like "get the amount
of waiters" as opposed to "are there waiters"... but I'm just
speculating here.

I did find that LTP does some calls to GETZNCT, GETNCNT, and these
patches do not break those tests. However, they are pretty bogus since
they always test for zero. That reminds me, it might be worthwhile
adding some more tests in the selftests/ipc dir, we only have some
trivial msgq program, for the rest I pretty much rely on LTP for
correctness runs.

Thanks,
Davidlohr

