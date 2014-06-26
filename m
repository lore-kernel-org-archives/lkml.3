Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaFZJGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:06:48 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:44246 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaFZJGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:06:46 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2014 05:06:46 EDT
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE28F.6010402@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:06:23 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC PATCH 0/8] rework iowait accounting
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mail is 5th try to fix an issue that iowait of /proc/stat can
go backward. Originally reported by Tetsuo and Fernando at last year,
Mar 2013.

Previous v1-v4 were proposal to apply my patch set, but this v5 is
request for comment, with untested patches to draw up a blueprint.


[OBSERVED PROBLEM]

  Tetsuo and Fernando reported that the idle/iowait time obtained
  through /proc/stat is not monotonic.

  There were 2 causes:


  [1]: sleep stats has no exclusive control
    (This is one of what my previous patch aimed to solve)

    Since NO_HZ kernel can stop tick interrupts while the cpu
    is in idle, sleep stats (=cpu's idle time and iowait time)
    are not updated constantly. It means if we refer stats of
    idle cpu then it will contain stale values updated before
    the cpu start idle. To avoid this, kernel records timestamp
    at idle entry and provide function to return calculated
    (rather) proper stats by adding duration of idle.

    However there was no locking between readers/writer of
    the sleep stats and timestamp. So in cases if sleep stats
    are updated while calculation for reader is in progress,
    calculated stats will go wrong and lose monotonicity with
    previous/next values.

    This cause backwarding trouble in both of idle and iowait.


  [2]: zeroing nr_iowait is not tracked in long idle

    Assume that a cpu was in idle for 30 ticks, and that nr_iowait
    was dropped to 0 between 17th tick and 18th tick. In constant
    updating manner by tick interrupts, iowait get 17 ticks to be
    accounted and after that idle get 13 ticks to be accounted.

    Then, how about in NO_HZ kernel?
    Let see the following short simulation:

    * given:
    *   idle time stats: idle=1000, iowait=100
    *   stamp at idle entry: entry=50
    *   nr tasks waiting io: nr_iowait=1
    *
    * 1st reader temporary assigns delta as iowait
    * (but does not account delta to time stats)):
    *   1st reader's query @ now = 60:
    *     idle=1000
    *     iowait=110 (=100+(60-50))
    *
    * then blocked task is queued to runqueue of other active cpu,
    * woken up from io_schedule{,_timeout}() and do atomic_dec()
    * from the remote:
    *   nr_iowait=0
    *
    * and in 2nd turn reader assign delta as idle:
    *   2nd reader's query @ now = 70:
    *     idle=1020 (=1000+(70-50))
    *     iowait=100
    *
    * at last cpu wakes up @ now = 80:
    *   idle time stats: idle=1030, iowait=100

    You can see that iowait is decreased from 110 to 100.
    And there were more than 10 ticks should have been accounted
    as iowait but not accounted at all at last.

    This cause backwarding trouble only in iowait. Because nr_iowait
    is never incremented from remote cpus.


  Solution for [1] is easy - just add proper exclusive control.
  But I stumbled over the [2].



[FURTHER INVESTIGATION]

  I'd like to point following facts:

  - s390 kernel is supposed to have problem [2]

    Not only NO_HZ kernel but also s390 kernel can stop tick
    interrupts while the cpu is in idle. Therefore s390 provides
    function s390_get_idle_time() which return idle duration of
    target sleeping cpu. /proc/stat use this and "nr_iowait at
    read is performed" to get stats of idle cpu. So consecutive
    readers may do different accounting for the idle duration
    if nr_iowait have changed around them.
    (Refer 4/8 of following pseudo code set)

  - common account_idle_time() takes cputime, not tick

    account_idle_time() uses nr_iowait in this function to
    determine whether cputime given as argument should be
    accounted as idle time or iowait time. If this function was
    only called from tick interrupts and cputime was always equal
    to one tick, then it will make sense on some level.
    However it is called from non-tick accounting (for example,
    state-transition based accounting, a.k.a. VIRT_CPU_ACCOUNTING)
    codes and take long and short cputime.

    While it is OK that accounting idle duration as iowait if
    nr_iowait is greater than 0 at the end of idle state, it is
    not always OK that accounting idle duration as idle if
    nr_iowait is 0 at the end of idle state.
    (Refer 3/8 of following pseudo code set)

  - cputime's resolution is better than tick in some architecture

    Some arch using VIRT_CPU_ACCOUNTING have cputime in better
    resolution like nano seconds. Even though iowait accounting
    is performed based on tick interrupts and accounted value is
    not precise compared to other values like sys/user.


[Request for Comments]

  So, as the first step to solve this bunch of problems, I wrote
  some pseudo codes for review to check my direction. These codes
  look like usual patch set but !! _NOT_TESTED_COMPLETELY_ !!
  Now I don't have s390/ia64/ppc test box so I didn't even check
  these pass the compiler :-p

  What I want to do here is:

  - record timestamp at the end of iowait (decrement nr_iowait
    from 1 to 0) and use it for iowait time accounting
    (This idea is what PeterZ suggested)

  - use same strategy for basic tick-accounting, NO_HZ kernel,
    s390 and other VIRT_CPU_ACCOUNTING architectures.

  Still I'm concerning performance impact by changing scheduler
  core codes and also possible troubles by comparing timestamps
  from different clocks.

  These codes are based on following patch on top of v3.16-rc2:
    [PATCH] nohz: make updating sleep stats local, add seqcount

  I'd like to ask you:

    - Do you think if I continue this direction these blueprints
      would be acceptable change?

    - Or shall we kill iowait completely?

    - Are there any good workaround or band-aid for stable kernels?

  Please give me your comment and let me know if you have better
  idea to solve this problem.

  Any comments are welcome.

[References]:

  First report from Fernando:
    [RFC] iowait/idle time accounting hiccups in NOHZ kernels
    https://lkml.org/lkml/2013/3/18/962
  Steps to reproduce guided by Tetsuo:
    https://lkml.org/lkml/2013/4/1/201

  1st patchset from Frederic:
    [PATCH 0/4] nohz: Fix racy sleeptime stats
    https://lkml.org/lkml/2013/8/8/638
    [PATCH RESEND 0/4] nohz: Fix racy sleeptime stats
    https://lkml.org/lkml/2013/8/16/274

  2nd patchset from Frederic:
    [RFC PATCH 0/5] nohz: Fix racy sleeptime stats v2
    https://lkml.org/lkml/2013/10/19/86

  My previous patch set:
    [PATCH 0/2] nohz: fix idle accounting in NO_HZ kernels
    https://lkml.org/lkml/2014/3/23/256
    [PATCH 0/2 v2] nohz: fix idle accounting in NO_HZ kernels
    https://lkml.org/lkml/2014/3/30/315
    [PATCH v3 0/2] nohz: fix idle accounting in NO_HZ kernels
    https://lkml.org/lkml/2014/4/10/133
    [PATCH v4 0/2] nohz: fix idle accounting in NO_HZ kernels
    https://lkml.org/lkml/2014/4/17/120

  Further reading:
    SMP iowait stats
    https://www.kernel.org/pub/linux/kernel/people/wli/vm/iowait/iowait-2.5.45-6

Thanks,
H.Seto

---

Hidetoshi Seto (8):
      cputime, sched: record last_iowait
      cputime, nohz: handle last_iowait for nohz
      cputime: introduce account_idle_and_iowait
      cputime, s390: introduce s390_get_idle_and_iowait
      cputime, ia64: update iowait accounting
      cputime, ppc: update iowait accounting
      cputime: generic iowait accounting for VIRT_CPU_ACCOUNTING
      cputime: iowait aware idle tick accounting

 arch/ia64/kernel/time.c         |   43 +++++++++++++++++-
 arch/powerpc/kernel/time.c      |   21 +++++++--
 arch/s390/include/asm/cputime.h |    5 +-
 arch/s390/kernel/vtime.c        |   40 ++++++++++++++---
 fs/proc/stat.c                  |   20 +++++---
 include/linux/kernel_stat.h     |    1 +
 include/linux/sched.h           |    1 +
 include/linux/vtime.h           |    3 +
 kernel/sched/core.c             |   70 ++++++++++++++++++++++++-----
 kernel/sched/cputime.c          |   93 ++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h            |    5 ++-
 kernel/time/tick-sched.c        |   48 +++++++++++++++-----
 12 files changed, 290 insertions(+), 60 deletions(-)


