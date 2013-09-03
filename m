Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3ICPJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:09:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab3ICPJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:09:05 -0400
Message-ID: <5225FB6A.7020507@redhat.com>
Date: Tue, 03 Sep 2013 11:08:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave.bueso@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Jonathan Gonzalez <jgonzalez@linets.cl>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] ipc/msg.c: Fix lost wakeup in msgsnd().
References: <1378216808-2564-1-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1378216808-2564-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 10:00 AM, Manfred Spraul wrote:
> The check if the queue is full and adding current to the wait queue of pending
> msgsnd() operations (ss_add()) must be atomic.
> 
> Otherwise:
> - the thread that performs msgsnd() finds a full queue and decides to sleep.
> - the thread that performs msgrcv() calls first reads all messages from the
>   queue and then sleep, because the queue is empty.
> - the msgrcv() calls do not perform any wakeups, because the msgsnd() task
>   has not yet called ss_add().
> - then the msgsnd()-thread first calls ss_add() and then sleeps.
> Net result: msgsnd() and msgrcv() both sleep forever.
> 
> Observed with msgctl08 from ltp with a preemptible kernel.
> 
> Fix: Call ipc_lock_object() before performing the check.
> 
> The patch also moves security_msg_queue_msgsnd() under ipc_lock_object:
> - msgctl(IPC_SET) explicitely mentions that it tries to expunge any pending
>   operations that are not allowed anymore with the new permissions.
>   If security_msg_queue_msgsnd() is called without locks, then there might be
>   races.
> - it makes the patch much simpler.
> 
> Reported-by: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
