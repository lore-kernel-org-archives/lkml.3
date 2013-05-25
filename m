Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3EYNth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 09:49:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab3EYNtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 09:49:36 -0400
Message-ID: <51A0C166.4000503@redhat.com>
Date: Sat, 25 May 2013 09:49:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ipc/sem.c: fix lockup, restore FIFO behavior
References: <1369472095-30195-1-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1369472095-30195-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2013 04:54 AM, Manfred Spraul wrote:
> Hi Rik,
>
> I came up with a completely different approach:
>
> The patch
> a) fixes a lockup due to a missing restart.
> b) makes the code again FIFO.
>
> Changes:
> - the wait-for-zero operations are moved into seperate lists. Thus they can
>    be checked seperately, without rescanning the whole queue.
> - If a complex operating arrives, then all pending change operations are
>    moved into the global queue. This allows to keep everything FIFO.
>
> Advantage:
> - Fewer restarts in update_queue(), because pending wait-for-zero do not
>    force a restart anymore.
> - Efficient handling of wait-for-zero semops, both simple and complex.
> - FIFO. Dropping FIFO is a user visible change, and I'm a coward.
> - simpler check_restart logic.
>
> Disadvantage:
> When one complex operation arrives, then the semaphore array goes into a
> complex_present mode that always acquires the global lock. Even when the
> complex operations have completed, pending simple decrease operations
> prevent the array from switching back. The switch happens when
> there are only simple wait-for-zero semops (or no semops at all).
>
> But: Let's wait if this really exists: An application that does rarely
> complex operations (and that doesn't prefer FIFO semantics).

I do not like that downside at all.

The danger of staying in "too slow to be useful" mode forever
is really not a risk I want to take.

-- 
All rights reversed
