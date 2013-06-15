Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3FOLKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:10:23 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:55542 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3FOLKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:10:21 -0400
Message-ID: <51BC4B99.4050506@colorfullife.com>
Date: Sat, 15 Jun 2013 13:10:17 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com> <51BB38FA.6080607@colorfullife.com> <1371236750.5796.54.camel@marge.simpson.net>
In-Reply-To: <1371236750.5796.54.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:05 PM, Mike Galbraith wrote:
> # Events: 802K cycles
> #
> # Overhead                                      Symbol
> # ........  ..........................................
> #
>      18.42%  [k] SYSC_semtimedop
>      15.39%  [k] sem_lock
>      10.26%  [k] _raw_spin_lock
>       9.00%  [k] perform_atomic_semop
>       7.89%  [k] system_call
>       7.70%  [k] ipc_obtain_object_check
>       6.95%  [k] ipcperms
>       6.62%  [k] copy_user_generic_string
>       4.16%  [.] __semop
>       2.57%  [.] worker_thread(void*)
>       2.30%  [k] copy_from_user
>       1.75%  [k] sem_unlock
>       1.25%  [k] ipc_obtain_object
~ 280 mio ops.
2.3% copy_from_user,
9% perform_atomic_semop.

> # Events: 802K cycles
> #
> # Overhead                           Symbol
> # ........  ...............................
> #
>      17.38%  [k] SYSC_semtimedop
>      13.26%  [k] system_call
>      11.31%  [k] copy_user_generic_string
>       7.62%  [.] __semop
>       7.18%  [k] _raw_spin_lock
>       5.66%  [k] ipcperms
>       5.40%  [k] sem_lock
>       4.65%  [k] perform_atomic_semop
>       4.22%  [k] ipc_obtain_object_check
>       4.08%  [.] worker_thread(void*)
>       4.06%  [k] copy_from_user
>       2.40%  [k] ipc_obtain_object
>       1.98%  [k] pid_vnr
>       1.45%  [k] wake_up_sem_queue_do
>       1.39%  [k] sys_semop
>       1.35%  [k] sys_semtimedop
>       1.30%  [k] sem_unlock
>       1.14%  [k] security_ipc_permission
~ 700 mio ops.
4% copy_from_user -> as expected a bit more
4.6% perform_atomic_semop --> less.

Thus: Could you send the oprofile output from perform_atomic_semop()?

Perhaps that gives us a hint.

My current guess:
sem_lock() somehow ends up in lock_array.
Lock_array scans all struct sem -> transfer of that cacheline from all 
cpus to the cpu that does the lock_array..
Then the next write by the "correct" cpu causes a transfer back when 
setting sem->pid.

--
     Manfred
