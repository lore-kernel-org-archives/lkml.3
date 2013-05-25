Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3EYR4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 13:56:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab3EYR4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 13:56:03 -0400
Message-ID: <51A0FB23.3050301@redhat.com>
Date: Sat, 25 May 2013 13:55:47 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] ipc/sem.c: fix lockup, restore FIFO behavior
References: <1369495011-2586-1-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1369495011-2586-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2013 11:16 AM, Manfred Spraul wrote:
> The double coward solution:
> - wakeup stays FIFO
> - fast switch back to per-semaphore spinlock mode
>
> The patch
> a) fixes a lockup due to a missing restart.
> b) makes the wakeups again FIFO (as linux <= 3.0.9)
> c) tries to limit the time while in global lock mode as much
>     as possible. (same as linux-3.0.10-rc1)
>
> Changes:
> - the wait-for-zero operations are moved into seperate lists. Thus they can
>    be checked seperately, without rescanning the whole queue.
> - If a complex operation must sleep, then all pending change operations are
>    moved into the global queue. This allows to keep everything FIFO.
> - When all complex operations have completed, the simple ops are moved
>    back into the per-semaphore queues.
>
> Advantage:
> - FIFO. Dropping FIFO is a user visible change, and I'm a coward.

I am still not entirely convinced that FIFO is worthwhile,
but the code looks correct to me.

Acked-by: Rik van Riel <riel@redhat.com>

> - simpler check_restart logic.
> - Efficient handling of wait-for-zero semops, both simple and complex.
> - Fewer restarts in update_queue(), because pending wait-for-zero do not
>    force a restart anymore.
>
> Other changes:
> - try_atomic_semop() also performs the semop. Thus rename the function.
>
> It passes tests with qemu, but not boot-tested due to EFI problems.
>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

