Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3EZUui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 16:50:38 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5691 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab3EZUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 16:50:37 -0400
Message-ID: <1369601453.2259.15.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] ipc/sem.c: Bug fixes, regression fixes, v3
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 May 2013 13:50:53 -0700
In-Reply-To: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-05-26 at 11:08 +0200, Manfred Spraul wrote:
> I've split my patch into 4 parts:
> - 1: Fix-missing-wakeups-in-do_smart_update
> - 2: seperate-wait-for-zero-and-alter-tasks
> - 3: Always-use-only-one-queue-for-alter-operations
> - 4: Rename-try_atomic_semop-to-perform_atomic
> 
> Linus:
> - Patch 1 should be merged immediately: It fixes bugs,
>   the current code misses wakeups.

Nothing against this.

> - Patch 2 and 3 restore the behavior of linux <=3.0.9.
>   I would propose that they are merged, too: I can't rule out that
>   changing the priority of the wakeups breaks user space apps.
> 
> - Patch 4 is trivial, no code changes at all.
>   If 2+3 are merged, then 4 should be merged, too.
> 
> I have tested patch 1 seperately and 1+2+3+4:
> With patch 1 applied, there are no more missed wakeups.
> 
> With all 4 applied, linux-3.0.10-rc1 behaves as linux <=3.0.9.
> 
> With regards to the scalability, I do not expect any degradation:
> Operations on seperate semaphores in an array remain parallelized.

In lack of getting my swingbench DSS environment back, I ran these
changes against the semop-multi program on my laptop. For 256 threads,
with Manfred's patchset the ops/sec suffers around -7.3%.

3.10-rc2-baseline:
cpus 4, threads: 256, semaphores: 128, test duration: 30 secs
total operations: 325289276, ops/sec 10842975

-  18.14%          a.out  [kernel.kallsyms]  [k] SYSC_semtimedop                                                                             ◆
   - SYSC_semtimedop                                                                                                                         ▒
      + 97.54% SyS_semtimedop                                                                                                                ▒
      + 2.46% SyS_semop  
-   5.24%          a.out  [kernel.kallsyms]  [k] ipc_obtain_object_check                                                                     ▒
   - ipc_obtain_object_check                                                                                                                 ▒
      + 92.37% SYSC_semtimedop                                                                                                               ▒
      + 7.63% SyS_semtimedop                                                                  
-   4.67%          a.out  [kernel.kallsyms]  [k] _raw_spin_lock                                                                              ▒
   - _raw_spin_lock                                                                                                                          ▒
      + 91.98% SYSC_semtimedop                                                                                                               ▒
      + 7.89% SyS_semtimedop 


3.10-rc2-manfred:
cpus 4, threads: 256, semaphores: 128, test duration: 30 secs
total operations: 303314830, ops/sec 10110494

-  17.10%            a.out  [kernel.kallsyms]  [k] SYSC_semtimedop                                                                           ◆
   - SYSC_semtimedop                                                                                                                         ▒
      + 97.47% SyS_semtimedop                                                                                                                ▒
      + 2.53% SyS_semop
-   4.79%            a.out  [kernel.kallsyms]  [k] ipc_obtain_object_check                                                                   ▒
   - ipc_obtain_object_check                                                                                                                 ▒
      + 91.88% SYSC_semtimedop                                                                                                               ▒
      + 8.12% SyS_semtimedop 
-   4.50%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock                                                                            ▒
   - _raw_spin_lock                                                                                                                          ▒
      + 90.92% SYSC_semtimedop                                                                                                               ▒
      + 8.95% SyS_semtimedop  

3.9:
cpus 4, threads: 256, semaphores: 128, test duration: 30 secs
total operations: 151293714, ops/sec 5043123

-  59.73%           a.out  [kernel.kallsyms]  [k] _raw_spin_lock                                                                             ◆
   - _raw_spin_lock                                                                                                                          ▒
      + 98.86% ipc_lock                                                                                                                      ▒
      + 1.13% ipc_lock_check                                                                                                                 ▒
-   6.48%           a.out  [kernel.kallsyms]  [k] sys_semtimedop                                                                             ▒
   - sys_semtimedop                                                                                                                          ▒
      + 95.26% sys_semop                                                                                                                     ▒
      + 4.74% system_call_fastpath 


While I'm not happy about the [smallish] throughput impact, I'm not as
against this patchset as I was originally. I still think that such
changes, if applied, should go through the linux-next/3.11 phase as much
testing is still needed. I'd also like to see how the Oracle benchmark
behaves (yes, it should be more or less faithful to how semop-multi is
impacted).

Thanks,
Davidlohr

