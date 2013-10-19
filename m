Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3JSPR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 11:17:27 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61872 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3JSPR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 11:17:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC PATCH 0/5] nohz: Fix racy sleeptime stats v2
Date: Sat, 19 Oct 2013 17:17:16 +0200
Message-Id: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So this is a new iteration with some more changes on top of the latest discussions
we had.

Unfortunately it's not yet a real viable solution. Check out patch 4/5 for details,
I think that's too much overhead. Also it changes enough the semantics to break the
idle sleeptime accounting along the way. This is because moving the accounting to
io_schedule() makes it account _all_ IO sleeptime, even if the CPU is still busy,
not just when it is idle like before. As a result, the idle sleeptime, that relies on
a diff against the io sleeptime, is broken.

Anyway, my hope with this new take is mostly to launch a discussion with a fresher
base and see if we can find better ideas.

Thanks!

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	sched/iowait

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      nohz: Convert a few places to use local per cpu accesses
      nohz: Only update sleeptime stats locally
      timer: Change idle/iowait accounting semantics
      sched: Refactor iowait accounting
      nohz: Synchronize sleep time stats with seqlock


 include/linux/ktime.h        |   7 +++
 include/linux/sched.h        |   1 +
 include/linux/tick.h         |  11 ++--
 kernel/sched/core.c          |  68 ++++++++++++++++++---
 kernel/sched/cputime.c       |   2 +-
 kernel/sched/sched.h         |   5 +-
 kernel/softirq.c             |   4 +-
 kernel/time/tick-broadcast.c |   6 +-
 kernel/time/tick-internal.h  |   4 +-
 kernel/time/tick-sched.c     | 138 ++++++++++++++-----------------------------
 kernel/time/timer_list.c     |   3 +-
 11 files changed, 130 insertions(+), 119 deletions(-)
