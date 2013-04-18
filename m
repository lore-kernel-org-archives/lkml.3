Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967027Ab3DRRX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:23:56 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35377 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935970Ab3DRRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:23:55 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC GIT PULL] nohz: Posix cpu timers handling on full dynticks
Date: Thu, 18 Apr 2013 19:23:39 +0200
Message-Id: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please consider the following branch:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-posix-timers

Posix cpu timers, perf events tick and sched clock tick need to be
handled in two parts:

1) When a posix cpu timer is enqueued, a list head in perf rotation list is added
or the sched clock is marked unstable, we need to kick the full dynticks CPUs by way
of IPIs so that they reconsider their tick state.

2) Before a full dynticks CPU decides to stop its tick, check if there are posix cpu timers
in the queue, that perf rotation list isn't empty and that sched clock is stable before
shutting down the tick.

This branch handles the first part (which is the trickiest) for posix cpu timers
and also settles the necessary infrastructure to do the same for perf and sched clock
in further pull requests.

As usual, the approach can be further optimized but it's not yet optimization time.

Thanks.

Frederic Weisbecker (3):
  nohz: New APIs to re-evaluate the tick on full dynticks CPUs
  posix_timers: Defer per process timer stop after timers processing
  posix_timers: Kick full dynticks CPUs when a posix cpu timer is armed

 include/linux/tick.h      |    4 +++
 kernel/posix-cpu-timers.c |   35 ++++++++++++++++++++++++++++--
 kernel/time/Kconfig       |    1 +
 kernel/time/tick-sched.c  |   51 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+), 3 deletions(-)

-- 
1.7.5.4

